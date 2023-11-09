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

SELECT c.nombre_cliente as Cliente
FROM cliente c
JOIN 