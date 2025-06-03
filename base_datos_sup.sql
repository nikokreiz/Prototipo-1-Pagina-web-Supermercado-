
-- Tablas

CREATE TABLE LETG_USUARIOS (
    COD_USUARIO NUMBER,
    NOMBRE VARCHAR2(50),
    PASSWORD VARCHAR2(100),
    PERFIL VARCHAR2(20) CHECK (PERFIL IN ('ADMIN', 'VENDEDOR', 'GERENTE, ALMACENISTA')),
    FECHA_CREACION DATE DEFAULT SYSDATE
    CONSTRAINT PK_LETG_USUARIOS PRIMARY KEY (COD_USUARIO)
);

CREATE TABLE LETG_PERSONA (
    COD_PERSONA NUMBER,
    NOMBRE1 VARCHAR2(50),
    NOMBRE2 VARCHAR2(50),
    APELLIDO1 VARCHAR2(50),
    APELLIDO2 VARCHAR2(50),
    EMAIL VARCHAR2(100),
    TELEFONO VARCHAR2(20),
    DIRECCION_ID NUMBER,
    CONSTRAINT PK_LETG_PERSONA PRIMARY KEY (COD_PERSONA),
    CONSTRAINT FK_LETG_PERSONA_DIRECCION FOREIGN KEY (DIRECCION_ID) REFERENCES LETG_DIRECCION(DIRECCION_ID)
);

CREATE TABLE LETG_EMPLEADO (
    COD_EMPLEADO NUMBER,
    COD_PERSONA NUMBER,
    COD_USUARIO NUMBER, 
    PUESTO VARCHAR2(50),
    FECHA_CONTRATACION DATE,
    SALARIO NUMBER,
    CONSTRAINT PK_LETG_EMPLEADO PRIMARY KEY (COD_EMPLEADO),
    CONSTRAINT FK_LETG_EMPLEADO_PERSONA FOREIGN KEY (COD_PERSONA) REFERENCES LETG_PERSONA(COD_PERSONA),
    CONSTRAINT FK_LETG_EMPLEADO_USUARIO FOREIGN KEY (COD_USUARIO) REFERENCES LETG_USUARIOS(COD_USUARIO) 
);

CREATE TABLE LETG_CLIENTE_PROVEEDOR (
    COD_CLI_PROV NUMBER,
    COD_PERSONA NUMBER,
    ES_CLIENTE BOOLEAN,
    ES_PROVEEDOR BOOLEAN,
    FECHA_REGISTRO DATE,
    PREFERENCIAS VARCHAR2(200),
    NOMBRE_PROVEEDOR VARCHAR2(100), -- Este campo solo se llenaría si es proveedor.
    CONTACTO VARCHAR2(50),
    CONSTRAINT PK_LETG_CLIENTE_PROVEEDOR PRIMARY KEY (COD_CLI_PROV),
    CONSTRAINT FK_LETG_CLIENTE_PROVEEDOR_PERSONA FOREIGN KEY (COD_PERSONA) REFERENCES LETG_PERSONA(COD_PERSONA)
);

CREATE TABLE LETG_PRODUCTO (
    COD_PRODUCTO NUMBER,
    NOMBRE_PRODUCTO VARCHAR2(100),
    PRECIO_VENTA NUMBER,
    COD_CATEGORIA NUMBER,
    STOCK NUMBER DEFAULT 0,
    CONSTRAINT PK_LETG_PRODUCTO PRIMARY KEY (COD_PRODUCTO),
    CONSTRAINT FK_LETG_PRODUCTO_CATEGORIA FOREIGN KEY (COD_CATEGORIA) REFERENCES LETG_CATEGORIA_PRODUCTO(COD_CATEGORIA)
);

CREATE TABLE LETG_VENTAS (
    COD_VENTA NUMBER,
    COD_CLIENTE NUMBER,
    COD_EMPLEADO NUMBER,
    FECHA_VENTA DATE,
    METODO_PAGO_ID NUMBER,
    TOTAL_VENTA NUMBER,
    CONSTRAINT PK_LETG_VENTAS PRIMARY KEY (COD_VENTA),
    CONSTRAINT FK_LETG_VENTAS_CLIENTE FOREIGN KEY (COD_CLIENTE) REFERENCES LETG_CLIENTE(COD_CLIENTE), 
    CONSTRAINT FK_LETG_VENTAS_EMPLEADO FOREIGN KEY (COD_EMPLEADO) REFERENCES LETG_EMPLEADO(COD_EMPLEADO), 
    CONSTRAINT FK_LETG_VENTAS_METODO_PAGO FOREIGN KEY (METODO_PAGO_ID) REFERENCES LETG_METODO_PAGO(METODO_PAGO_ID)
);

CREATE TABLE LETG_DETALLE_VENTA (
    COD_DETALLE NUMBER,
    COD_VENTA NUMBER,
    COD_PRODUCTO NUMBER,
    CANTIDAD NUMBER,
    PRECIO_UNITARIO NUMBER,
    CONSTRAINT PK_LETG_DETALLE_VENTA PRIMARY KEY (COD_DETALLE),
    CONSTRAINT FK_LETG_DETALLE_VENTA_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES LETG_PRODUCTO(COD_PRODUCTO),
    CONSTRAINT FK_LETG_DETALLE_VENTA_VENTA FOREIGN KEY (COD_VENTA) REFERENCES LETG_VENTAS(COD_VENTA)
);

CREATE TABLE LETG_PROVEEDORES_PRODUCTOS (
    COD_PROVEEDOR NUMBER,
    COD_PRODUCTO NUMBER,
    CONSTRAINT FK_LETG_PROVEEDORES_PRODUCTOS_PROVEEDOR FOREIGN KEY (COD_PROVEEDOR) REFERENCES LETG_PROVEEDOR(COD_PROVEEDOR),
    CONSTRAINT FK_LETG_PROVEEDORES_PRODUCTOS_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES LETG_PRODUCTO(COD_PRODUCTO),
    CONSTRAINT PK_LETG_PROVEEDORES_PRODUCTOS PRIMARY KEY (COD_PROVEEDOR, COD_PRODUCTO)
);

CREATE TABLE LETG_DIRECCION (
    DIRECCION_ID NUMBER,
    CALLE VARCHAR2(100),
    CIUDAD VARCHAR2(50),
    PROVINCIA VARCHAR2(50),
    CODIGO_POSTAL VARCHAR2(10),
    CONSTRAINT PK_LETG_DIRECCION PRIMARY KEY (DIRECCION_ID)
);

CREATE TABLE LETG_BODEGA (
    COD_BODEGA NUMBER,
    NOMBRE_BODEGA VARCHAR2(100),
    TIPO_BODEGA VARCHAR2(50) DEFAULT 'GENERAL',
    DIRECCION_ID NUMBER,
    CONSTRAINT PK_LETG_BODEGA PRIMARY KEY (COD_BODEGA),
    CONSTRAINT FK_LETG_BODEGA_DIRECCION FOREIGN KEY (DIRECCION_ID) REFERENCES LETG_DIRECCION(DIRECCION_ID)
);

CREATE TABLE LETG_ENTRADA_PRODUCTO (
    COD_ENTRADA NUMBER,
    COD_PRODUCTO NUMBER,
    COD_BODEGA NUMBER, -- Relación con LETG_BODEGA
    FECHA_ENTRADA DATE DEFAULT SYSDATE,
    CANTIDAD NUMBER,
    DETALLE VARCHAR2(200),
    CONSTRAINT PK_LETG_ENTRADA_PRODUCTO PRIMARY KEY (COD_ENTRADA),
    CONSTRAINT FK_LETG_ENTRADA_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES LETG_PRODUCTO(COD_PRODUCTO),
    CONSTRAINT FK_LETG_ENTRADA_BODEGA FOREIGN KEY (COD_BODEGA) REFERENCES LETG_BODEGA(COD_BODEGA)
);

CREATE TABLE LETG_SALIDA_PRODUCTO (
    COD_SALIDA NUMBER,
    COD_PRODUCTO NUMBER,
    COD_BODEGA_ORIGEN NUMBER, -- Relación con LETG_BODEGA (origen)
    COD_BODEGA_DESTINO NUMBER, -- Relación con LETG_BODEGA (destino) para traspasos
    FECHA_SALIDA DATE DEFAULT SYSDATE,
    CANTIDAD NUMBER,
    DETALLE VARCHAR2(200),
    CONSTRAINT PK_LETG_SALIDA_PRODUCTO PRIMARY KEY (COD_SALIDA),
    CONSTRAINT FK_LETG_SALIDA_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES LETG_PRODUCTO(COD_PRODUCTO),
    CONSTRAINT FK_LETG_SALIDA_BODEGA_ORIGEN FOREIGN KEY (COD_BODEGA_ORIGEN) REFERENCES LETG_BODEGA(COD_BODEGA),
    CONSTRAINT FK_LETG_SALIDA_BODEGA_DESTINO FOREIGN KEY (COD_BODEGA_DESTINO) REFERENCES LETG_BODEGA(COD_BODEGA)
);

CREATE TABLE LETG_METODO_PAGO (
    METODO_PAGO_ID NUMBER,
    TIPO_METODO VARCHAR2(50),
    DESCRIPCION VARCHAR2(100),
    CONSTRAINT PK_LETG_METODO_PAGO PRIMARY KEY (METODO_PAGO_ID)
);

CREATE TABLE LETG_CATEGORIA_PRODUCTO (
    COD_CATEGORIA NUMBER,
    NOMBRE_CATEGORIA VARCHAR2(50),
    CONSTRAINT PK_LETG_CATEGORIA_PRODUCTO PRIMARY KEY (COD_CATEGORIA)
);

CREATE TABLE LETG_PROMOCION (
    COD_PROMOCION NUMBER,
    COD_PRODUCTO NUMBER,
    DESCUENTO NUMBER,
    FECHA_INICIO DATE,
    FECHA_FIN DATE,
    CONSTRAINT PK_LETG_PROMOCION PRIMARY KEY (COD_PROMOCION),
    CONSTRAINT FK_LETG_PROMOCION_PRODUCTO FOREIGN KEY (COD_PRODUCTO) REFERENCES LETG_PRODUCTO(COD_PRODUCTO)
);

-- Funcion HASH de contraseña
CREATE OR REPLACE FUNCTION HASH_PASSWORD(p_password IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
    RETURN DBMS_UTILITY.get_hash_value(p_password, 1, 100); 
END;

-- Insertar Usuarios
CREATE OR REPLACE PROCEDURE SP_INSERT_USUARIO (
    p_nombre IN VARCHAR2,
    p_password IN VARCHAR2,
    p_perfil IN VARCHAR2
) IS
BEGIN
    INSERT INTO LETG_USUARIOS (
        COD_USUARIO,
        NOMBRE,
        PASSWORD,
        PERFIL
    ) VALUES (
        SEQ_LETG_USUARIOS.NEXTVAL,
        p_nombre,
        HASH_PASSWORD(p_password), -- Almacena la contraseña hasheada
        p_perfil
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Error al insertar el usuario');
END;

-- Validacion de Acceso
CREATE OR REPLACE PROCEDURE SP_VALIDAR_ACCESO (
    p_nombre IN VARCHAR2,
    p_password IN VARCHAR2,
    p_perfil OUT VARCHAR2
) IS
    v_usuario_found NUMBER;
BEGIN
    SELECT COUNT(*), PERFIL INTO v_usuario_found, p_perfil
    FROM LETG_USUARIOS
    WHERE NOMBRE = p_nombre AND PASSWORD = HASH_PASSWORD(p_password); -- Compara contraseñas hasheadas

    IF v_usuario_found = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Usuario o contraseña incorrectos.');
    END IF;

    -- Si es necesario, podrías registrar el acceso aquí
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error al validar el acceso: ' || SQLERRM);
END;

-- Secuencias
CREATE SEQUENCE SEQ_LETG_PERSONA
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE SEQ_LETG_PRODUCTO
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE SEQ_LETG_VENTA
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE SEQ_LETG_BODEGA
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE SEQ_LETG_TIPO_PRODUCTO
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE SEQ_LETG_MARCAS_PRODUCTOS
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE SEQ_LETG_DIRECCION
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE SEQ_LETG_EMPLEADO
START WITH 1
INCREMENT BY 1
NOCACHE 
NOCYCLE;

CREATE SEQUENCE SEQ_LETG_CLIENTE_PROVEEDOR
START WITH 1
INCREMENT BY 1
NOCACHE 
NOCYCLE;

CREATE SEQUENCE SEQ_LETG_PROMOCION 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Mantenedores (operadores CRUD)

-- Persona

-- Insertar_Persona
CREATE OR REPLACE PROCEDURE SP_INSERT_PERSONA (
    p_nombre1 VARCHAR2,
    p_nombre2 VARCHAR2,
    p_apellido1 VARCHAR2,
    p_apellido2 VARCHAR2,
    p_email VARCHAR2,
    p_telefono VARCHAR2,
    p_direccion_id NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        BEGIN
            INSERT INTO LETG_PERSONA (
                COD_PERSONA,
                NOMBRE1,
                NOMBRE2,
                APELLIDO1,
                APELLIDO2,
                EMAIL,
                TELEFONO,
                DIRECCION_ID
            ) VALUES (
                SEQ_LETG_PERSONA.NEXTVAL,  -- Generación de la clave primaria
                p_nombre1,
                p_nombre2,
                p_apellido1,
                p_apellido2,
                p_email,
                p_telefono,
                p_direccion_id
            );

            -- Confirmar la transacción si la inserción es exitosa
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'Error al insertar la persona');
        END;
    ELSE
        RAISE_APPLICATION_ERROR(-20004, 'No tiene permisos para insertar una persona');
    END IF;
END;

-- Leer_Persona
CREATE OR REPLACE PROCEDURE SP_SELECT_PERSONA (
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Abrir cursor para leer datos de personas
    OPEN p_cursor FOR
    SELECT COD_PERSONA, NOMBRE1, NOMBRE2, APELLIDO1, APELLIDO2, EMAIL, TELEFONO, DIRECCION_ID
    FROM LETG_PERSONA;
END;

-- Actualizar_Persona
CREATE OR REPLACE PROCEDURE SP_UPDATE_PERSONA (
    p_cod_persona NUMBER,
    p_nombre1 VARCHAR2,
    p_nombre2 VARCHAR2,
    p_apellido1 VARCHAR2,
    p_apellido2 VARCHAR2,
    p_email VARCHAR2,
    p_telefono VARCHAR2,
    p_direccion_id NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        BEGIN
            UPDATE LETG_PERSONA
            SET NOMBRE1 = p_nombre1,
                NOMBRE2 = p_nombre2,
                APELLIDO1 = p_apellido1,
                APELLIDO2 = p_apellido2,
                EMAIL = p_email,
                TELEFONO = p_telefono,
                DIRECCION_ID = p_direccion_id
            WHERE COD_PERSONA = p_cod_persona;

            -- Confirmar la transacción si la actualización es exitosa
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20002, 'Error al actualizar la persona');
        END;
    ELSE
        RAISE_APPLICATION_ERROR(-20005, 'No tiene permisos para actualizar una persona');
    END IF;
END;

-- Eliminar_Persona
CREATE OR REPLACE PROCEDURE SP_DELETE_PERSONA (
    p_cod_persona NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil = 'ADMIN' THEN
        BEGIN
            DELETE FROM LETG_PERSONA
            WHERE COD_PERSONA = p_cod_persona;

            -- Confirmar la transacción si la eliminación es exitosa
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20003, 'Error al eliminar la persona');
        END;
    ELSE
        RAISE_APPLICATION_ERROR(-20006, 'No tiene permisos para eliminar una persona');
    END IF;
END;

-- Empleado

-- Insertar Empleado
CREATE OR REPLACE PROCEDURE INSERTAR_EMPLEADO(
    p_cod_persona NUMBER,
    p_puesto VARCHAR2,
    p_fecha_contratacion DATE,
    p_salario NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        INSERT INTO LETG_EMPLEADO (
            COD_EMPLEADO,
            COD_PERSONA,
            PUESTO,
            FECHA_CONTRATACION,
            SALARIO
        ) VALUES (
            SEQ_LETG_EMPLEADO.NEXTVAL,  -- Usa la secuencia para autogenerar COD_EMPLEADO
            p_cod_persona,
            p_puesto,
            p_fecha_contratacion,
            p_salario
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20023, 'No tiene permisos para insertar empleados');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20016, 'Error al insertar el empleado');
END;

-- Leer Empleado
CREATE OR REPLACE PROCEDURE LEER_EMPLEADO(
    p_cod_empleado NUMBER,
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer empleado
    OPEN p_cursor FOR
    SELECT COD_EMPLEADO, COD_PERSONA, PUESTO, FECHA_CONTRATACION, SALARIO
    FROM LETG_EMPLEADO
    WHERE COD_EMPLEADO = p_cod_empleado;
END;

-- Actualizar Empleado
CREATE OR REPLACE PROCEDURE ACTUALIZAR_EMPLEADO(
    p_cod_empleado NUMBER,
    p_puesto VARCHAR2,
    p_fecha_contratacion DATE,
    p_salario NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        UPDATE LETG_EMPLEADO
        SET
            PUESTO = p_puesto,
            FECHA_CONTRATACION = p_fecha_contratacion,
            SALARIO = p_salario
        WHERE COD_EMPLEADO = p_cod_empleado;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20024, 'No tiene permisos para actualizar empleados');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20017, 'Error al actualizar el empleado');
END;

-- Eliminar Empleado
CREATE OR REPLACE PROCEDURE ELIMINAR_EMPLEADO(
    p_cod_empleado NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil = 'ADMIN' THEN
        DELETE FROM LETG_EMPLEADO
        WHERE COD_EMPLEADO = p_cod_empleado;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20025, 'No tiene permisos para eliminar empleados');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20018, 'Error al eliminar el empleado');
END;

-- Cliente_Proveedor

-- Insertar Cliente_Proveedor
CREATE OR REPLACE PROCEDURE INSERTAR_CLIENTE_PROVEEDOR(
    p_cod_persona NUMBER,
    p_tipo VARCHAR2, -- Puede ser 'CLIENTE' o 'PROVEEDOR'
    p_detalle VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        INSERT INTO LETG_CLIENTE_PROVEEDOR (
            COD_CLIENTE_PROVEEDOR,
            COD_PERSONA,
            TIPO,
            DETALLE
        ) VALUES (
            SEQ_LETG_CLIENTE_PROVEEDOR.NEXTVAL, -- Usa la secuencia para autogenerar COD_CLIENTE_PROVEEDOR
            p_cod_persona,
            p_tipo,
            p_detalle
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20026, 'No tiene permisos para insertar clientes o proveedores');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20019, 'Error al insertar el cliente o proveedor');
END;

-- Leer Cliente_Proveedor
CREATE OR REPLACE PROCEDURE LEER_CLIENTE_PROVEEDOR(
    p_cod_cliente_proveedor NUMBER,
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer cliente o proveedor
    OPEN p_cursor FOR
    SELECT COD_CLIENTE_PROVEEDOR, COD_PERSONA, TIPO, DETALLE
    FROM LETG_CLIENTE_PROVEEDOR
    WHERE COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor;
END;

-- Actualizar Cliente_Proveedor
CREATE OR REPLACE PROCEDURE ACTUALIZAR_CLIENTE_PROVEEDOR(
    p_cod_cliente_proveedor NUMBER,
    p_tipo VARCHAR2,
    p_detalle VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        UPDATE LETG_CLIENTE_PROVEEDOR
        SET
            TIPO = p_tipo,
            DETALLE = p_detalle
        WHERE COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20027, 'No tiene permisos para actualizar clientes o proveedores');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20020, 'Error al actualizar el cliente o proveedor');
END;

-- Eliminar Cliente_Proveedor
CREATE OR REPLACE PROCEDURE ELIMINAR_CLIENTE_PROVEEDOR(
    p_cod_cliente_proveedor NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil = 'ADMIN' THEN
        DELETE FROM LETG_CLIENTE_PROVEEDOR
        WHERE COD_CLIENTE_PROVEEDOR = p_cod_cliente_proveedor;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20028, 'No tiene permisos para eliminar clientes o proveedores');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20021, 'Error al eliminar el cliente o proveedor');
END;

-- Producto

-- Insertar_Producto
CREATE OR REPLACE PROCEDURE SP_INSERT_PRODUCTO (
    p_nombre IN VARCHAR2,
    p_precio IN NUMBER,
    p_stock IN NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'VENDEDOR') THEN
        INSERT INTO LETG_PRODUCTO (
            COD_PRODUCTO,
            NOMBRE,
            PRECIO,
            STOCK
        ) VALUES (
            SEQ_LETG_PRODUCTO.NEXTVAL,
            p_nombre,
            p_precio,
            p_stock
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'No tiene permisos para insertar productos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error al insertar el producto: ' || SQLERRM);
END;

-- Leer Producto
CREATE OR REPLACE PROCEDURE SP_READ_PRODUCTO (
    p_codigo IN NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
    v_producto LETG_PRODUCTO%ROWTYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer producto
    SELECT * INTO v_producto FROM LETG_PRODUCTO WHERE COD_PRODUCTO = p_codigo;

    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_producto.NOMBRE || ' - Precio: ' || v_producto.PRECIO);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Producto no encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al leer el producto: ' || SQLERRM);
END;

-- Actualizar_Producto
CREATE OR REPLACE PROCEDURE SP_UPDATE_PRODUCTO (
    p_codigo IN NUMBER,
    p_nombre IN VARCHAR2,
    p_precio IN NUMBER,
    p_stock IN NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'VENDEDOR') THEN
        UPDATE LETG_PRODUCTO
        SET NOMBRE = p_nombre,
            PRECIO = p_precio,
            STOCK = p_stock
        WHERE COD_PRODUCTO = p_codigo;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'No tiene permisos para actualizar productos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error al actualizar el producto: ' || SQLERRM);
END;

-- Eliminar_Producto
CREATE OR REPLACE PROCEDURE SP_DELETE_PRODUCTO (
    p_codigo IN NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN') THEN
        DELETE FROM LETG_PRODUCTO WHERE COD_PRODUCTO = p_codigo;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'No tiene permisos para eliminar productos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error al eliminar el producto: ' || SQLERRM);
END;

-- Entrada_Producto

-- Insertar_Entrada_Producto
CREATE OR REPLACE PROCEDURE INSERTAR_ENTRADA_PRODUCTO(
    p_cod_producto NUMBER,
    p_cantidad NUMBER,
    p_fecha DATE,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'ALMACENISTA') THEN
        INSERT INTO LETG_ENTRADA_PRODUCTO (
            COD_ENTRADA,
            COD_PRODUCTO,
            CANTIDAD,
            FECHA
        ) VALUES (
            SEQ_LETG_ENTRADA_PRODUCTO.NEXTVAL,  -- Usa la secuencia para autogenerar COD_ENTRADA
            p_cod_producto,
            p_cantidad,
            p_fecha
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20023, 'No tiene permisos para insertar entradas de productos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20016, 'Error al insertar la entrada de producto');
END;

-- Leer_Entrada_Producto
CREATE OR REPLACE PROCEDURE LEER_ENTRADA_PRODUCTO(
    p_cod_entrada NUMBER,
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer entrada de producto
    OPEN p_cursor FOR
    SELECT COD_ENTRADA, COD_PRODUCTO, CANTIDAD, FECHA
    FROM LETG_ENTRADA_PRODUCTO
    WHERE COD_ENTRADA = p_cod_entrada;
END;

-- Actualizar_Entrada_Producto
CREATE OR REPLACE PROCEDURE ACTUALIZAR_ENTRADA_PRODUCTO(
    p_cod_entrada NUMBER,
    p_cantidad NUMBER,
    p_fecha DATE,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'ALMACENISTA') THEN
        UPDATE LETG_ENTRADA_PRODUCTO
        SET
            CANTIDAD = p_cantidad,
            FECHA = p_fecha
        WHERE COD_ENTRADA = p_cod_entrada;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20024, 'No tiene permisos para actualizar entradas de productos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20017, 'Error al actualizar la entrada de producto');
END;

-- Eliminar_Entrada_Producto
CREATE OR REPLACE PROCEDURE ELIMINAR_ENTRADA_PRODUCTO(
    p_cod_entrada NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'ALMACENISTA') THEN
        DELETE FROM LETG_ENTRADA_PRODUCTO
        WHERE COD_ENTRADA = p_cod_entrada;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20025, 'No tiene permisos para eliminar entradas de productos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20018, 'Error al eliminar la entrada de producto');
END;

-- Salida_Producto

-- Insertar_Salida_Producto
CREATE OR REPLACE PROCEDURE INSERTAR_SALIDA_PRODUCTO(
    p_cod_producto NUMBER,
    p_cantidad NUMBER,
    p_fecha DATE,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'ALMACENISTA') THEN
        INSERT INTO LETG_SALIDA_PRODUCTO (
            COD_SALIDA,
            COD_PRODUCTO,
            CANTIDAD,
            FECHA
        ) VALUES (
            SEQ_LETG_SALIDA_PRODUCTO.NEXTVAL,  -- Usa la secuencia para autogenerar COD_SALIDA
            p_cod_producto,
            p_cantidad,
            p_fecha
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20023, 'No tiene permisos para insertar salidas de productos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20016, 'Error al insertar la salida de producto');
END;

-- Leer_Salida_Producto
CREATE OR REPLACE PROCEDURE LEER_SALIDA_PRODUCTO(
    p_cod_salida NUMBER,
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer salida de producto
    OPEN p_cursor FOR
    SELECT COD_SALIDA, COD_PRODUCTO, CANTIDAD, FECHA
    FROM LETG_SALIDA_PRODUCTO
    WHERE COD_SALIDA = p_cod_salida;
END;

-- Actualizar_Salida_Producto
CREATE OR REPLACE PROCEDURE ACTUALIZAR_SALIDA_PRODUCTO(
    p_cod_salida NUMBER,
    p_cantidad NUMBER,
    p_fecha DATE,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'ALMACENISTA') THEN
        UPDATE LETG_SALIDA_PRODUCTO
        SET
            CANTIDAD = p_cantidad,
            FECHA = p_fecha
        WHERE COD_SALIDA = p_cod_salida;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20024, 'No tiene permisos para actualizar salidas de productos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20017, 'Error al actualizar la salida de producto');
END;

-- Eliminar_Salida_Producto
CREATE OR REPLACE PROCEDURE ELIMINAR_SALIDA_PRODUCTO(
    p_cod_salida NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'ALMACENISTA') THEN
        DELETE FROM LETG_SALIDA_PRODUCTO
        WHERE COD_SALIDA = p_cod_salida;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20025, 'No tiene permisos para eliminar salidas de productos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20018, 'Error al eliminar la salida de producto');
END;

-- Venta

-- Insertar_Venta
CREATE OR REPLACE PROCEDURE SP_INSERT_VENTA (
    p_cod_persona NUMBER,
    p_cod_producto NUMBER,
    p_fecha DATE,
    p_cantidad NUMBER,
    p_total NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'VENDEDOR') THEN
        INSERT INTO LETG_VENTAS (
            COD_VENTA,
            COD_PERSONA,
            COD_PRODUCTO,
            FECHA,
            CANTIDAD,
            TOTAL
        ) VALUES (
            SEQ_LETG_VENTAS.NEXTVAL,
            p_cod_persona,
            p_cod_producto,
            p_fecha,
            p_cantidad,
            p_total
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20016, 'No tiene permisos para insertar ventas');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20013, 'Error al insertar la venta');
END;

-- Leer_Venta
CREATE OR REPLACE PROCEDURE SP_SELECT_VENTAS (
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer ventas
    OPEN p_cursor FOR
    SELECT COD_VENTA, COD_PERSONA, COD_PRODUCTO, FECHA, CANTIDAD, TOTAL
    FROM LETG_VENTAS;
END;

-- Actualizar_venta
CREATE OR REPLACE PROCEDURE SP_UPDATE_VENTA (
    p_cod_venta NUMBER,
    p_cod_persona NUMBER,
    p_cod_producto NUMBER,
    p_fecha DATE,
    p_cantidad NUMBER,
    p_total NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN') THEN
        UPDATE LETG_VENTAS
        SET COD_PERSONA = p_cod_persona,
            COD_PRODUCTO = p_cod_producto,
            FECHA = p_fecha,
            CANTIDAD = p_cantidad,
            TOTAL = p_total
        WHERE COD_VENTA = p_cod_venta;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20017, 'No tiene permisos para actualizar ventas');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20014, 'Error al actualizar la venta');
END;

-- Eliminar_Venta
CREATE OR REPLACE PROCEDURE SP_DELETE_VENTA (
    p_cod_venta NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN') THEN
        DELETE FROM LETG_VENTAS
        WHERE COD_VENTA = p_cod_venta;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20018, 'No tiene permisos para eliminar ventas');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20015, 'Error al eliminar la venta');
END;

-- Bodega

-- Insertar_bodega
CREATE OR REPLACE PROCEDURE SP_INSERT_BODEGA (
    p_nombre VARCHAR2,
    p_ubicacion VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        INSERT INTO LETG_BODEGA (
            COD_BODEGA,
            NOMBRE,
            UBICACION
        ) VALUES (
            SEQ_LETG_BODEGA.NEXTVAL,
            p_nombre,
            p_ubicacion
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20020, 'No tiene permisos para insertar bodegas');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20007, 'Error al insertar la bodega');
END;

-- Leer_bodega
CREATE OR REPLACE PROCEDURE SP_SELECT_BODEGAS (
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer bodegas
    OPEN p_cursor FOR
    SELECT COD_BODEGA, NOMBRE, UBICACION
    FROM LETG_BODEGA;
END;

-- Actualizar_bodega
CREATE OR REPLACE PROCEDURE SP_UPDATE_BODEGA (
    p_cod_bodega NUMBER,
    p_nombre VARCHAR2,
    p_ubicacion VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        UPDATE LETG_BODEGA
        SET NOMBRE = p_nombre,
            UBICACION = p_ubicacion
        WHERE COD_BODEGA = p_cod_bodega;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20021, 'No tiene permisos para actualizar bodegas');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20008, 'Error al actualizar la bodega');
END;

-- Eliminar bodega
CREATE OR REPLACE PROCEDURE SP_DELETE_BODEGA (
    p_cod_bodega NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil = 'ADMIN' THEN
        DELETE FROM LETG_BODEGA
        WHERE COD_BODEGA = p_cod_bodega;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20022, 'No tiene permisos para eliminar bodegas');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20009, 'Error al eliminar la bodega');
END;

-- Tipo de Producto

-- Insertar_tipo_de_producto
CREATE OR REPLACE PROCEDURE SP_INSERT_TIPO_PRODUCTO (
    p_descripcion VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        INSERT INTO LETG_TIPO_PRODUCTO (
            COD_TIPO_PRODUCTO,
            DESCRIPCION
        ) VALUES (
            SEQ_LETG_TIPO_PRODUCTO.NEXTVAL,
            p_descripcion
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20023, 'No tiene permisos para insertar tipos de producto');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20013, 'Error al insertar el tipo de producto');
END;

-- Leer_tipo_de_producto
CREATE OR REPLACE PROCEDURE SP_SELECT_TIPOS_PRODUCTO (
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer tipos de producto
    OPEN p_cursor FOR
    SELECT COD_TIPO_PRODUCTO, DESCRIPCION
    FROM LETG_TIPO_PRODUCTO;
END;

-- Actualizar_tipo_de_producto
CREATE OR REPLACE PROCEDURE SP_UPDATE_TIPO_PRODUCTO (
    p_cod_tipo_producto NUMBER,
    p_descripcion VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        UPDATE LETG_TIPO_PRODUCTO
        SET DESCRIPCION = p_descripcion
        WHERE COD_TIPO_PRODUCTO = p_cod_tipo_producto;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20024, 'No tiene permisos para actualizar tipos de producto');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20014, 'Error al actualizar el tipo de producto');
END;

-- Eliminar_tipo_de_producto
CREATE OR REPLACE PROCEDURE SP_DELETE_TIPO_PRODUCTO (
    p_cod_tipo_producto NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil = 'ADMIN' THEN
        DELETE FROM LETG_TIPO_PRODUCTO
        WHERE COD_TIPO_PRODUCTO = p_cod_tipo_producto;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20025, 'No tiene permisos para eliminar tipos de producto');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20015, 'Error al eliminar el tipo de producto');
END;

-- Marcas 

-- Insertar_marca
CREATE OR REPLACE PROCEDURE SP_INSERT_MARCA_PRODUCTO (
    p_nombre VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        INSERT INTO LETG_MARCAS_PRODUCTOS (
            COD_MARCA_PRODUCTO,
            NOMBRE
        ) VALUES (
            SEQ_LETG_MARCAS_PRODUCTOS.NEXTVAL,
            p_nombre
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20023, 'No tiene permisos para insertar marcas de producto');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20010, 'Error al insertar la marca del producto');
END;

-- Leer_marca
CREATE OR REPLACE PROCEDURE SP_SELECT_MARCAS_PRODUCTO (
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer marcas de producto
    OPEN p_cursor FOR
    SELECT COD_MARCA_PRODUCTO, NOMBRE
    FROM LETG_MARCAS_PRODUCTOS;
END;

-- Actualizar_marca
CREATE OR REPLACE PROCEDURE SP_UPDATE_MARCA_PRODUCTO (
    p_cod_marca_producto NUMBER,
    p_nombre VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        UPDATE LETG_MARCAS_PRODUCTOS
        SET NOMBRE = p_nombre
        WHERE COD_MARCA_PRODUCTO = p_cod_marca_producto;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20024, 'No tiene permisos para actualizar marcas de producto');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20011, 'Error al actualizar la marca del producto');
END;

-- Eliminar_marca
CREATE OR REPLACE PROCEDURE SP_DELETE_MARCA_PRODUCTO (
    p_cod_marca_producto NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil = 'ADMIN' THEN
        DELETE FROM LETG_MARCAS_PRODUCTOS
        WHERE COD_MARCA_PRODUCTO = p_cod_marca_producto;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20025, 'No tiene permisos para eliminar marcas de producto');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20012, 'Error al eliminar la marca del producto');
END;

-- Direccion

-- Insertar_direccion
CREATE OR REPLACE PROCEDURE SP_INSERT_DIRECCION (
    p_calle VARCHAR2,
    p_numero VARCHAR2,
    p_ciudad VARCHAR2,
    p_region VARCHAR2,
    p_pais VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        INSERT INTO LETG_DIRECCION (
            DIRECCION_ID,
            CALLE,
            NUMERO,
            CIUDAD,
            REGION,
            PAIS
        ) VALUES (
            SEQ_LETG_DIRECCION.NEXTVAL,
            p_calle,
            p_numero,
            p_ciudad,
            p_region,
            p_pais
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20023, 'No tiene permisos para insertar direcciones');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20010, 'Error al insertar la dirección');
END;

-- Leer_direccion
CREATE OR REPLACE PROCEDURE SP_SELECT_DIRECCION (
    p_cursor OUT SYS_REFCURSOR,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer direcciones
    OPEN p_cursor FOR
    SELECT DIRECCION_ID, CALLE, NUMERO, CIUDAD, REGION, PAIS
    FROM LETG_DIRECCION;
END;

-- Actualizar_direccion
CREATE OR REPLACE PROCEDURE SP_UPDATE_DIRECCION (
    p_direccion_id NUMBER,
    p_calle VARCHAR2,
    p_numero VARCHAR2,
    p_ciudad VARCHAR2,
    p_region VARCHAR2,
    p_pais VARCHAR2,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'GERENTE') THEN
        UPDATE LETG_DIRECCION
        SET
            CALLE = p_calle,
            NUMERO = p_numero,
            CIUDAD = p_ciudad,
            REGION = p_region,
            PAIS = p_pais
        WHERE DIRECCION_ID = p_direccion_id;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20024, 'No tiene permisos para actualizar direcciones');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20011, 'Error al actualizar la dirección');
END;

-- Eliminar_direccion
CREATE OR REPLACE PROCEDURE SP_DELETE_DIRECCION (
    p_direccion_id NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil = 'ADMIN' THEN
        DELETE FROM LETG_DIRECCION
        WHERE DIRECCION_ID = p_direccion_id;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20025, 'No tiene permisos para eliminar direcciones');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20012, 'Error al eliminar la dirección');
END;

-- Promocion

-- Insertar_Promocion
CREATE OR REPLACE PROCEDURE SP_INSERT_PROMOCION (
    p_codigo_producto IN NUMBER,
    p_descuento IN NUMBER,
    p_fecha_inicio IN DATE,
    p_fecha_fin IN DATE,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'VENDEDOR') THEN
        INSERT INTO LETG_PROMOCION (
            COD_PROMOCION,
            COD_PRODUCTO,
            DESCUENTO,
            FECHA_INICIO,
            FECHA_FIN
        ) VALUES (
            SEQ_LETG_PROMOCION.NEXTVAL,  
            p_codigo_producto,
            p_descuento,
            p_fecha_inicio,
            p_fecha_fin
        );

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'No tiene permisos para insertar promociones');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error al insertar la promoción: ' || SQLERRM);
END;

-- Leer_Promocion
CREATE OR REPLACE PROCEDURE SP_READ_PROMOCION (
    p_codigo IN NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
    v_promocion LETG_PROMOCION%ROWTYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Leer promoción
    SELECT * INTO v_promocion FROM LETG_PROMOCION WHERE COD_PROMOCION = p_codigo;

    DBMS_OUTPUT.PUT_LINE('Código Producto: ' || v_promocion.COD_PRODUCTO || 
                         ' - Descuento: ' || v_promocion.DESCUENTO ||
                         ' - Fecha Inicio: ' || v_promocion.FECHA_INICIO ||
                         ' - Fecha Fin: ' || v_promocion.FECHA_FIN);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Promoción no encontrada.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al leer la promoción: ' || SQLERRM);
END;

-- Actualizar_Promocion
CREATE OR REPLACE PROCEDURE SP_UPDATE_PROMOCION (
    p_codigo IN NUMBER,
    p_codigo_producto IN NUMBER,
    p_descuento IN NUMBER,
    p_fecha_inicio IN DATE,
    p_fecha_fin IN DATE,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN', 'VENDEDOR') THEN
        UPDATE LETG_PROMOCION
        SET COD_PRODUCTO = p_codigo_producto,
            DESCUENTO = p_descuento,
            FECHA_INICIO = p_fecha_inicio,
            FECHA_FIN = p_fecha_fin
        WHERE COD_PROMOCION = p_codigo;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'No tiene permisos para actualizar promociones');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error al actualizar la promoción: ' || SQLERRM);
END;

-- Eliminar_Promocion
CREATE OR REPLACE PROCEDURE SP_DELETE_PROMOCION (
    p_codigo IN NUMBER,
    p_nombre_usuario IN VARCHAR2,
    p_password_usuario IN VARCHAR2
) IS
    v_perfil LETG_USUARIOS.PERFIL%TYPE;
BEGIN
    -- Validar acceso
    SP_VALIDAR_ACCESO(p_nombre_usuario, p_password_usuario, v_perfil);

    -- Verificar permisos
    IF v_perfil IN ('ADMIN') THEN
        DELETE FROM LETG_PROMOCION WHERE COD_PROMOCION = p_codigo;

        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'No tiene permisos para eliminar promociones');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error al eliminar la promoción: ' || SQLERRM);
END;

-- Gestores

-- Gestor_Ventas
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_VENTA (
    p_cod_cliente IN NUMBER,
    p_cod_producto IN NUMBER,
    p_cantidad IN NUMBER
)
IS
    v_precio_venta NUMBER;
    v_precio_total NUMBER;
    v_stock_actual NUMBER;
BEGIN
    -- Obtener el precio del producto
    SELECT PRECIO_VENTA INTO v_precio_venta
    FROM LETG_PRODUCTO
    WHERE COD_PRODUCTO = p_cod_producto;

    -- Calcular el precio total de la venta
    v_precio_total := v_precio_venta * p_cantidad;

    -- Verificar si hay suficiente stock en las salidas y entradas de producto
    SELECT (NVL(SUM(EP.CANTIDAD), 0) - NVL(SUM(SP.CANTIDAD), 0)) INTO v_stock_actual
    FROM LETG_ENTRADA_PRODUCTO EP
    LEFT JOIN LETG_SALIDA_PRODUCTO SP ON EP.COD_PRODUCTO = SP.COD_PRODUCTO
    WHERE EP.COD_PRODUCTO = p_cod_producto;

    IF v_stock_actual >= p_cantidad THEN
        -- Registrar la venta
        INSERT INTO LETG_VENTA (COD_VENTA, COD_CLIENTE, COD_PRODUCTO, FECHA_VENTA, CANTIDAD, PRECIO_TOTAL)
        VALUES (SEQ_LETG_VENTA.NEXTVAL, p_cod_cliente, p_cod_producto, SYSDATE, p_cantidad, v_precio_total);

        -- Registrar la salida de producto
        INSERT INTO LETG_SALIDA_PRODUCTO (COD_SALIDA, COD_PRODUCTO, CANTIDAD, FECHA_SALIDA)
        VALUES (SEQ_LETG_SALIDA_PRODUCTO.NEXTVAL, p_cod_producto, p_cantidad, SYSDATE);

        COMMIT;  
    ELSE
        DBMS_OUTPUT.PUT_LINE('Stock insuficiente para el producto.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Error al registrar la venta: ' || SQLERRM);
END;

-- Gestor Stock en bodega
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_SALIDA (
    p_cod_producto IN NUMBER,
    p_cantidad IN NUMBER
)
IS
BEGIN
    -- Registrar la salida de producto
    INSERT INTO LETG_SALIDA_PRODUCTO (COD_SALIDA, COD_PRODUCTO, CANTIDAD, FECHA_SALIDA)
    VALUES (SEQ_LETG_SALIDA_PRODUCTO.NEXTVAL, p_cod_producto, p_cantidad, SYSDATE);

    COMMIT;  
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Error al registrar la salida de producto: ' || SQLERRM);
END;

-- Gestor ventas totales por cliente
CREATE OR REPLACE PROCEDURE SP_TOTAL_VENTAS_CLIENTE (
    p_cod_cliente IN NUMBER
)
IS
    v_total_ventas NUMBER := 0;  -- Inicializar a 0
BEGIN
    -- Validar que el cliente existe
    IF NOT EXISTS (SELECT 1 FROM LETG_CLIENTE WHERE COD_CLIENTE = p_cod_cliente) THEN
        RAISE_APPLICATION_ERROR(-20001, 'El cliente con el código proporcionado no existe.');
    END IF;

    -- Calcular el total de ventas del cliente
    SELECT NVL(SUM(PRECIO_TOTAL), 0) INTO v_total_ventas
    FROM LETG_VENTA
    WHERE COD_CLIENTE = p_cod_cliente;

    -- Salida del total de ventas
    DBMS_OUTPUT.PUT_LINE('Total gastado por el cliente: ' || v_total_ventas);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error al calcular el total de ventas: ' || SQLERRM);
END;

-- Gestor Nuevo producto
CREATE OR REPLACE PROCEDURE SP_INGRESAR_NUEVO_PRODUCTO (
    p_nombre IN VARCHAR2,
    p_precio_compra IN NUMBER,
    p_precio_venta IN NUMBER,
    p_cod_tipo_producto IN NUMBER,
    p_cod_marca_producto IN NUMBER,
    p_stock_inicial IN NUMBER
)
IS
    v_cod_producto NUMBER;
BEGIN
    -- Validar que los precios y el stock sean positivos
    IF p_precio_compra <= 0 OR p_precio_venta <= 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'El precio de compra y venta deben ser positivos.');
    END IF;

    IF p_stock_inicial < 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'El stock inicial no puede ser negativo.');
    END IF;

    -- Verificar que el tipo de producto existe
    IF NOT EXISTS (SELECT 1 FROM LETG_TIPO_PRODUCTO WHERE COD_TIPO_PRODUCTO = p_cod_tipo_producto) THEN
        RAISE_APPLICATION_ERROR(-20008, 'El tipo de producto especificado no existe.');
    END IF;

    -- Verificar que la marca del producto existe
    IF NOT EXISTS (SELECT 1 FROM LETG_MARCA_PRODUCTO WHERE COD_MARCA_PRODUCTO = p_cod_marca_producto) THEN
        RAISE_APPLICATION_ERROR(-20009, 'La marca del producto especificada no existe.');
    END IF;

    -- Insertar el nuevo producto
    INSERT INTO LETG_PRODUCTO (COD_PRODUCTO, NOMBRE, PRECIO_COMPRA, PRECIO_VENTA, COD_TIPO_PRODUCTO, COD_MARCA_PRODUCTO)
    VALUES (SEQ_LETG_PRODUCTO.NEXTVAL, p_nombre, p_precio_compra, p_precio_venta, p_cod_tipo_producto, p_cod_marca_producto);

    -- Obtener el ID del nuevo producto
    SELECT SEQ_LETG_PRODUCTO.CURRVAL INTO v_cod_producto FROM DUAL;

    -- Insertar el stock inicial en la bodega
    INSERT INTO LETG_BODEGA (COD_BODEGA, COD_PRODUCTO, CANTIDAD_DISPONIBLE)
    VALUES (SEQ_LETG_BODEGA.NEXTVAL, v_cod_producto, p_stock_inicial);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Error al ingresar nuevo producto: ' || SQLERRM);
END;

-- Gestor productos mas vendidos
CREATE OR REPLACE PROCEDURE SP_PRODUCTOS_MAS_VENDIDOS
IS
    CURSOR c_mas_vendidos IS
        SELECT COD_PRODUCTO, SUM(CANTIDAD) AS TOTAL_VENDIDO
        FROM LETG_VENTA
        GROUP BY COD_PRODUCTO
        ORDER BY TOTAL_VENDIDO DESC;
BEGIN
    -- Verificar si hay datos en la tabla de ventas
    IF NOT EXISTS (SELECT 1 FROM LETG_VENTA) THEN
        DBMS_OUTPUT.PUT_LINE('No hay ventas registradas.');
        RETURN;
    END IF;

    -- Recorrer los productos más vendidos
    FOR r_producto IN c_mas_vendidos LOOP
        DBMS_OUTPUT.PUT_LINE('Producto ID: ' || r_producto.COD_PRODUCTO || ' Total Vendido: ' || r_producto.TOTAL_VENDIDO);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error al listar productos más vendidos: ' || SQLERRM);
END;

-- Reportes

-- Reporte de productos mas vendidos y menos vendidos por mes
CREATE OR REPLACE PROCEDURE SP_REPORTE_PRODUCTOS_VENTAS_MES (
    p_mes IN NUMBER,
    p_anio IN NUMBER
)
IS
    CURSOR c_productos_mes IS
    SELECT COD_PRODUCTO, SUM(CANTIDAD) AS TOTAL_VENDIDO
    FROM LETG_VENTA
    WHERE EXTRACT(MONTH FROM FECHA_VENTA) = p_mes
    AND EXTRACT(YEAR FROM FECHA_VENTA) = p_anio
    GROUP BY COD_PRODUCTO
    ORDER BY TOTAL_VENDIDO DESC;
BEGIN
    -- Recorrer los productos vendidos en el mes
    DBMS_OUTPUT.PUT_LINE('Reporte de productos más vendidos en el mes ' || p_mes || '/' || p_anio);
    FOR r_producto IN c_productos_mes LOOP
        DBMS_OUTPUT.PUT_LINE('Producto ID: ' || r_producto.COD_PRODUCTO || ' Total Vendido: ' || r_producto.TOTAL_VENDIDO);
    END LOOP;
END;

-- Reporte de ingresos totales por mes
CREATE OR REPLACE PROCEDURE SP_REPORTE_INGRESOS_MENSUALES (
    p_mes IN NUMBER,
    p_anio IN NUMBER
)
IS
    v_ingresos_totales NUMBER;
BEGIN
    -- Calcular los ingresos totales por mes
    SELECT SUM(PRECIO_TOTAL) INTO v_ingresos_totales
    FROM LETG_VENTA
    WHERE EXTRACT(MONTH FROM FECHA_VENTA) = p_mes
    AND EXTRACT(YEAR FROM FECHA_VENTA) = p_anio;

    DBMS_OUTPUT.PUT_LINE('Ingresos totales del mes ' || p_mes || '/' || p_anio || ': ' || v_ingresos_totales);
END;

-- Reporte de clientes con mayor volumen de compras
CREATE OR REPLACE PROCEDURE SP_REPORTE_CLIENTES_COMPRAS (
    p_mes IN NUMBER,
    p_anio IN NUMBER
)
IS
    CURSOR c_clientes_compras IS
    SELECT COD_CLIENTE, SUM(PRECIO_TOTAL) AS TOTAL_COMPRADO
    FROM LETG_VENTA
    WHERE EXTRACT(MONTH FROM FECHA_VENTA) = p_mes
    AND EXTRACT(YEAR FROM FECHA_VENTA) = p_anio
    GROUP BY COD_CLIENTE
    ORDER BY TOTAL_COMPRADO DESC;
BEGIN
    -- Recorrer los clientes con mayor volumen de compras
    DBMS_OUTPUT.PUT_LINE('Clientes con mayor volumen de compras en el mes ' || p_mes || '/' || p_anio);
    FOR r_cliente IN c_clientes_compras LOOP
        DBMS_OUTPUT.PUT_LINE('Cliente ID: ' || r_cliente.COD_CLIENTE || ' Total Comprado: ' || r_cliente.TOTAL_COMPRADO);
    END LOOP;
END;

-- Triggers

-- Trigger_de_monitoreo
CREATE OR REPLACE TRIGGER trg_registrar_ventas
AFTER INSERT ON LETG_VENTA
FOR EACH ROW
BEGIN
    INSERT INTO LOG_VENTAS (COD_VENTA, FECHA_LOG, ACCION)
    VALUES (:NEW.COD_VENTA, SYSDATE, 'INSERT');
END;

-- Trigger_actualizar_ventas
CREATE OR REPLACE TRIGGER trg_actualizar_ventas
BEFORE UPDATE ON LETG_VENTA
FOR EACH ROW
BEGIN
    INSERT INTO LOG_VENTAS (COD_VENTA, FECHA_LOG, ACCION, ANTERIOR_PRECIO_TOTAL, NUEVO_PRECIO_TOTAL)
    VALUES (:OLD.COD_VENTA, SYSDATE, 'UPDATE', :OLD.PRECIO_TOTAL, :NEW.PRECIO_TOTAL);
END;

-- Trigger_eliminar_ventas
CREATE OR REPLACE TRIGGER trg_eliminar_ventas
BEFORE DELETE ON LETG_VENTA
FOR EACH ROW
BEGIN
    INSERT INTO LOG_VENTAS (COD_VENTA, FECHA_LOG, ACCION)
    VALUES (:OLD.COD_VENTA, SYSDATE, 'DELETE');
END;

-- Trigger_control_stock
CREATE OR REPLACE TRIGGER trg_control_stock
AFTER INSERT ON LETG_VENTA
FOR EACH ROW
BEGIN
    UPDATE LETG_PRODUCTO
    SET STOCK = STOCK - :NEW.CANTIDAD
    WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;
END;

-- Trigger_registro_ingresos
CREATE OR REPLACE TRIGGER trg_registrar_ingresos
AFTER INSERT ON LETG_VENTA
FOR EACH ROW
BEGIN
    INSERT INTO INGRESOS_MENSUALES (FECHA, TOTAL_INGRESO)
    VALUES (TRUNC(SYSDATE, 'MM'), :NEW.PRECIO_TOTAL);
END;
