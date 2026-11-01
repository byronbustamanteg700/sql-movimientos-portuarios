-- Importaciones: clientes, volumen y dispersión de pesos
-- Base: movimientos.sql (SQLite)


-- I1. ¿Quiénes son los importadores y cuál es su peso promedio por contenedor?
SELECT cliente,
       COUNT(*)                         AS contenedores,
       ROUND(AVG(peso_kg) / 1000.0, 2)  AS promedio_t
FROM movimientos
WHERE movimiento = 'Importación'
GROUP BY cliente
ORDER BY contenedores DESC;


-- I2. ¿Qué importadores tienen cargas más dispares
--     (más de 7 t entre su contenedor más pesado y el más liviano)?
SELECT cliente,
       COUNT(*)                                          AS contenedores,
       ROUND((MAX(peso_kg) - MIN(peso_kg)) / 1000.0, 1)  AS rango_t,
       ROUND(AVG(peso_kg) / 1000.0, 2)                   AS promedio_t
FROM movimientos
WHERE movimiento = 'Importación'
GROUP BY cliente
HAVING (MAX(peso_kg) - MIN(peso_kg)) / 1000.0 > 7
ORDER BY rango_t DESC;


-- I3. Sin contar Maersk: ¿qué combinaciones cliente–tamaño superan
--     5 contenedores y 85 toneladas?
SELECT cliente,
       tamano,
       COUNT(*)      AS contenedores,
       SUM(peso_kg)  AS kilos,
       MAX(peso_kg)  AS peso_maximo
FROM movimientos
WHERE movimiento = 'Importación'
  AND naviera <> 'Maersk'
GROUP BY cliente, tamano
HAVING COUNT(*) >= 5
   AND SUM(peso_kg) > 85000
ORDER BY kilos DESC;
