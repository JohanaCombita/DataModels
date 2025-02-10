-- Nombre author: Johana Cómbita Niño
-- Descripción: Práctica 2, consultas sobre base de datos de Pizzería

-- 1. Mostrar los datos de los pedidos realizados entre octubre
-- y noviembre de 2018 (0.5 ptos)

SELECT P.* FROM PEDIDOS P
WHERE P.FECHAHORAPEDIDO BETWEEN '2018-10-01' AND '2018-11-30';


-- 2. Devolver el id, nombre, apellido1, apellido2, fecha de 
-- alta y fecha de baja de todos los miembros del personal que
-- no estén de baja, ordenados descendentemente por fecha de
-- alta y ascendentemente por nombre (0.75 pto, 0.25 ptos 
-- adicionales si la consulta se realiza con el nombre y 
-- apellidos concatenados).

SELECT P.idpersonal, P.nombre, P.apellido1, P.apellido2, P.fechaAlta, P.fechaBaja FROM PERSONAL P
WHERE P.fechaBaja IS NULL
ORDER BY P.fechaAlta DESC, P.nombre ASC;

-- CON NOMBRE Y APELLIDOS CONCATENADOS:

SELECT P.idpersonal, COALESCE(P.nombre, '') || ' ' || COALESCE(P.apellido1, '') || ' ' || COALESCE(P.apellido2, '' ) AS nombre_completo, P.fechaAlta, P.fechaBaja FROM PERSONAL P
WHERE P.fechaBaja IS NULL
ORDER BY P.fechaAlta DESC, nombre_completo ASC;


-- 3. Retornar los datos de todos los clientes cuyo nombre
-- comience por G o J y que además tengan observaciones (1 pto).

SELECT C.* FROM CLIENTES C
WHERE (C.nombre LIKE ('G%') OR C.nombre LIKE ('J%')) AND (C.observaciones IS NOT NULL);


-- 4. Devolver el id e importe base de las pizzas junto con el
-- id y descripción de todos sus ingredientes, siempre que el
-- importe base de estas pizzas sea mayor a 3 (1 pto).

SELECT P.idpizza, P.importeBase, I.idingrediente, I.descripcion
FROM PIZZAS P
        JOIN INGREDIENTEDEPIZZA IP ON P.idpizza = IP.idpizza
        JOIN INGREDIENTES I ON IP.idingrediente = I.idingrediente
WHERE P.importeBase > 3 ; 


-- 5. Mostrar los datos de todas las pizzas que no hayan sido
-- nunca pedidas, ordenados por id ascendentemente (1 pto).

SELECT P.* FROM PIZZAS P
WHERE NOT EXISTS(SELECT LP.idpizza FROM LINEASPEDIDOS LP WHERE P.idpizza = LP.idpizza)
ORDER BY P.idpizza ASC;


-- 6. Devolver los datos de las bases, junto con los datos de 
-- las pizzas en las que están presentes, incluyendo los datos
-- de las bases que no están en ninguna pizza (0.5 ptos)

SELECT B.*, P.* FROM BASES B
                LEFT JOIN PIZZAS P ON B.idbase = P.idbase;


-- 7. Retornar los datos de los pedidos realizados por el
-- cliente con id 1, junto con los datos de sus líneas y de las
-- pizzas pedidas, siempre que el precio unitario en la línea 
-- sea menor que el importe base de la pizza. (1.5 ptos)

SELECT PE.*,LP.*, P.* FROM PEDIDOS PE
                JOIN LINEASPEDIDOS LP ON PE.idpedido = LP.idpedido
                JOIN PIZZAS P ON LP.idpizza = P.idpizza
WHERE (PE.idcliente = 1) AND (LP.precioUnidad < P.importeBase);


-- 8. Mostrar el id y nif de todos los clientes, junto con el
-- número total de pedidos realizados (0.75 pto, 0.25 ptos 
-- adicionales si sólo se devuelven los datos de los que hayan
-- realizado más de un pedido).

SELECT C.idcliente, C.nif, COUNT(P.IDPEDIDO) AS TOTAL_PEDIDOS 
FROM CLIENTES C
     JOIN PEDIDOS P ON C.idcliente = P.idcliente
GROUP BY C.idcliente, C.nif;

-- DEVOLVER SOLO LOS DATOS DE LOS QUE HAYAN REALIZADO MÁS DE UN
-- PEDIDO:

SELECT C.idcliente, C.nif, COUNT(P.IDPEDIDO) AS TOTAL_PEDIDOS 
FROM CLIENTES C
     JOIN PEDIDOS P ON C.idcliente = P.idcliente
GROUP BY C.idcliente, C.nif
HAVING TOTAL_PEDIDOS > 1;


-- 9. Sumar 0.5 al importe base de todas las pizzas que 
--contengan el ingrediente con id ‘JAM’ (0.75 pto).

UPDATE PIZZAS SET importeBase = (importeBase + 0.5)
WHERE idpizza IN (SELECT IP.idpizza 
                    FROM INGREDIENTEDEPIZZA IP
                    WHERE IP.idingrediente = 'JAM');

-- CONSULTAS PARA VER ACTUALIZACIÓN:
-- Valores actualizados
SELECT P.*, I.* FROM PIZZAS P
                    JOIN INGREDIENTEDEPIZZA IP ON P.idpizza = IP.idpizza
                    JOIN INGREDIENTES I ON IP.idingrediente = I.idingrediente
WHERE I.IDINGREDIENTE = 'JAM' ;

--Valores no actualizados
SELECT P.*, I.* FROM PIZZAS P
                    JOIN INGREDIENTEDEPIZZA IP ON P.idpizza = IP.idpizza
                    JOIN INGREDIENTES I ON IP.idingrediente = I.idingrediente
WHERE P.IDPIZZA NOT IN (SELECT IP2.IDPIZZA FROM INGREDIENTEDEPIZZA IP2 WHERE IP2.IDINGREDIENTE = 'JAM') ;


-- 10. Eliminar las líneas de los pedidos anteriores a 2018
-- (0.75 pto).

DELETE FROM LINEASPEDIDOS 
    WHERE idpedido IN (SELECT P.idpedido 
                        FROM PEDIDOS P
                        WHERE P.fechaHoraPedido < '2018-01-01');

-- CONSULTA PARA VER SI SE ELIMINARON:
SELECT L.*,P.* FROM LINEASPEDIDOS L
                JOIN PEDIDOS P ON L.idpedido = P.idpedido
                WHERE P.fechaHoraPedido < '2018-01-01';


-- 11. BONUS para el 10: Realizar una consulta que devuelva el
-- número de pizzas totales pedidas por cada cliente. En la
-- consulta deberán aparecer el id y nif de los clientes, 
-- además de su nombre y apellidos concatenados (1 pto).

SELECT C.idcliente, C.nif, COALESCE(C.nombre, '') || ' ' || COALESCE(C.apellido1, '') || ' ' || COALESCE(C.apellido2, '' ) AS Nombre_Completo, SUM(LP.cantidad) AS Pizzas_Totales
FROM LINEASPEDIDOS LP
        JOIN PEDIDOS P ON LP.idpedido = P.idpedido
        JOIN CLIENTES C ON P.idcliente = C.idcliente
GROUP BY C.idcliente, C.nif, Nombre_Completo;

