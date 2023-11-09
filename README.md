# Consultas

1. Obten un listado con el nombre de cada cliente y el nombre y apellido de su reresentante de ventas. 
```SQL
SELECT c.nombre_cliente as Cliente, CONCAT(e.nombre,' ',e.apellido1,' ',e.apellido2) as Representante 
FROM cliente c 
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;
```
2. Muestre el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
```SQL
SELECT c.nombre_cliente as Cliente, CONCAT(e.nombre,' ',e.apellido1,' ',e.apellido2) as Representante 
FROM cliente c 
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN pago p on p.codigo_cliente = c.codigo_cliente;
```
3. Muestra el nombre los clientes que **no** hayan realizado pagos junto con el nombre de sus representantes de ventas.
```SQL
SELECT c.nombre_cliente as Cliente, c.codigo_cliente as Codigo
FROM cliente c
LEFT JOIN pago p on c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

SELECT c.nombre_cliente as Cliente, c.codigo_cliente as Codigo
FROM pago p
RIGHT JOIN cliente c on c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;
```
4. Devuel el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
```SQL
SELECT c.nombre_cliente as Cliente, e.nombre as Representante, o.ciudad as Ciudad
FROM cliente c
JOIN pago p ON c.codigo_cliente = p.codigo_cliente
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina; 
```
5. Devuel el nombre de los clientes que no han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
```SQL
SELECT c.nombre_cliente as Cliente, e.nombre as Representante, o.ciudad as Ciudad
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE p.codigo_cliente IS NULL;
```
6. Lista la direccion de las oficinas que tengan clientes en `Fuenlabrada`
```SQL
SELECT CONCAT(o.linea_direccion1,', ',o.linea_direccion2) as Direccion
FROM oficina o
JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.ciudad = 'Fuenlabrada';
```
7. Devuelve el nombre de los clientes y el nombre de sus representantes junt con la ciudad de la oficina a la que pertenece el representante.
```SQL
SELECT c.nombre_cliente as Cliente, CONCAT(e.nombre,' ',e.apellido1) as Representante, o.ciudad as Oficina
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;
```
8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes;
```SQL
SELECT CONCAT(e.nombre, ' ',e.apellido1) as Empleado, CONCAT(j.nombre,' ',j.apellido1) AS Jefe
FROM empleado e
JOIN empleado j ON e.codigo_jefe = j.codigo_empleado;
```
9. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
```SQL
SELECT CONCAT(e.nombre, ' ',e.apellido1) as Empleado, CONCAT(j.nombre,' ',j.apellido1) AS Jefe, CONCAT(s.nombre,' ',s.apellido1) AS Superior
FROM empleado e
JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
JOIN empleado s ON j.codigo_jefe = s.codigo_empleado;
```
10. Devuelve el nombre de los clientes a los que no se les han entregado a tiempo un pedido.
```SQL
SELECT c.nombre_cliente as Cliente, GROUP_CONCAT(p.codigo_pedido) as Pedidos_Id
FROM cliente c
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_esperada = p.fecha_entrega
GROUP BY c.nombre_cliente;
```
11. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
```SQL
SELECT c.nombre_cliente as Cliente, GROUP_CONCAT(DISTINCT g.gama) as Gama
FROM cliente c
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
JOIN detalle_pedido d ON d.codigo_pedido = p.codigo_pedido
JOIN producto pr ON d.codigo_producto = pr.codigo_producto
JOIN gama_producto g ON pr.gama = g.gama
GROUP BY c.nombre_cliente;
```

## 1.4.6 Consultas multitabla (Composición externa)
Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, NATURAL LEFT JOIN y NATURAL RIGHT D0IN 

1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago. 

```sql
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;
```

2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.

```sql
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;
```

3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.
```sql
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
LEFT JOIn pago pa ON c.codigo_cliente = pa.codigo_cliente
WHERE pa.codigo_cliente IS NULL
AND pe.codigo_cliente IS NULL;

```

4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.

```sql
SELECT e.nombre AS Empleado
FROM empleado e
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE e.codigo_oficina IS NULL;
```

5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.

```sql
SELECT e.nombre AS Empleado
FROM empleado e
RIGHT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE c.codigo_empleado_rep_ventas = NULL;
```

6. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.

```sql
SELECT e.nombre as Empleado, o.ciudad as Ciudad, o.linea_direccion1 as Direccion, c.codigo_empleado_rep_ventas
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_empleado_rep_ventas IS NULL;
```

7. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado

```sql
SELECT e.nombre as Empleado, o.ciudad as Ciudad, o.linea_direccion1 as Direccion, c.codigo_empleado_rep_ventas
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_empleado_rep_ventas IS NULL
OR e.codigo_oficina IS NULL;
```

8. Devuelve un listado de los productos que nunca han aparecido en un pedido.

```sql
SELECT pr.nombre
FROM producto pr
LEFT JOIN detalle_pedido d ON pr.codigo_producto = d.codigo_producto
WHERE d.codigo_producto IS NULL;
```

9.  Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.

```sql
SELECT pr.nombre as Nombre, pr.descripcion as Descripcion, g.imagen
FROM producto pr
LEFT JOIN detalle_pedido d ON pr.codigo_producto = d.codigo_producto
JOIN gama_producto g ON pr.gama = g.gama
WHERE d.codigo_producto IS NULL;
```

10. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

```sql
SELECT DISTINCT o.ciudad as Oficina_Ciudad
FROM oficina o
LEFT JOIN empleado e ON e.codigo_oficina = e.codigo_oficina
JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN pedido pe ON pe.codigo_cliente = c.codigo_cliente
JOIN detalle_pedido d ON d.codigo_pedido = pe.codigo_pedido
JOIN producto pr ON d.codigo_producto = pr.codigo_producto
JOIN gama_producto g ON pr.gama = g.gama
WHERE pr.gama = 'Frutales';
```

11. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

```sql
SELECT DISTINCT c.nombre_cliente as Cliente
FROM cliente c
JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
LEFT JOIN pago pa ON c.codigo_cliente = pa.codigo_cliente
WHERE pa.codigo_cliente IS NULL;
```

12. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.

```sql
SELECT e.nombre as Nombre, e.apellido1 as Apellido, e.email as Correo, j.nombre
FROM empleado e
LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
WHERE c.codigo_empleado_rep_ventas IS NULL;
```

### 1.4.8 Subconsultas

#### 1.4.8.1 Con operadores básicos de comparación

1. Devuelve el nombre del cliente con mayor límite de crédito.

```sql
SELECT c.nombre_cliente as Cliente
FROM cliente c
WHERE c.limite_credito = (SELECT MAX(c.limite_credito) FROM cliente c);
```

2. Devuelve el nombre del producto que tenga el precio de venta más caro.

```sql
SELECT p.nombre as Producto, p.precio_venta
FROM producto p
WHERE p.precio_venta = (
    SELECT MAX(precio_venta) FROM producto
);
```

3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla `detalle_pedido`).

```sql

```

4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar `INNER JOIN`).
5. Devuelve el producto que más unidades tiene en stock.
6. Devuelve el producto que menos unidades tiene en stock.
7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de **Alberto Soria**.

#### 1.4.8.2 Subconsultas con ALL y ANY

1. Devuelve el nombre del cliente con mayor límite de crédito.
2. Devuelve el nombre del producto que tenga el precio de venta más caro.
3. Devuelve el producto que menos unidades tiene en stock.

#### 1.4.8.3 Subconsultas con IN y NOT IN

1. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.
2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
3. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
4. Devuelve un listado de los productos que nunca han aparecido en un pedido.
5. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.
6. Devuelve las oficinas donde **no trabajan** ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama `Frutales`.
7. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

#### 1.4.8.4 Subconsultas con EXISTS y NOT EXISTS

1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
2. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
4. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.