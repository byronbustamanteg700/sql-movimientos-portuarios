-- Navieras: participación y perfil de carga
-- Base: movimientos.sql (SQLite)


-- N1. ¿Qué participación tiene cada naviera en las importaciones?
SELECT naviera,
       COUNT(*)                         AS contenedores,
       ROUND(SUM(peso_kg) / 1000.0, 1)  AS toneladas,
       ROUND(COUNT(*) * 100.0 /
             (SELECT COUNT(*) FROM movimientos
              WHERE movimiento = 'Importación'), 1) AS pct_contenedores
FROM movimientos
WHERE movimiento = 'Importación'
GROUP BY naviera
ORDER BY pct_contenedores DESC;


-- N2. Carga seca de Maersk y CMA CGM entre el 5 y el 25 de septiembre:
--     ¿qué clientes promedian más de 21 toneladas por contenedor?
SELECT cliente,
       COUNT(*)                         AS contenedores,
       SUM(peso_kg)                     AS kilos,
       ROUND(AVG(peso_kg) / 1000.0, 2)  AS promedio_t
FROM movimientos
WHERE tipo = 'Seco'
  AND naviera IN ('Maersk', 'CMA CGM')
  AND fecha BETWEEN '2026-09-05' AND '2026-09-25'
GROUP BY cliente
HAVING AVG(peso_kg) > 21000
ORDER BY promedio_t DESC;
