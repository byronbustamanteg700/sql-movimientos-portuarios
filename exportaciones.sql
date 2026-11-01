-- Exportaciones: concentración de clientes y desempeño por naviera
-- Base: movimientos.sql (SQLite)


-- E1. ¿Qué clientes concentran más del 10 % de los kilos exportados
--     y cómo están frente a la meta de 500 toneladas?
SELECT cliente,
       ROUND(SUM(peso_kg) / 1000.0, 1)  AS toneladas,
       ROUND(SUM(peso_kg) * 100.0 /
             (SELECT SUM(peso_kg) FROM movimientos
              WHERE movimiento = 'Exportación'), 2) AS pct_exportado,
       ROUND(SUM(peso_kg) / 1000.0 - 500, 1)       AS brecha_meta_t
FROM movimientos
WHERE movimiento = 'Exportación'
GROUP BY cliente
HAVING SUM(peso_kg) * 100.0 /
       (SELECT SUM(peso_kg) FROM movimientos
        WHERE movimiento = 'Exportación') > 10
ORDER BY pct_exportado DESC;


-- E2. ¿Qué parejas naviera–cliente sostienen el volumen exportado
--     (5 contenedores o más)?
SELECT naviera,
       cliente,
       COUNT(*)      AS contenedores,
       SUM(peso_kg)  AS kilos
FROM movimientos
WHERE movimiento = 'Exportación'
GROUP BY naviera, cliente
HAVING COUNT(*) >= 5
ORDER BY naviera, kilos DESC;


-- E3. Exportaciones de 40 pies de MSC y Maersk entre el 5 y el 25 de
--     septiembre, sin el cliente Bananera del Sur: volumen y pesos.
SELECT COUNT(*)                 AS contenedores,
       COUNT(DISTINCT cliente)  AS clientes,
       SUM(peso_kg)             AS kilos,
       ROUND(AVG(peso_kg), 2)   AS peso_promedio,
       MAX(peso_kg)             AS peso_maximo
FROM movimientos
WHERE movimiento = 'Exportación'
  AND tamano = 40
  AND naviera IN ('MSC', 'Maersk')
  AND fecha BETWEEN '2026-09-05' AND '2026-09-25'
  AND cliente <> 'Bananera del Sur';


-- E4. ¿Cuál fue el contenedor más pesado de ese mismo grupo?
SELECT contenedor, naviera, cliente, fecha, peso_kg
FROM movimientos
WHERE movimiento = 'Exportación'
  AND tamano = 40
  AND naviera IN ('MSC', 'Maersk')
  AND fecha BETWEEN '2026-09-05' AND '2026-09-25'
  AND cliente <> 'Bananera del Sur'
ORDER BY peso_kg DESC
LIMIT 1;
