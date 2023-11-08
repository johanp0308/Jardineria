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
WHERE p.fecha_esperada = p.fecha_entrega
GROUP BY c.nombre_cliente;

-- 11.
SELECT c.nombre_cliente as Cliente, GROUP_CONCAT(DISTINCT g.gama) as Gama
FROM cliente c
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
JOIN detalle_pedido d ON d.codigo_pedido = p.codigo_pedido
JOIN producto pr ON d.codigo_producto = pr.codigo_producto
JOIN gama_producto g ON pr.gama = g.gama;