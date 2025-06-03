-- 1. Reporte de Ventas Mensuales por Producto
CREATE OR REPLACE PROCEDURE REPORTE_VENTAS_MENSUALES (
    p_fecha_inicio IN DATE,
    p_fecha_fin IN DATE,
    p_resultado OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_resultado FOR
        SELECT 
            p.COD_PRODUCTO,
            p.NOMBRE_PRODUCTO,
            TO_CHAR(v.FECHA_VENTA, 'YYYY-MM') as MES,
            SUM(dv.CANTIDAD) as CANTIDAD_VENDIDA,
            SUM(dv.SUBTOTAL) as TOTAL_VENTAS
        FROM LETG_PRODUCTO p
        JOIN LETG_DETALLE_VENTA dv ON p.COD_PRODUCTO = dv.COD_PRODUCTO
        JOIN LETG_VENTA v ON dv.COD_VENTA = v.COD_VENTA
        WHERE v.FECHA_VENTA BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY p.COD_PRODUCTO, p.NOMBRE_PRODUCTO, TO_CHAR(v.FECHA_VENTA, 'YYYY-MM')
        ORDER BY TO_CHAR(v.FECHA_VENTA, 'YYYY-MM'), SUM(dv.CANTIDAD) DESC;
END REPORTE_VENTAS_MENSUALES;

-- 2. Reporte de Stock por Bodega
CREATE OR REPLACE PROCEDURE REPORTE_STOCK_BODEGA (
    p_cod_bodega IN NUMBER,
    p_resultado OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_resultado FOR
        WITH MOVIMIENTOS AS (
            -- Entradas
            SELECT 
                cod_producto,
                SUM(cantidad) as cantidad_entrada
            FROM LETG_ENTRADA_BODEGA eb
            JOIN LETG_MOVIMIENTOS_BODEGA mb ON eb.cod_movimiento = mb.cod_movimiento
            WHERE mb.cod_bodega = p_cod_bodega
            GROUP BY cod_producto
            
            UNION ALL
            
            -- Salidas
            SELECT 
                cod_producto,
                -SUM(cantidad) as cantidad_salida
            FROM LETG_SALIDA_BODEGA sb
            JOIN LETG_MOVIMIENTOS_BODEGA mb ON sb.cod_movimiento = mb.cod_movimiento
            WHERE mb.cod_bodega = p_cod_bodega
            GROUP BY cod_producto
        )
        SELECT 
            p.COD_PRODUCTO,
            p.NOMBRE_PRODUCTO,
            NVL(SUM(m.cantidad_entrada), 0) as STOCK_ACTUAL
        FROM LETG_PRODUCTO p
        LEFT JOIN MOVIMIENTOS m ON p.cod_producto = m.cod_producto
        GROUP BY p.COD_PRODUCTO, p.NOMBRE_PRODUCTO
        ORDER BY p.NOMBRE_PRODUCTO;
END REPORTE_STOCK_BODEGA;

-- 3. Reporte de Ventas por Categoría
CREATE OR REPLACE PROCEDURE REPORTE_VENTAS_POR_CATEGORIA (
    p_fecha_inicio IN DATE,
    p_fecha_fin IN DATE,
    p_resultado OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_resultado FOR
        SELECT 
            c.COD_CATEGORIA,
            c.NOMBRE_CATEGORIA,
            SUM(dv.CANTIDAD) as CANTIDAD_TOTAL_VENDIDA,
            SUM(dv.SUBTOTAL) as TOTAL_VENTAS
        FROM LETG_CATEGORIA c
        JOIN LETG_PRODUCTO p ON c.COD_CATEGORIA = p.COD_CATEGORIA
        JOIN LETG_DETALLE_VENTA dv ON p.COD_PRODUCTO = dv.COD_PRODUCTO
        JOIN LETG_VENTA v ON dv.COD_VENTA = v.COD_VENTA
        WHERE v.FECHA_VENTA BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY c.COD_CATEGORIA, c.NOMBRE_CATEGORIA
        ORDER BY TOTAL_VENTAS DESC;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error en REPORTE_VENTAS_POR_CATEGORIA: ' || SQLERRM);
END REPORTE_VENTAS_POR_CATEGORIA;