--a) Crear la base de datos con el archivo create_restaurant_db.sql
--b) Explorar la tabla “menu_items” para conocer los productos del menú.
SELECT * FROM MENU_ITEMS;
--   1.- Realizar consultas para contestar las siguientes preguntas:
--        ● Encontrar el número de artículos en el menú.
--			R=32
			SELECT COUNT(MENU_ITEM_ID) FROM MENU_ITEMS;
--        ● ¿Cuál es el artículo menos caro y el más caro en el menú?
--			R=Artículo más caro: "Shrimp Scampi" con un costo de 19.95
			SELECT ITEM_NAME,CATEGORY, PRICE FROM MENU_ITEMS
				ORDER BY 3 DESC
				LIMIT 1;
--			  Artículo más barato: "Edamame" con el costo de 5.00			
			SELECT ITEM_NAME,CATEGORY, PRICE FROM MENU_ITEMS
				ORDER BY 3 ASC
				LIMIT 1;
--        ● ¿Cuántos platos americanos hay en el menú?
--			R=6 platillos
			SELECT COUNT(CATEGORY) AS CANTIDAD_PLATOS_AMERICANOS FROM MENU_ITEMS
				WHERE CATEGORY='American';
--        ● ¿Cuál es el precio promedio de los platos?
--			R=13.29
			SELECT ROUND(AVG(PRICE),2) AS PRECIO_PROMEDIO FROM MENU_ITEMS;
--c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.
SELECT * FROM ORDER_DETAILS;
--   1.- Realizar consultas para contestar las siguientes preguntas:
--        ● ¿Cuántos pedidos únicos se realizaron en total?
--			R= 5370
			SELECT COUNT (DISTINCT ORDER_ID) AS PEDIDOS_UNICOS FROM ORDER_DETAILS;
--        ● ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
--			R= 440, 2675, 3473, 4305, 443	
			SELECT ORDER_ID, COUNT (ITEM_ID) AS CANTIDAD_PLATILLOS FROM ORDER_DETAILS
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 5;
--        ● ¿Cuándo se realizó el primer pedido y el último pedido?
--			R= Primer pedido: order_id = 1	
			SELECT ORDER_ID, ORDER_DATE,ORDER_TIME FROM ORDER_DETAILS
			ORDER BY 2 ASC,3 ASC
			LIMIT 1;
--			  Último pedido: order_id = 5370
			SELECT ORDER_ID, ORDER_DATE,ORDER_TIME FROM ORDER_DETAILS
			ORDER BY 1 DESC,2 DESC
			LIMIT 1;
--        ● ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?
--			R= 308
			SELECT COUNT(DISTINCT ORDER_ID) AS CANTIDAD_ORDENES_FECHA FROM ORDER_DETAILS
			WHERE ORDER_DATE BETWEEN '2023-01-01' AND '2023-01-05'
--d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.
--   1.- Realizar un left join entre entre order_details y menu_items con el identificador
--       item_id(tabla order_details) y menu_item_id(tabla menu_items).
			SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
			LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID;

--			Esta tabla temporal, brinda información interesante, debido a que podemos hacer recuento de más datos.

--e) Una vez que hayas explorado los datos en las tablas correspondientes y respondido las
--       preguntas planteadas, realiza un análisis adicional utilizando este join entre las tablas. El
--       objetivo es identificar 5 puntos clave que puedan ser de utilidad para los dueños del
--       restaurante en el lanzamiento de su nuevo menú. Para ello, crea

--      I. El top 5 pedidos por mayor costo de productos son los de los order_id: 440, 2075, 1957, 330, 2675
--			NOTA: Los pedidos con order_id 440 y 2657 estan ambos en el top de cantidad de platillos y montos mayores. [Vease C1]
		SELECT ORDER_ID, SUM(PRICE) AS PRECIO_ORDENES FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		GROUP BY ORDER_ID
		HAVING SUM(PRICE) IS NOT NULL
		ORDER BY PRECIO_ORDENES DESC
		LIMIT 5;

--		II. La cantidad de ordenes las cuales no concretaron un consumo (price=NULL) fueron: 137 ordenes
--		Consulta para visualizar.		
		SELECT * FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		WHERE PRICE IS NULL;
--      Consulta para calculo.
		SELECT COUNT(ORDER_ID) FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		WHERE PRICE IS NULL;

--		III. El restaurante logro vender los 32 productos del Menu. Sin embargo, el producto con mayor valor acumulador fue "Korean Beef Bowl" con 588 platillos y
--        monto de 10,554.60. Por otro lado, el producto con menor valor acumulado fue "Chicken Tacos" con 123 platillos y monto de 1469.85.
--		Consulta para visualizar los productos vendidos, cantidad y monto.
		SELECT ITEM_NAME, COUNT(CATEGORY),SUM(PRICE) FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		WHERE CATEGORY IS NOT NULL
		GROUP BY 1;
--		Consulta para calcular mayor vendido.
		SELECT ITEM_NAME, COUNT(CATEGORY),SUM(PRICE) FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		WHERE CATEGORY IS NOT NULL
		GROUP BY 1
		ORDER BY 3 DESC ,2 DESC
		LIMIT 1;
--Consulta para calcular menor vendido.
		SELECT ITEM_NAME, COUNT(CATEGORY),SUM(PRICE) FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		WHERE CATEGORY IS NOT NULL
		GROUP BY 1
		ORDER BY 3 ASC ,2 ASC
		LIMIT 1;

--		IV. La categoria que más dinero vendio fue: "Italian" con 2948 platillos y un monto de 49,462.70. Así como la que vendio menos fue la
--        "American" con 2734 platillos y un monto de 28,237.75.
--		Consulta para ver categorias por cantidad de platillos y monto de venta.
		SELECT CATEGORY,COUNT(CATEGORY) AS CANTIDAD_PLATILLOS,SUM(PRICE) AS PRECIO_ORDENES FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		GROUP BY 1
		HAVING SUM(PRICE) IS NOT NULL
--		Consulta para ver la categoria con más ventas.
		SELECT CATEGORY,COUNT(CATEGORY) AS CANTIDAD_PLATILLOS,SUM(PRICE) AS PRECIO_ORDENES FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		GROUP BY 1
		HAVING SUM(PRICE) IS NOT NULL
		ORDER BY PRECIO_ORDENES DESC
		LIMIT 1;
--		Consulta para ver la categoria con menos ventas.
		SELECT CATEGORY,COUNT(CATEGORY) AS CANTIDAD_PLATILLOS,SUM(PRICE) AS PRECIO_ORDENES FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		GROUP BY 1
		HAVING SUM(PRICE) IS NOT NULL
		ORDER BY PRECIO_ORDENES ASC
		LIMIT 1;
--    	V.- El día con mayor cantidad de platillos vendidos fue: "2023-03-31" con 159
		SELECT ORDER_DATE ,COUNT(CATEGORY) AS CANTIDAD_PLATILLOS FROM (SELECT ORD.ORDER_DETAILS_ID, ORD.ORDER_ID, ORD.ORDER_DATE,ORD.ORDER_TIME, ME.ITEM_NAME, ME.CATEGORY, ME.PRICE FROM ORDER_DETAILS AS ORD
		LEFT JOIN MENU_ITEMS AS ME ON ORD.ITEM_ID = ME.MENU_ITEM_ID)
		WHERE CATEGORY IS NOT NULL
		GROUP BY 1
		ORDER BY 1 DESC
		LIMIT 1;