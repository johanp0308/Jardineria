-- 1.4.5
-- 1.
SELECT c.nombre_cliente as Cliente, CONCAT(e.nombre,' ',e.apellido1,' ',e.apellido2) as Representante 
FROM cliente c 
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 2.
SELECT c.nombre_cliente as Cliente, CONCAT(e.nombre,' ',e.apellido1,' ',e.apellido2) as Representante 
FROM cliente c 
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN pago p on p.codigo_cliente = c.codigo_cliente;
-- 3
SELECT c.nombre_cliente as Cliente, c.codigo_cliente as Codigo
FROM cliente c
LEFT JOIN pago p on c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

SELECT c.nombre_cliente as Cliente, c.codigo_cliente as Codigo
FROM pago p
RIGHT JOIN cliente c on c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

-- 4

SELECT c.nombre_cliente as Cliente, e.nombre as Representante, o.ciudad as Ciudad
FROM cliente c
JOIN pago p ON c.codigo_cliente = p.codigo_cliente
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina; 

-- 5

SELECT c.nombre_cliente as Cliente, e.nombre as Representante, o.ciudad as Ciudad
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE p.codigo_cliente IS NULL;

-- 6 
SELECT CONCAT(o.linea_direccion1,', ',o.linea_direccion2) as Direccion
FROM oficina o
JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.ciudad = 'Fuenlabrada';

-- 7
SELECT c.nombre_cliente as Cliente, CONCAT(e.nombre,' ',e.apellido1) as Representante, o.ciudad as Oficina
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

-- 8
SELECT CONCAT(e.nombre, ' ',e.apellido1) as Empleado, CONCAT(j.nombre,' ',j.apellido1) AS Jefe
FROM empleado e
JOIN empleado j ON e.codigo_jefe = j.codigo_empleado;

-- 9
SELECT CONCAT(e.nombre, ' ',e.apellido1) as Empleado, CONCAT(j.nombre,' ',j.apellido1) AS Jefe, CONCAT(s.nombre,' ',s.apellido1) AS Superior
FROM empleado e
JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
JOIN empleado s ON j.codigo_jefe = s.codigo_empleado;

-- 10
SELECT c.nombre_cliente as Cliente, GROUP_CONCAT(p.codigo_pedido) as Pedidos_Id
FROM cliente c
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_esperada < p.fecha_entrega
GROUP BY c.nombre_cliente;

-- 11.
SELECT c.nombre_cliente as Cliente, GROUP_CONCAT(DISTINCT g.gama) as Gama
FROM cliente c
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
JOIN detalle_pedido d ON d.codigo_pedido = p.codigo_pedido
JOIN producto pr ON d.codigo_producto = pr.codigo_producto
JOIN gama_producto g ON pr.gama = g.gama;


-- 1.4.6

-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

-- 3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
LEFT JOIn pago pa ON c.codigo_cliente = pa.codigo_cliente
WHERE pa.codigo_cliente IS NULL
AND pe.codigo_cliente IS NULL;

-- 4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
SELECT e.nombre AS Empleado
FROM empleado e
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE e.codigo_oficina IS NULL;

-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
SELECT e.nombre AS Empleado
FROM empleado e
RIGHT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE c.codigo_empleado_rep_ventas = NULL;

-- 6. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.
SELECT e.nombre as Empleado, o.ciudad as Ciudad, o.linea_direccion1 as Direccion, c.codigo_empleado_rep_ventas
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_empleado_rep_ventas IS NULL;

-- 7. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado
SELECT e.nombre as Empleado, o.ciudad as Ciudad, o.linea_direccion1 as Direccion, c.codigo_empleado_rep_ventas
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_empleado_rep_ventas IS NULL
OR e.codigo_oficina IS NULL;

-- 8. Devuelve un listado de los productos que nunca han aparecido en un pedido.

SELECT pr.nombre
FROM producto pr
LEFT JOIN detalle_pedido d ON pr.codigo_producto = d.codigo_producto
WHERE d.codigo_producto IS NULL;

-- 9. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto
SELECT pr.nombre as Nombre, pr.descripcion as Descripcion, g.imagen
FROM producto pr
LEFT JOIN detalle_pedido d ON pr.codigo_producto = d.codigo_producto
JOIN gama_producto g ON pr.gama = g.gama
WHERE d.codigo_producto IS NULL;

-- 10. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
SELECT DISTINCT o.ciudad as Oficina_Ciudad
FROM oficina o
LEFT JOIN empleado e ON e.codigo_oficina = e.codigo_oficina
JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN pedido pe ON pe.codigo_cliente = c.codigo_cliente
JOIN detalle_pedido d ON d.codigo_pedido = pe.codigo_pedido
JOIN producto pr ON d.codigo_producto = pr.codigo_producto
JOIN gama_producto g ON pr.gama = g.gama
WHERE pr.gama = 'Frutales';

-- 11. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago. 

SELECT DISTINCT c.nombre_cliente as Cliente
FROM cliente c
JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
LEFT JOIN pago pa ON c.codigo_cliente = pa.codigo_cliente
WHERE pa.codigo_cliente IS NULL;

-- 12. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.
SELECT e.nombre as Nombre, e.apellido1 as Apellido, e.email as Correo, j.nombre
FROM empleado e
LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
WHERE c.codigo_empleado_rep_ventas IS NULL;

-- 1.4.7



-- 1.4.8.1

-- 1. Devuelve el nombre del cliente con mayor límite de crédito
SELECT c.nombre_cliente as Cliente
FROM cliente c
WHERE c.limite_credito = (SELECT MAX(c.limite_credito) FROM cliente c);

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT p.nombre as Producto, p.precio_venta
FROM producto p
WHERE p.precio_venta = (
    SELECT MAX(precio_venta) FROM producto
);

-- 3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla `detalle_pedido`)

SELECT p.nombre as Codigo, SUM(d.cantidad) as Cantidad
FROM producto p
JOIN detalle_pedido d ON p.codigo_producto = d.codigo_producto
GROUP BY p.nombre
ORDER BY Cantidad DESC
LIMIT 1;

-- 4 Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar `INNER JOIN`).

SELECT c.nombre_cliente as Cliente
FROM cliente c
WHERE c.limite_credito > (
    SELECT MAX(pa.total)
    FROM pago pa
    WHERE c.codigo_cliente = pa.codigo_cliente
    GROUP BY c.codigo_cliente
);

-- 5. Devuelve el producto que más unidades tiene en stock.

SELECT DISTINCT pr.nombre as Producto, pr.cantidad_en_stock as Cantidad
FROM producto pr
WHERE pr.cantidad_en_stock = (
    SELECT cantidad_en_stock
    FROM producto
    ORDER BY cantidad_en_stock DESC
    LIMIT 1
);

-- 6. Devuelve el producto que menos unidades tiene en stock.
SELECT DISTINCT pr.nombre as Producto, pr.cantidad_en_stock as Cantidad
FROM producto pr
WHERE pr.cantidad_en_stock = (
    SELECT cantidad_en_stock
    FROM producto
    ORDER BY cantidad_en_stock ASC
    LIMIT 1
);

-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.
SELECT e.nombre as Nombre, e.apellido1 as Apellido_1, e.apellido2 as Apellido_2, e.email as Correo
FROM empleado e
WHERE e.codigo_jefe IN (
    SELECT e.codigo_jefe 
    FROM empleado e
    WHERE e.nombre LIKE 'alberto%'
    AND e.apellido1 LIKE 'soria%'
);
