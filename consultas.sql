-- =====================================================================
-- Análisis de movimientos de contenedores con SQL (SQLite)
-- Autor: Byron Bustamante
-- Base: base_practica_200.sql (tabla movimientos, 200 filas, datos de práctica)
-- Columnas: id, contenedor, tamano, tipo, naviera, movimiento, fecha, peso_kg, cliente
--
-- Ejercicios de nivel medio y alto resueltos durante mi preparación en SQL
-- (octubre de 2026). Cada consulta lleva encima la pregunta de negocio
-- y debajo el resultado esperado.
-- =====================================================================


-- ---------------------------------------------------------------------
-- NIVEL MEDIO
-- ---------------------------------------------------------------------

-- 1. Importaciones por cliente: cuántos contenedores y peso promedio
--    con dos decimales, del cliente con más importaciones al de menos.
SELECT cliente,
       COUNT(*)                AS importaciones,
       ROUND(AVG(peso_kg), 2)  AS peso_promedio
FROM movimientos
WHERE movimiento = 'Importación'
GROUP BY cliente
ORDER BY importaciones DESC;
-- Resultado: 6 filas. Primera: Agroinsumos El Oro | 20 | 20800.0


-- 2. Exportaciones por naviera y cliente: cuántos contenedores y cuántos
--    kilos. Solo las parejas con al menos 5 contenedores. Ordenadas por
--    naviera y, dentro de cada naviera, de más kilos a menos.
SELECT naviera,
       cliente,
       COUNT(*)      AS contenedores,
       SUM(peso_kg)  AS kilos_totales
FROM movimientos
WHERE movimiento = 'Exportación'
GROUP BY naviera, cliente
HAVING COUNT(*) >= 5
ORDER BY naviera ASC, kilos_totales DESC;
-- Resultado: 10 filas. Primera: Hapag-Lloyd | Banano Pasaje | 8 | 197500


-- 3. De los contenedores secos de Maersk o CMA CGM movidos entre el 5 y
--    el 25 de septiembre, ¿qué clientes tienen un peso promedio mayor a
--    21.000 kg? Cuántos contenedores, kilos y promedio con dos decimales,
--    del promedio más alto al más bajo.
SELECT cliente,
       COUNT(*)                AS contenedores,
       SUM(peso_kg)            AS kilos_totales,
       ROUND(AVG(peso_kg), 2)  AS peso_promedio
FROM movimientos
WHERE tipo = 'Seco'
  AND naviera IN ('Maersk', 'CMA CGM')
  AND fecha BETWEEN '2026-09-05' AND '2026-09-25'
GROUP BY cliente
HAVING AVG(peso_kg) > 21000
ORDER BY peso_promedio DESC;
-- Resultado: 4 filas. Primera: Ferretera Bolívar | 2 | 46700 | 23350.0


-- 4. Importaciones por naviera: cuántos contenedores, toneladas con un
--    decimal y qué porcentaje del total de importaciones (71) representa
--    cada naviera, con un decimal. Del mayor porcentaje al menor.
SELECT naviera,
       COUNT(*)                                AS importaciones,
       ROUND(SUM(peso_kg) / 1000.0, 1)         AS toneladas,
       ROUND(COUNT(*) * 100.0 / 71, 1)         AS porcentaje
FROM movimientos
WHERE movimiento = 'Importación'
GROUP BY naviera
ORDER BY porcentaje DESC;
-- Resultado: 4 filas. Primera: MSC | 21 | 435.1 | 29.6 (los % suman 100)


-- ---------------------------------------------------------------------
-- NIVEL ALTO
-- ---------------------------------------------------------------------

-- 5. Exportaciones de 40 pies de MSC o Maersk, del 5 al 25 de septiembre,
--    que no son de Bananera del Sur: cuántas, cuántos clientes distintos,
--    kilos totales, peso promedio con dos decimales y peso máximo.
SELECT COUNT(*)                 AS exportaciones,
       COUNT(DISTINCT cliente)  AS clientes,
       SUM(peso_kg)             AS kilos_totales,
       ROUND(AVG(peso_kg), 2)   AS peso_promedio,
       MAX(peso_kg)             AS peso_maximo
FROM movimientos
WHERE movimiento = 'Exportación'
  AND tamano = 40
  AND (naviera = 'MSC' OR naviera = 'Maersk')
  AND fecha >= '2026-09-05' AND fecha <= '2026-09-25'
  AND NOT cliente = 'Bananera del Sur';
-- Resultado: 53 | 8 | 1291300 | 24364.15 | 26400


-- 6. Del mismo grupo de la consulta 5, ¿qué contenedor es el más pesado?
--    (método de dos pasos: el filtro se repite y se añade el peso máximo)
SELECT contenedor, naviera, cliente, fecha, peso_kg
FROM movimientos
WHERE movimiento = 'Exportación'
  AND tamano = 40
  AND (naviera = 'MSC' OR naviera = 'Maersk')
  AND fecha >= '2026-09-05' AND fecha <= '2026-09-25'
  AND NOT cliente = 'Bananera del Sur'
  AND peso_kg = 26400;
-- Resultado: 1 fila. MSCU8456619 | MSC | Mariscos del Guabo | 2026-09-15 | 26400


-- 7. Importaciones que no son de Maersk, por cliente y tamaño: cuántos
--    contenedores, kilos totales y el peso del más pesado. Solo los grupos
--    con al menos 5 contenedores y más de 85.000 kg. De más kilos a menos.
SELECT cliente,
       tamano,
       COUNT(*)      AS contenedores,
       SUM(peso_kg)  AS kilos_totales,
       MAX(peso_kg)  AS mas_pesado
FROM movimientos
WHERE movimiento = 'Importación'
  AND NOT naviera = 'Maersk'
GROUP BY cliente, tamano
HAVING COUNT(*) >= 5
   AND SUM(peso_kg) > 85000
ORDER BY kilos_totales DESC;
-- Resultado: 3 filas. Primera: Agroinsumos El Oro | 40 | 10 | 223400 | 27000


-- 8. Exportaciones por cliente: toneladas con un decimal, porcentaje del
--    total exportado (3.076.500 kg) con dos decimales y cuántas toneladas
--    le faltan para llegar a 500. Solo los clientes con más del 10 % del
--    total. Del mayor porcentaje al menor.
SELECT cliente,
       ROUND(SUM(peso_kg) / 1000.0, 1)            AS toneladas,
       ROUND(SUM(peso_kg) * 100.0 / 3076500, 2)   AS porcentaje,
       ROUND(500 - SUM(peso_kg) / 1000.0, 1)      AS faltan_para_500
FROM movimientos
WHERE movimiento = 'Exportación'
GROUP BY cliente
HAVING SUM(peso_kg) * 100.0 / 3076500 > 10
ORDER BY porcentaje DESC;
-- Resultado: 4 filas. Primera: Banano Pasaje | 515.5 | 16.76 | -15.5
-- (un valor negativo significa que el cliente ya superó las 500 t)


-- 9. Importaciones por cliente: cuántos contenedores, la diferencia en
--    toneladas entre el contenedor más pesado y el más liviano (un decimal)
--    y el promedio en toneladas (dos decimales). Solo clientes con una
--    diferencia mayor a 7 toneladas. De mayor diferencia a menor.
SELECT cliente,
       COUNT(*)                                       AS contenedores,
       ROUND((MAX(peso_kg) - MIN(peso_kg)) / 1000.0, 1)  AS diferencia_t,
       ROUND(AVG(peso_kg) / 1000.0, 2)                AS promedio_t
FROM movimientos
WHERE movimiento = 'Importación'
GROUP BY cliente
HAVING (MAX(peso_kg) - MIN(peso_kg)) / 1000.0 > 7
ORDER BY diferencia_t DESC;
-- Resultado: 5 filas. Primera: Agroinsumos El Oro | 20 | 13.6 | 20.8
