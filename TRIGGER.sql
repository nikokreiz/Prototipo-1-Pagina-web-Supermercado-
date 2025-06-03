-- Trigger para actualizar inventario al registrar una entrada de bodega
CREATE OR REPLACE TRIGGER UPDATE_INVENTORY_ON_ENTRY
AFTER INSERT ON LETG_ENTRADA_BODEGA
FOR EACH ROW
BEGIN
    -- Actualizar el inventario, sumando la cantidad en la tabla LETG_SALIDA_BODEGA
    UPDATE LETG_SALIDA_BODEGA
    SET CANTIDAD = CANTIDAD + :NEW.CANTIDAD
    WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;

    -- Si no hay registros en la tabla LETG_SALIDA_BODEGA para este producto, creamos un nuevo registro (solo si el producto es nuevo)
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO LETG_SALIDA_BODEGA (COD_PRODUCTO, CANTIDAD, DESTINATARIO, FECHA_DESPACHO)
        VALUES (:NEW.COD_PRODUCTO, :NEW.CANTIDAD, 'INVENTARIO', SYSDATE);
    END IF;
END;

-- Trigger para actualizar inventario al registrar una salida de bodega
CREATE OR REPLACE TRIGGER UPDATE_INVENTORY_ON_EXIT
AFTER INSERT ON LETG_SALIDA_BODEGA
FOR EACH ROW
BEGIN
    DECLARE
        v_current_quantity NUMBER;
    BEGIN
        -- Verificar el inventario actual en la bodega
        SELECT NVL(SUM(CANTIDAD), 0)
        INTO v_current_quantity
        FROM LETG_SALIDA_BODEGA
        WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;

        -- Verificar si hay suficiente inventario para la salida
        IF v_current_quantity < :NEW.CANTIDAD THEN
            RAISE_APPLICATION_ERROR(-20005, 'No hay suficiente inventario para la salida de este producto.');
        ELSE
            -- Reducir la cantidad en el inventario
            UPDATE LETG_SALIDA_BODEGA
            SET CANTIDAD = CANTIDAD - :NEW.CANTIDAD
            WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;
        END IF;
    END;
END;

--Trigger para controlar la cantidad de inventario antes de realizar una venta
CREATE OR REPLACE TRIGGER CHECK_INVENTORY_BEFORE_SALE
BEFORE INSERT ON LETG_DETALLE_VENTA
FOR EACH ROW
DECLARE
    v_inventory_quantity NUMBER;
BEGIN
    -- Obtener la cantidad de inventario disponible en la bodega
    SELECT NVL(SUM(CANTIDAD), 0)
    INTO v_inventory_quantity
    FROM LETG_SALIDA_BODEGA
    WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;

    -- Verificar si hay suficiente inventario para realizar la venta
    IF v_inventory_quantity < :NEW.CANTIDAD THEN
        RAISE_APPLICATION_ERROR(-20006, 'No hay suficiente inventario para la venta de este producto.');
    END IF;
END;

--Trigger para actualizar inventario al realizar una venta
CREATE OR REPLACE TRIGGER UPDATE_INVENTORY_ON_SALE
AFTER INSERT ON LETG_DETALLE_VENTA
FOR EACH ROW
BEGIN
    DECLARE
        v_inventory_quantity NUMBER;
    BEGIN
        -- Obtener la cantidad de inventario disponible
        SELECT NVL(SUM(CANTIDAD), 0)
        INTO v_inventory_quantity
        FROM LETG_SALIDA_BODEGA
        WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;

        -- Verificar si hay suficiente inventario
        IF v_inventory_quantity >= :NEW.CANTIDAD THEN
            -- Reducir la cantidad de inventario en la bodega
            UPDATE LETG_SALIDA_BODEGA
            SET CANTIDAD = CANTIDAD - :NEW.CANTIDAD
            WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;
        ELSE
            RAISE_APPLICATION_ERROR(-20007, 'No hay suficiente inventario para esta venta.');
        END IF;
    END;
END;
