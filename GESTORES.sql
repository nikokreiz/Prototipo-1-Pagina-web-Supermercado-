-- 1. Gestor de Ventas
-- Este procedimiento gestiona la creación de una nueva venta
CREATE OR REPLACE PROCEDURE GESTOR_NUEVA_VENTA (
    p_cod_cliente IN NUMBER,
    p_productos IN VARCHAR2, -- Formato: 'cod_producto1,cantidad1;cod_producto2,cantidad2'
    p_tipo_documento IN NUMBER,
    p_tipo_descuento IN CHAR,
    p_descuento IN NUMBER,
    p_resultado OUT NUMBER
) IS
    v_cod_venta NUMBER;
    v_subtotal NUMBER := 0;
    v_iva NUMBER := 0;
    v_neto NUMBER := 0;
    v_total NUMBER := 0;
    
    -- Variables para el parsing de productos
    v_pos1 NUMBER;
    v_pos2 NUMBER;
    v_producto VARCHAR2(100);
    v_productos_temp VARCHAR2(4000);
BEGIN
    -- Generar nuevo código de venta
    SELECT SEQ_LETG_VENTA.NEXTVAL INTO v_cod_venta FROM DUAL;
    
    -- Iniciar la venta
    INSERT INTO LETG_VENTA (
        COD_VENTA, FECHA_VENTA, FECHA_HORA, FOLIO,
        SUBTOTAL, TIPO_DESCUENTO, DESCUENTO, IVA, NETO, TOTAL_VENTA,
        ESTADO_VENTA, COD_CLIENTE_PROVEEDOR, COD_TIPO_DOCUMENTO
    ) VALUES (
        v_cod_venta, SYSDATE, SYSTIMESTAMP, 'V'||TO_CHAR(v_cod_venta, 'FM000000'),
        0, p_tipo_descuento, p_descuento, 0, 0, 0,
        'PENDIENTE', p_cod_cliente, p_tipo_documento
    );
    
    -- Procesar lista de productos
    v_productos_temp := p_productos;
    LOOP
        v_pos1 := INSTR(v_productos_temp, ';');
        
        IF v_pos1 = 0 THEN
            v_producto := v_productos_temp;
            v_productos_temp := '';
        ELSE
            v_producto := SUBSTR(v_productos_temp, 1, v_pos1 - 1);
            v_productos_temp := SUBSTR(v_productos_temp, v_pos1 + 1);
        END IF;
        
        IF v_producto IS NOT NULL THEN
            DECLARE
                v_cod_producto NUMBER;
                v_cantidad NUMBER;
                v_precio NUMBER;
                v_subtotal_producto NUMBER;
            BEGIN
                -- Separar código de producto y cantidad
                v_pos2 := INSTR(v_producto, ',');
                v_cod_producto := TO_NUMBER(SUBSTR(v_producto, 1, v_pos2 - 1));
                v_cantidad := TO_NUMBER(SUBSTR(v_producto, v_pos2 + 1));
                
                -- Obtener precio del producto
                SELECT PRECIO_VENTA INTO v_precio
                FROM LETG_PRODUCTO
                WHERE COD_PRODUCTO = v_cod_producto;
                
                -- Calcular subtotal del producto
                v_subtotal_producto := v_precio * v_cantidad;
                
                -- Insertar detalle de venta
                INSERT INTO LETG_DETALLE_VENTA (
                    COD_DETALLE_VENTA, COD_VENTA, COD_PRODUCTO,
                    CANTIDAD, PRECIO_UNITARIO, SUBTOTAL
                ) VALUES (
                    SEQ_LETG_DETALLE_VENTA.NEXTVAL, v_cod_venta, v_cod_producto,
                    v_cantidad, v_precio, v_subtotal_producto
                );
                
                -- Actualizar totales
                v_subtotal := v_subtotal + v_subtotal_producto;
            END;
        END IF;
        
        EXIT WHEN v_productos_temp IS NULL;
    END LOOP;
    
    -- Calcular totales finales
    v_iva := v_subtotal * 0.19; -- 19% IVA
    
    IF p_tipo_descuento = '$' THEN
        v_neto := v_subtotal - p_descuento;
    ELSE -- '%'
        v_neto := v_subtotal - (v_subtotal * (p_descuento/100));
    END IF;
    
    v_total := v_neto + v_iva;
    
    -- Actualizar venta con totales
    UPDATE LETG_VENTA
    SET SUBTOTAL = v_subtotal,
        IVA = v_iva,
        NETO = v_neto,
        TOTAL_VENTA = v_total
    WHERE COD_VENTA = v_cod_venta;
    
    p_resultado := v_cod_venta;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Error al crear la venta: ' || SQLERRM);
END GESTOR_NUEVA_VENTA;

-- 2. Gestor de Inventario
-- Este procedimiento gestiona los movimientos de inventario
CREATE OR REPLACE PROCEDURE GESTOR_MOVIMIENTO_INVENTARIO (
    p_tipo_movimiento IN VARCHAR2,
    p_cod_bodega IN NUMBER,
    p_cod_producto IN NUMBER,
    p_cantidad IN NUMBER,
    p_referencia IN VARCHAR2,
    p_resultado OUT NUMBER
) IS
    v_cod_movimiento NUMBER;
BEGIN
    -- Validar tipo de movimiento
    IF p_tipo_movimiento NOT IN ('ENTRADA', 'SALIDA') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Tipo de movimiento inválido');
    END IF;
    
    -- Crear movimiento
    SELECT SEQ_LETG_MOVIMIENTOS_BODEGA.NEXTVAL INTO v_cod_movimiento FROM DUAL;
    
    INSERT INTO LETG_MOVIMIENTOS_BODEGA (
        COD_MOVIMIENTO, TIPO_MOVIMIENTO, FECHA_MOVIMIENTO,
        COD_BODEGA, OBSERVACIONES
    ) VALUES (
        v_cod_movimiento, p_tipo_movimiento, SYSDATE,
        p_cod_bodega, 'Ref: ' || p_referencia
    );
    
    -- Registrar entrada o salida según corresponda
    IF p_tipo_movimiento = 'ENTRADA' THEN
        INSERT INTO LETG_ENTRADA_BODEGA (
            COD_ENTRADA, COD_MOVIMIENTO, COD_PRODUCTO,
            CANTIDAD, FECHA_RECEPCION
        ) VALUES (
            SEQ_LETG_ENTRADA_BODEGA.NEXTVAL, v_cod_movimiento, p_cod_producto,
            p_cantidad, SYSDATE
        );
    ELSE
        INSERT INTO LETG_SALIDA_BODEGA (
            COD_SALIDA, COD_MOVIMIENTO, COD_PRODUCTO,
            CANTIDAD, FECHA_DESPACHO
        ) VALUES (
            SEQ_LETG_SALIDA_BODEGA.NEXTVAL, v_cod_movimiento, p_cod_producto,
            p_cantidad, SYSDATE
        );
    END IF;
    
    p_resultado := v_cod_movimiento;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error al registrar movimiento: ' || SQLERRM);
END GESTOR_MOVIMIENTO_INVENTARIO;

-- 3. Gestor de Promociones
CREATE OR REPLACE PROCEDURE GESTOR_PROMOCION (
    p_descripcion IN VARCHAR2,
    p_tipo_promocion IN VARCHAR2,
    p_descuento IN NUMBER,
    p_fecha_inicio IN DATE,
    p_fecha_fin IN DATE,
    p_productos IN VARCHAR2, -- Lista de códigos de productos separados por coma
    p_resultado OUT NUMBER
) IS
    v_cod_promocion NUMBER;
    v_productos_temp VARCHAR2(4000);
    v_cod_producto NUMBER;
    v_pos NUMBER;
BEGIN
    -- Crear promoción
    SELECT SEQ_LETG_PROMOCION.NEXTVAL INTO v_cod_promocion FROM DUAL;
    
    INSERT INTO LETG_PROMOCION (
        COD_PROMOCION, DESCRIPCION, TIPO_PROMOCION,
        PORCENTAJE_DESCUENTO, FECHA_INICIO, FECHA_FIN
    ) VALUES (
        v_cod_promocion, p_descripcion, p_tipo_promocion,
        p_descuento, p_fecha_inicio, p_fecha_fin
    );
    
    -- Asociar productos a la promoción
    v_productos_temp := p_productos;
    LOOP
        v_pos := INSTR(v_productos_temp, ',');
        
        IF v_pos = 0 THEN
            v_cod_producto := TO_NUMBER(v_productos_temp);
            v_productos_temp := '';
        ELSE
            v_cod_producto := TO_NUMBER(SUBSTR(v_productos_temp, 1, v_pos - 1));
            v_productos_temp := SUBSTR(v_productos_temp, v_pos + 1);
        END IF;
        
        IF v_cod_producto IS NOT NULL THEN
            INSERT INTO LETG_PRODUCTO_PROMOCION (
                COD_PRODUCTO, COD_PROMOCION
            ) VALUES (
                v_cod_producto, v_cod_promocion
            );
        END IF;
        
        EXIT WHEN v_productos_temp IS NULL;
    END LOOP;
    
    p_resultado := v_cod_promocion;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error al crear promoción: ' || SQLERRM);
END GESTOR_PROMOCION;

-- 4. Gestor de Clientes
-- Este procedimiento gestiona la creación, actualización y eliminación de clientes
CREATE OR REPLACE PROCEDURE GESTOR_CLIENTE (
    p_operacion IN CHAR,
    p_cod_cliente_proveedor IN OUT NUMBER,
    p_nombre IN VARCHAR2,
    p_tipo IN VARCHAR2,
    p_resultado OUT NUMBER
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN -- Insertar
            INSERT INTO LETG_CLIENTE_PROVEEDOR (COD_CLIENTE_PROVEEDOR, NOMBRE, TIPO)
            VALUES (SEQ_LETG_CLIENTE_PROVEEDOR.NEXTVAL, p_nombre, p_tipo)
            RETURNING COD_CLIENTE_PROVEEDOR INTO p_cod_cliente_proveedor;
            
            p_resultado := p_cod_cliente_proveedor;
        
        WHEN 'U' THEN -- Actualizar
            UPDATE LETG_CLIENTE_PROVEEDOR
            SET NOMBRE = p_nombre,
                TIPO = p_tipo
            WHERE COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor;
            
            p_resultado := SQL%ROWCOUNT;
        
        WHEN 'D' THEN -- Eliminar
            DELETE FROM LETG_CLIENTE_PROVEEDOR
            WHERE COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor;
            
            p_resultado := SQL%ROWCOUNT;
        
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Operación no válida');
    END CASE;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Error en GESTOR_CLIENTE: ' || SQLERRM);
END GESTOR_CLIENTE;
-- 5. Gestor de Reabastecimiento de Productos
-- Este procedimiento gestiona el reabastecimiento de productos en la bodega
CREATE OR REPLACE PROCEDURE GESTOR_REABASTECIMIENTO (
    p_cod_producto IN NUMBER,
    p_cantidad IN NUMBER,
    p_cod_bodega IN NUMBER,
    p_proveedor IN VARCHAR2,
    p_resultado OUT NUMBER
) IS
    v_stock_actual NUMBER;
    v_cod_movimiento NUMBER;
BEGIN
    -- Verificar stock actual
    SELECT NVL(SUM(
        CASE 
            WHEN mb.TIPO_MOVIMIENTO = 'ENTRADA' THEN eb.CANTIDAD
            ELSE -sb.CANTIDAD
        END
    ), 0)
    INTO v_stock_actual
    FROM LETG_MOVIMIENTOS_BODEGA mb
    LEFT JOIN LETG_ENTRADA_BODEGA eb ON mb.COD_MOVIMIENTO = eb.COD_MOVIMIENTO
    LEFT JOIN LETG_SALIDA_BODEGA sb ON mb.COD_MOVIMIENTO = sb.COD_MOVIMIENTO
    WHERE (eb.COD_PRODUCTO = p_cod_producto OR sb.COD_PRODUCTO = p_cod_producto)
    AND mb.COD_BODEGA = p_cod_bodega;

    -- Crear movimiento de entrada
    INSERT INTO LETG_MOVIMIENTOS_BODEGA (
        COD_MOVIMIENTO, TIPO_MOVIMIENTO, FECHA_MOVIMIENTO, COD_BODEGA, OBSERVACIONES
    ) VALUES (
        SEQ_LETG_MOVIMIENTOS_BODEGA.NEXTVAL, 'ENTRADA', SYSDATE, p_cod_bodega, 'Reabastecimiento automático'
    ) RETURNING COD_MOVIMIENTO INTO v_cod_movimiento;

    -- Registrar entrada de producto
    INSERT INTO LETG_ENTRADA_BODEGA (
        COD_ENTRADA, COD_MOVIMIENTO, COD_PRODUCTO, CANTIDAD, PROVEEDOR, FECHA_RECEPCION
    ) VALUES (
        SEQ_LETG_ENTRADA_BODEGA.NEXTVAL, v_cod_movimiento, p_cod_producto, p_cantidad, p_proveedor, SYSDATE
    );

    p_resultado := v_cod_movimiento;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error en GESTOR_REABASTECIMIENTO: ' || SQLERRM);
END GESTOR_REABASTECIMIENTO; 