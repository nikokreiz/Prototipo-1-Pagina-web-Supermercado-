-- CRUD para LETG_ROL
CREATE OR REPLACE PROCEDURE CRUD_LETG_ROL (
    p_operacion CHAR,                   -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_rol IN OUT NUMBER,            -- Código del rol (para Insert se generará automáticamente)
    p_nombre_rol IN VARCHAR2 DEFAULT NULL,
    p_resultado OUT SYS_REFCURSOR       -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            p_cod_rol := SEQ_LETG_ROL.NEXTVAL;
            INSERT INTO LETG_ROL (COD_ROL, NOMBRE_ROL)
            VALUES (p_cod_rol, p_nombre_rol);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_ROL
            SET NOMBRE_ROL = p_nombre_rol
            WHERE COD_ROL = p_cod_rol;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_ROL
            WHERE COD_ROL = p_cod_rol;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_ROL, NOMBRE_ROL
                FROM LETG_ROL
                WHERE COD_ROL = p_cod_rol;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_ROL especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_ROL;

-- CRUD para LETG_USUARIO
CREATE OR REPLACE PROCEDURE CRUD_LETG_USUARIO (
    p_operacion CHAR,                   -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_usuario IN OUT NUMBER,        -- Código del usuario (para Insert se generará automáticamente)
    p_nombre IN VARCHAR2 DEFAULT NULL,
    p_password IN VARCHAR2 DEFAULT NULL,
    p_cod_rol IN NUMBER DEFAULT NULL,
    p_resultado OUT SYS_REFCURSOR       -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            p_cod_usuario := SEQ_LETG_USUARIO.NEXTVAL;
            INSERT INTO LETG_USUARIO (COD_USUARIO, NOMBRE, PASSWORD, COD_ROL)
            VALUES (p_cod_usuario, p_nombre, p_password, p_cod_rol);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_USUARIO
            SET NOMBRE = p_nombre,
                PASSWORD = p_password,
                COD_ROL = p_cod_rol
            WHERE COD_USUARIO = p_cod_usuario;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_USUARIO
            WHERE COD_USUARIO = p_cod_usuario;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_USUARIO, NOMBRE, PASSWORD, COD_ROL
                FROM LETG_USUARIO
                WHERE COD_USUARIO = p_cod_usuario;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_USUARIO especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_USUARIO;

-- CRUD para LETG_RECURSO
CREATE OR REPLACE PROCEDURE CRUD_LETG_RECURSO (
    p_operacion CHAR,                      -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_recurso IN OUT NUMBER,           -- Código del recurso (para Insert se generará automáticamente)
    p_nombre_recurso IN VARCHAR2 DEFAULT NULL,
    p_descripcion IN VARCHAR2 DEFAULT NULL,
    p_url IN VARCHAR2 DEFAULT NULL,
    p_activo IN CHAR DEFAULT NULL,
    p_resultado OUT SYS_REFCURSOR          -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            p_cod_recurso := SEQ_LETG_RECURSO.NEXTVAL;
            INSERT INTO LETG_RECURSO (COD_RECURSO, NOMBRE_RECURSO, DESCRIPCION, URL, ACTIVO)
            VALUES (p_cod_recurso, p_nombre_recurso, p_descripcion, p_url, p_activo);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_RECURSO
            SET NOMBRE_RECURSO = p_nombre_recurso,
                DESCRIPCION = p_descripcion,
                URL = p_url,
                ACTIVO = p_activo
            WHERE COD_RECURSO = p_cod_recurso;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_RECURSO
            WHERE COD_RECURSO = p_cod_recurso;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_RECURSO, NOMBRE_RECURSO, DESCRIPCION, URL, ACTIVO
                FROM LETG_RECURSO
                WHERE COD_RECURSO = p_cod_recurso;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_RECURSO especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_RECURSO;

-- CRUD para LETG_RECURSO_USUARIO
CREATE OR REPLACE PROCEDURE CRUD_LETG_RECURSO_USUARIO (
    p_operacion CHAR,                       -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_usuario IN OUT NUMBER,            -- Código del usuario
    p_cod_recurso IN OUT NUMBER,            -- Código del recurso
    p_permiso IN VARCHAR2 DEFAULT NULL,     -- Tipo de permiso
    p_resultado OUT SYS_REFCURSOR           -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_RECURSO_USUARIO (COD_USUARIO, COD_RECURSO, PERMISO)
            VALUES (p_cod_usuario, p_cod_recurso, p_permiso);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_RECURSO_USUARIO
            SET PERMISO = p_permiso
            WHERE COD_USUARIO = p_cod_usuario
            AND COD_RECURSO = p_cod_recurso;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_RECURSO_USUARIO
            WHERE COD_USUARIO = p_cod_usuario
            AND COD_RECURSO = p_cod_recurso;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_USUARIO, COD_RECURSO, PERMISO
                FROM LETG_RECURSO_USUARIO
                WHERE COD_USUARIO = p_cod_usuario
                AND COD_RECURSO = p_cod_recurso;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_USUARIO y COD_RECURSO especificados.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_RECURSO_USUARIO;

-- CRUD para LETG_CLIENTE_PROVEEDOR
CREATE OR REPLACE PROCEDURE CRUD_LETG_CLIENTE_PROVEEDOR (
    p_operacion CHAR,                        -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_cliente_proveedor IN OUT NUMBER,   -- Código del cliente/proveedor
    p_nombre IN VARCHAR2 DEFAULT NULL,       -- Nombre del cliente/proveedor
    p_tipo IN VARCHAR2 DEFAULT NULL,         -- Tipo: 'CLIENTE' o 'PROVEEDOR'
    p_resultado OUT SYS_REFCURSOR            -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_CLIENTE_PROVEEDOR (COD_CLIENTE_PROVEEDOR, NOMBRE, TIPO)
            VALUES (p_cod_cliente_proveedor, p_nombre, p_tipo);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_CLIENTE_PROVEEDOR
            SET NOMBRE = p_nombre,
                TIPO = p_tipo
            WHERE COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_CLIENTE_PROVEEDOR
            WHERE COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_CLIENTE_PROVEEDOR, NOMBRE, TIPO
                FROM LETG_CLIENTE_PROVEEDOR
                WHERE COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_CLIENTE_PROVEEDOR especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_CLIENTE_PROVEEDOR;

-- CRUD para LETG_CATEGORIA
CREATE OR REPLACE PROCEDURE CRUD_LETG_CATEGORIA (
    p_operacion CHAR,                            -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_categoria IN OUT NUMBER,               -- Código de la categoría
    p_nombre_categoria IN VARCHAR2 DEFAULT NULL, -- Nombre de la categoría
    p_resultado OUT SYS_REFCURSOR                -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_CATEGORIA (COD_CATEGORIA, NOMBRE_CATEGORIA)
            VALUES (p_cod_categoria, p_nombre_categoria);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_CATEGORIA
            SET NOMBRE_CATEGORIA = p_nombre_categoria
            WHERE COD_CATEGORIA = p_cod_categoria;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_CATEGORIA
            WHERE COD_CATEGORIA = p_cod_categoria;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_CATEGORIA, NOMBRE_CATEGORIA
                FROM LETG_CATEGORIA
                WHERE COD_CATEGORIA = p_cod_categoria;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_CATEGORIA especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_CATEGORIA;

-- CRUD para LETG_PRODUCTO
CREATE OR REPLACE PROCEDURE CRUD_LETG_PRODUCTO (
    p_operacion CHAR,                           -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_producto IN OUT NUMBER,               -- Código del producto
    p_nombre_producto IN VARCHAR2 DEFAULT NULL, -- Nombre del producto
    p_precio_venta IN NUMBER DEFAULT NULL,      -- Precio de venta
    p_cod_categoria IN NUMBER DEFAULT NULL,     -- Código de la categoría
    p_resultado OUT SYS_REFCURSOR               -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_PRODUCTO (COD_PRODUCTO, NOMBRE_PRODUCTO, PRECIO_VENTA, COD_CATEGORIA)
            VALUES (p_cod_producto, p_nombre_producto, p_precio_venta, p_cod_categoria);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_PRODUCTO
            SET NOMBRE_PRODUCTO = p_nombre_producto,
                PRECIO_VENTA = p_precio_venta,
                COD_CATEGORIA = p_cod_categoria
            WHERE COD_PRODUCTO = p_cod_producto;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_PRODUCTO
            WHERE COD_PRODUCTO = p_cod_producto;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_PRODUCTO, NOMBRE_PRODUCTO, PRECIO_VENTA, COD_CATEGORIA
                FROM LETG_PRODUCTO
                WHERE COD_PRODUCTO = p_cod_producto;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_PRODUCTO especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_PRODUCTO;

-- CRUD para LETG_PROMOCION
CREATE OR REPLACE PROCEDURE CRUD_LETG_PROMOCION (
    p_operacion CHAR,                              -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_promocion IN OUT NUMBER,                 -- Código de la promoción
    p_descripcion IN VARCHAR2 DEFAULT NULL,        -- Descripción de la promoción
    p_tipo_promocion IN VARCHAR2 DEFAULT NULL,     -- Tipo de promoción ('DESCUENTO', '2X1', etc.)
    p_porcentaje_descuento IN NUMBER DEFAULT NULL, -- Porcentaje de descuento
    p_monto_descuento IN NUMBER DEFAULT NULL,      -- Monto de descuento
    p_fecha_inicio IN DATE DEFAULT NULL,           -- Fecha de inicio
    p_fecha_fin IN DATE DEFAULT NULL,              -- Fecha de fin
    p_resultado OUT SYS_REFCURSOR                  -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_PROMOCION (COD_PROMOCION, DESCRIPCION, TIPO_PROMOCION, PORCENTAJE_DESCUENTO, MONTO_DESCUENTO, FECHA_INICIO, FECHA_FIN)
            VALUES (p_cod_promocion, p_descripcion, p_tipo_promocion, p_porcentaje_descuento, p_monto_descuento, p_fecha_inicio, p_fecha_fin);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_PROMOCION
            SET DESCRIPCION = p_descripcion,
                TIPO_PROMOCION = p_tipo_promocion,
                PORCENTAJE_DESCUENTO = p_porcentaje_descuento,
                MONTO_DESCUENTO = p_monto_descuento,
                FECHA_INICIO = p_fecha_inicio,
                FECHA_FIN = p_fecha_fin
            WHERE COD_PROMOCION = p_cod_promocion;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_PROMOCION
            WHERE COD_PROMOCION = p_cod_promocion;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_PROMOCION, DESCRIPCION, TIPO_PROMOCION, PORCENTAJE_DESCUENTO, MONTO_DESCUENTO, FECHA_INICIO, FECHA_FIN
                FROM LETG_PROMOCION
                WHERE COD_PROMOCION = p_cod_promocion;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_PROMOCION especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_PROMOCION;

-- CRUD para LETG_PRODUCTO_PROMOCION
CREATE OR REPLACE PROCEDURE CRUD_LETG_PRODUCTO_PROMOCION (
    p_operacion CHAR,                        -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_producto IN OUT NUMBER,            -- Código del producto
    p_cod_promocion IN OUT NUMBER,           -- Código de la promoción
    p_resultado OUT SYS_REFCURSOR            -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_PRODUCTO_PROMOCION (COD_PRODUCTO, COD_PROMOCION)
            VALUES (p_cod_producto, p_cod_promocion);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización (por si se desea agregar un nuevo código de promoción a un producto)
            UPDATE LETG_PRODUCTO_PROMOCION
            SET COD_PROMOCION = p_cod_promocion
            WHERE COD_PRODUCTO = p_cod_producto;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_PRODUCTO_PROMOCION
            WHERE COD_PRODUCTO = p_cod_producto
            AND COD_PROMOCION = p_cod_promocion;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_PRODUCTO, COD_PROMOCION
                FROM LETG_PRODUCTO_PROMOCION
                WHERE COD_PRODUCTO = p_cod_producto
                AND COD_PROMOCION = p_cod_promocion;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con los códigos especificados.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_PRODUCTO_PROMOCION;

-- CRUD para LETG_TIPO_DOCUMENTO
CREATE OR REPLACE PROCEDURE CRUD_LETG_TIPO_DOCUMENTO (
    p_operacion CHAR,                            -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_tipo_documento IN OUT NUMBER,          -- Código del tipo de documento
    p_nombre_documento IN VARCHAR2 DEFAULT NULL, -- Nombre del documento
    p_resultado OUT SYS_REFCURSOR                -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_TIPO_DOCUMENTO (COD_TIPO_DOCUMENTO, NOMBRE_DOCUMENTO)
            VALUES (p_cod_tipo_documento, p_nombre_documento);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_TIPO_DOCUMENTO
            SET NOMBRE_DOCUMENTO = p_nombre_documento
            WHERE COD_TIPO_DOCUMENTO = p_cod_tipo_documento;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_TIPO_DOCUMENTO
            WHERE COD_TIPO_DOCUMENTO = p_cod_tipo_documento;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_TIPO_DOCUMENTO, NOMBRE_DOCUMENTO
                FROM LETG_TIPO_DOCUMENTO
                WHERE COD_TIPO_DOCUMENTO = p_cod_tipo_documento;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_TIPO_DOCUMENTO especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_TIPO_DOCUMENTO;

-- CRUD para LETG_VENTA
CREATE OR REPLACE PROCEDURE CRUD_LETG_VENTA (
    p_operacion CHAR,                               -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_venta IN OUT NUMBER,                      -- Código de la venta
    p_fecha_venta IN DATE DEFAULT NULL,             -- Fecha de la venta
    p_fecha_hora IN TIMESTAMP DEFAULT NULL,         -- Fecha y hora exacta de la venta
    p_folio IN VARCHAR2 DEFAULT NULL,               -- Folio único de la venta
    p_subtotal IN NUMBER DEFAULT NULL,              -- Subtotal de la venta
    p_tipo_descuento IN CHAR DEFAULT NULL,          -- Tipo de descuento ('%' o '$')
    p_descuento IN NUMBER DEFAULT NULL,             -- Descuento aplicado
    p_iva IN NUMBER DEFAULT NULL,                   -- IVA aplicado
    p_neto IN NUMBER DEFAULT NULL,                  -- Neto después de descuentos e IVA
    p_total_venta IN NUMBER DEFAULT NULL,           -- Total de la venta
    p_estado_venta IN VARCHAR2 DEFAULT NULL,        -- Estado de la venta (Ejemplo: 'PAGADA', 'PENDIENTE', etc.)
    p_cod_cliente_proveedor IN NUMBER DEFAULT NULL, -- Código de cliente/proveedor
    p_cod_tipo_documento IN NUMBER DEFAULT NULL,    -- Código de tipo de documento
    p_resultado OUT SYS_REFCURSOR                   -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Insertar en la tabla temporal si el estado de la venta no es 'PAGADA'
            IF p_estado_venta != 'PAGADA' THEN
                INSERT INTO LETG_VENTA_TEMP (COD_VENTA, FECHA_VENTA, FECHA_HORA, FOLIO, SUBTOTAL, TIPO_DESCUENTO, DESCUENTO, IVA, NETO, TOTAL_VENTA, ESTADO_VENTA, COD_CLIENTE_PROVEEDOR, COD_TIPO_DOCUMENTO)
                VALUES (p_cod_venta, p_fecha_venta, p_fecha_hora, p_folio, p_subtotal, p_tipo_descuento, p_descuento, p_iva, p_neto, p_total_venta, p_estado_venta, p_cod_cliente_proveedor, p_cod_tipo_documento);
            ELSE
                -- Si la venta está 'PAGADA', insertar en la tabla principal
                INSERT INTO LETG_VENTA (COD_VENTA, FECHA_VENTA, FECHA_HORA, FOLIO, SUBTOTAL, TIPO_DESCUENTO, DESCUENTO, IVA, NETO, TOTAL_VENTA, ESTADO_VENTA, COD_CLIENTE_PROVEEDOR, COD_TIPO_DOCUMENTO)
                VALUES (p_cod_venta, p_fecha_venta, p_fecha_hora, p_folio, p_subtotal, p_tipo_descuento, p_descuento, p_iva, p_neto, p_total_venta, p_estado_venta, p_cod_cliente_proveedor, p_cod_tipo_documento);
            END IF;
            COMMIT;

        WHEN 'U' THEN
            -- Actualizar el estado de la venta, ya sea en la tabla principal o temporal
            IF p_estado_venta != 'PAGADA' THEN
                UPDATE LETG_VENTA_TEMP
                SET FECHA_VENTA = p_fecha_venta,
                    FECHA_HORA = p_fecha_hora,
                    FOLIO = p_folio,
                    SUBTOTAL = p_subtotal,
                    TIPO_DESCUENTO = p_tipo_descuento,
                    DESCUENTO = p_descuento,
                    IVA = p_iva,
                    NETO = p_neto,
                    TOTAL_VENTA = p_total_venta,
                    ESTADO_VENTA = p_estado_venta,
                    COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor,
                    COD_TIPO_DOCUMENTO = p_cod_tipo_documento
                WHERE COD_VENTA = p_cod_venta;
            ELSE
                UPDATE LETG_VENTA
                SET FECHA_VENTA = p_fecha_venta,
                    FECHA_HORA = p_fecha_hora,
                    FOLIO = p_folio,
                    SUBTOTAL = p_subtotal,
                    TIPO_DESCUENTO = p_tipo_descuento,
                    DESCUENTO = p_descuento,
                    IVA = p_iva,
                    NETO = p_neto,
                    TOTAL_VENTA = p_total_venta,
                    ESTADO_VENTA = p_estado_venta,
                    COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor,
                    COD_TIPO_DOCUMENTO = p_cod_tipo_documento
                WHERE COD_VENTA = p_cod_venta;
            END IF;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación de ventas, ya sea de la tabla principal o temporal
            IF p_estado_venta != 'PAGADA' THEN
                DELETE FROM LETG_VENTA_TEMP WHERE COD_VENTA = p_cod_venta;
            ELSE
                DELETE FROM LETG_VENTA WHERE COD_VENTA = p_cod_venta;
            END IF;
            COMMIT;

        WHEN 'S' THEN
            -- Seleccionar ventas según la operación
            IF p_estado_venta != 'PAGADA' THEN
                OPEN p_resultado FOR
                    SELECT * FROM LETG_VENTA_TEMP WHERE COD_VENTA = p_cod_venta;
            ELSE
                OPEN p_resultado FOR
                    SELECT * FROM LETG_VENTA WHERE COD_VENTA = p_cod_venta;
            END IF;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_VENTA especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_VENTA;

-- CRUD para LETG_DETALLE_VENTA
CREATE OR REPLACE PROCEDURE CRUD_LETG_DETALLE_VENTA (
    p_operacion CHAR,                         -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_detalle_venta IN OUT NUMBER,        -- Código del detalle de la venta
    p_cod_venta IN NUMBER,                    -- Código de la venta
    p_cod_producto IN NUMBER,                 -- Código del producto
    p_cantidad IN NUMBER DEFAULT NULL,        -- Cantidad del producto
    p_precio_unitario IN NUMBER DEFAULT NULL, -- Precio unitario del producto
    p_subtotal IN NUMBER DEFAULT NULL,        -- Subtotal del producto
    p_resultado OUT SYS_REFCURSOR             -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_DETALLE_VENTA (COD_DETALLE_VENTA, COD_VENTA, COD_PRODUCTO, CANTIDAD, PRECIO_UNITARIO, SUBTOTAL)
            VALUES (p_cod_detalle_venta, p_cod_venta, p_cod_producto, p_cantidad, p_precio_unitario, p_subtotal);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_DETALLE_VENTA
            SET CANTIDAD = p_cantidad,
                PRECIO_UNITARIO = p_precio_unitario,
                SUBTOTAL = p_subtotal
            WHERE COD_DETALLE_VENTA = p_cod_detalle_venta;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_DETALLE_VENTA
            WHERE COD_DETALLE_VENTA = p_cod_detalle_venta;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_DETALLE_VENTA, COD_VENTA, COD_PRODUCTO, CANTIDAD, PRECIO_UNITARIO, SUBTOTAL
                FROM LETG_DETALLE_VENTA
                WHERE COD_DETALLE_VENTA = p_cod_detalle_venta;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_DETALLE_VENTA especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_DETALLE_VENTA;

-- CRUD para LETG_METODO_PAGO
CREATE OR REPLACE PROCEDURE CRUD_LETG_METODO_PAGO (
    p_operacion CHAR,                        -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_metodo_pago IN OUT NUMBER,         -- Código del método de pago
    p_tipo_pago IN VARCHAR2 DEFAULT NULL,    -- Tipo de pago (por ejemplo, 'Efectivo', 'Tarjeta', etc.)
    p_resultado OUT SYS_REFCURSOR            -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_METODO_PAGO (COD_METODO_PAGO, TIPO_PAGO)
            VALUES (p_cod_metodo_pago, p_tipo_pago);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_METODO_PAGO
            SET TIPO_PAGO = p_tipo_pago
            WHERE COD_METODO_PAGO = p_cod_metodo_pago;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_METODO_PAGO
            WHERE COD_METODO_PAGO = p_cod_metodo_pago;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_METODO_PAGO, TIPO_PAGO
                FROM LETG_METODO_PAGO
                WHERE COD_METODO_PAGO = p_cod_metodo_pago;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_METODO_PAGO especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_METODO_PAGO;

CREATE OR REPLACE PROCEDURE CRUD_LETG_DETALLE_VENTA(
    p_operacion IN CHAR,                         -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_detalle_venta IN OUT NUMBER,        -- Código del detalle de la venta
    p_cod_venta IN NUMBER,                    -- Código de la venta
    p_cod_producto IN NUMBER,                 -- Código del producto
    p_cantidad IN NUMBER DEFAULT NULL,        -- Cantidad del producto
    p_precio_unitario IN NUMBER DEFAULT NULL, -- Precio unitario del producto
    p_subtotal IN NUMBER DEFAULT NULL,        -- Subtotal del producto
    p_resultado OUT SYS_REFCURSOR             -- Cursor de salida
) 
AS  -- Cambiado 'IS' por 'AS' (aunque ambos funcionan)
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_DETALLE_VENTA (COD_DETALLE_VENTA, COD_VENTA, COD_PRODUCTO, CANTIDAD, PRECIO_UNITARIO, SUBTOTAL)
            VALUES (p_cod_detalle_venta, p_cod_venta, p_cod_producto, p_cantidad, p_precio_unitario, p_subtotal);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_DETALLE_VENTA
            SET CANTIDAD = p_cantidad,
                PRECIO_UNITARIO = p_precio_unitario,
                SUBTOTAL = p_subtotal
            WHERE COD_DETALLE_VENTA = p_cod_detalle_venta;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_DETALLE_VENTA
            WHERE COD_DETALLE_VENTA = p_cod_detalle_venta;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_DETALLE_VENTA, COD_VENTA, COD_PRODUCTO, CANTIDAD, PRECIO_UNITARIO, SUBTOTAL
                FROM LETG_DETALLE_VENTA
                WHERE COD_DETALLE_VENTA = p_cod_detalle_venta;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_DETALLE_VENTA especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_DETALLE_VENTA;

-- CRUD para LETG_BODEGA
CREATE OR REPLACE PROCEDURE CRUD_LETG_BODEGA (
    p_operacion CHAR,                         -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_bodega IN OUT NUMBER,               -- Código de la bodega
    p_nombre_bodega IN VARCHAR2 DEFAULT NULL, -- Nombre de la bodega
    p_ubicacion IN VARCHAR2 DEFAULT NULL,     -- Ubicación de la bodega
    p_resultado OUT SYS_REFCURSOR             -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_BODEGA (COD_BODEGA, NOMBRE_BODEGA, UBICACION)
            VALUES (p_cod_bodega, p_nombre_bodega, p_ubicacion);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_BODEGA
            SET NOMBRE_BODEGA = p_nombre_bodega,
                UBICACION = p_ubicacion
            WHERE COD_BODEGA = p_cod_bodega;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_BODEGA
            WHERE COD_BODEGA = p_cod_bodega;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_BODEGA, NOMBRE_BODEGA, UBICACION
                FROM LETG_BODEGA
                WHERE COD_BODEGA = p_cod_bodega;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_BODEGA especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_BODEGA;

-- CRUD para LETG_MOVIMIENTOS_BODEGA
CREATE OR REPLACE PROCEDURE CRUD_LETG_MOVIMIENTOS_BODEGA (
    p_operacion CHAR,                           -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_movimiento IN OUT NUMBER,             -- Código del movimiento
    p_tipo_movimiento IN VARCHAR2 DEFAULT NULL, -- Tipo de movimiento ('ENTRADA' o 'SALIDA')
    p_fecha_movimiento IN DATE DEFAULT NULL,    -- Fecha del movimiento
    p_cod_bodega IN NUMBER DEFAULT NULL,        -- Código de la bodega
    p_observaciones IN VARCHAR2 DEFAULT NULL,   -- Observaciones del movimiento
    p_resultado OUT SYS_REFCURSOR               -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_MOVIMIENTOS_BODEGA (COD_MOVIMIENTO, TIPO_MOVIMIENTO, FECHA_MOVIMIENTO, COD_BODEGA, OBSERVACIONES)
            VALUES (p_cod_movimiento, p_tipo_movimiento, p_fecha_movimiento, p_cod_bodega, p_observaciones);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_MOVIMIENTOS_BODEGA
            SET TIPO_MOVIMIENTO = p_tipo_movimiento,
                FECHA_MOVIMIENTO = p_fecha_movimiento,
                COD_BODEGA = p_cod_bodega,
                OBSERVACIONES = p_observaciones
            WHERE COD_MOVIMIENTO = p_cod_movimiento;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_MOVIMIENTOS_BODEGA
            WHERE COD_MOVIMIENTO = p_cod_movimiento;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_MOVIMIENTO, TIPO_MOVIMIENTO, FECHA_MOVIMIENTO, COD_BODEGA, OBSERVACIONES
                FROM LETG_MOVIMIENTOS_BODEGA
                WHERE COD_MOVIMIENTO = p_cod_movimiento;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_MOVIMIENTO especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_MOVIMIENTOS_BODEGA;

-- CRUD para LETG_ENTRADA_BODEGA
CREATE OR REPLACE PROCEDURE CRUD_LETG_ENTRADA_BODEGA (
    p_operacion CHAR,                        -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_entrada IN OUT NUMBER,             -- Código de la entrada
    p_cod_movimiento IN NUMBER,              -- Código del movimiento
    p_cod_producto IN NUMBER,                -- Código del producto
    p_cantidad IN NUMBER,                    -- Cantidad del producto recibido
    p_proveedor IN VARCHAR2 DEFAULT NULL,    -- Nombre del proveedor
    p_fecha_recepcion IN DATE DEFAULT NULL,  -- Fecha de recepción
    p_resultado OUT SYS_REFCURSOR            -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_ENTRADA_BODEGA (COD_ENTRADA, COD_MOVIMIENTO, COD_PRODUCTO, CANTIDAD, PROVEEDOR, FECHA_RECEPCION)
            VALUES (p_cod_entrada, p_cod_movimiento, p_cod_producto, p_cantidad, p_proveedor, p_fecha_recepcion);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_ENTRADA_BODEGA
            SET COD_MOVIMIENTO = p_cod_movimiento,
                COD_PRODUCTO = p_cod_producto,
                CANTIDAD = p_cantidad,
                PROVEEDOR = p_proveedor,
                FECHA_RECEPCION = p_fecha_recepcion
            WHERE COD_ENTRADA = p_cod_entrada;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_ENTRADA_BODEGA
            WHERE COD_ENTRADA = p_cod_entrada;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_ENTRADA, COD_MOVIMIENTO, COD_PRODUCTO, CANTIDAD, PROVEEDOR, FECHA_RECEPCION
                FROM LETG_ENTRADA_BODEGA
                WHERE COD_ENTRADA = p_cod_entrada;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_ENTRADA especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_ENTRADA_BODEGA;

-- CRUD para LETG_SALIDA_BODEGA
CREATE OR REPLACE PROCEDURE CRUD_LETG_SALIDA_BODEGA (
    p_operacion CHAR,                         -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_salida IN OUT NUMBER,               -- Código de la salida
    p_cod_movimiento IN NUMBER,               -- Código del movimiento
    p_cod_producto IN NUMBER,                 -- Código del producto
    p_cantidad IN NUMBER,                     -- Cantidad del producto enviado
    p_destinatario IN VARCHAR2 DEFAULT NULL,  -- Nombre del destinatario
    p_fecha_despacho IN DATE DEFAULT NULL,    -- Fecha de despacho
    p_resultado OUT SYS_REFCURSOR             -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_SALIDA_BODEGA (COD_SALIDA, COD_MOVIMIENTO, COD_PRODUCTO, CANTIDAD, DESTINATARIO, FECHA_DESPACHO)
            VALUES (p_cod_salida, p_cod_movimiento, p_cod_producto, p_cantidad, p_destinatario, p_fecha_despacho);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_SALIDA_BODEGA
            SET COD_MOVIMIENTO = p_cod_movimiento,
                COD_PRODUCTO = p_cod_producto,
                CANTIDAD = p_cantidad,
                DESTINATARIO = p_destinatario,
                FECHA_DESPACHO = p_fecha_despacho
            WHERE COD_SALIDA = p_cod_salida;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_SALIDA_BODEGA
            WHERE COD_SALIDA = p_cod_salida;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_SALIDA, COD_MOVIMIENTO, COD_PRODUCTO, CANTIDAD, DESTINATARIO, FECHA_DESPACHO
                FROM LETG_SALIDA_BODEGA
                WHERE COD_SALIDA = p_cod_salida;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_SALIDA especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_SALIDA_BODEGA;

-- CRUD para LETG_DETALLE_MOVIMIENTO_VENTA
CREATE OR REPLACE PROCEDURE CRUD_LETG_DETALLE_MOVIMIENTO_VENTA (
    p_operacion CHAR,                        -- 'I' para Insert, 'U' para Update, 'D' para Delete, 'S' para Select
    p_cod_detalle_movimiento IN OUT NUMBER,  -- Código del detalle de movimiento
    p_cod_movimiento IN NUMBER,              -- Código del movimiento
    p_cod_venta IN NUMBER,                   -- Código de la venta
    p_cod_producto IN NUMBER,                -- Código del producto
    p_cantidad IN NUMBER,                    -- Cantidad de producto movido
    p_resultado OUT SYS_REFCURSOR            -- Cursor de salida
) IS
BEGIN
    CASE p_operacion
        WHEN 'I' THEN
            -- Inserción
            INSERT INTO LETG_DETALLE_MOVIMIENTO_VENTA (COD_DETALLE_MOVIMIENTO, COD_MOVIMIENTO, COD_VENTA, COD_PRODUCTO, CANTIDAD)
            VALUES (p_cod_detalle_movimiento, p_cod_movimiento, p_cod_venta, p_cod_producto, p_cantidad);
            COMMIT;

        WHEN 'U' THEN
            -- Actualización
            UPDATE LETG_DETALLE_MOVIMIENTO_VENTA
            SET COD_MOVIMIENTO = p_cod_movimiento,
                COD_VENTA = p_cod_venta,
                COD_PRODUCTO = p_cod_producto,
                CANTIDAD = p_cantidad
            WHERE COD_DETALLE_MOVIMIENTO = p_cod_detalle_movimiento;
            COMMIT;

        WHEN 'D' THEN
            -- Eliminación
            DELETE FROM LETG_DETALLE_MOVIMIENTO_VENTA
            WHERE COD_DETALLE_MOVIMIENTO = p_cod_detalle_movimiento;
            COMMIT;

        WHEN 'S' THEN
            -- Selección
            OPEN p_resultado FOR
                SELECT COD_DETALLE_MOVIMIENTO, COD_MOVIMIENTO, COD_VENTA, COD_PRODUCTO, CANTIDAD
                FROM LETG_DETALLE_MOVIMIENTO_VENTA
                WHERE COD_DETALLE_MOVIMIENTO = p_cod_detalle_movimiento;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con el COD_DETALLE_MOVIMIENTO especificado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END CRUD_LETG_DETALLE_MOVIMIENTO_VENTA;