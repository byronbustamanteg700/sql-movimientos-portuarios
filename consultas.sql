-- =====================================================================
-- Análisis de movimientos de contenedores con SQL (SQLite)
-- Autor: Byron Bustamante
-- Base: base_practica_200.sql (tabla movimientos, 200 filas, datos de práctica)
-- Columnas: id, contenedor, tamano, tipo, naviera, movimiento, fecha, peso_kg, cliente
-- =====================================================================


-- ---------------------------------------------------------------------
-- BLOQUE 1. CONSULTAS BÁSICAS (filtrar y ordenar)
-- ---------------------------------------------------------------------

-- 1. ¿Cuáles son los 5 contenedores de exportación más pesados?
--    Mostrar contenedor, naviera, cliente y peso.


-- 2. Importaciones de contenedores de 20 pies de MSC o de Hapag-Lloyd
--    desde el 16 de septiembre. Mostrar contenedor, naviera, fecha, peso
--    y cliente, ordenadas por fecha.


-- 3. ¿Cuántos clientes distintos exportan y cuántos importan?



-- ---------------------------------------------------------------------
-- BLOQUE 2. RESÚMENES (GROUP BY)
-- ---------------------------------------------------------------------

-- 4. Por naviera: cuántos contenedores y cuántos kilos movió,
--    de la que más kilos movió a la que menos.


-- 5. Por tipo de contenedor y tipo de movimiento: cuántos contenedores
--    y peso promedio en toneladas con dos decimales.


-- 6. ¿Cuáles fueron los 3 días con más movimientos?
--    Mostrar la fecha, cuántos contenedores y cuántos kilos.


-- 7. Los 5 clientes que más toneladas exportaron (con un decimal).



-- ---------------------------------------------------------------------
-- BLOQUE 3. FILTROS SOBRE GRUPOS (HAVING)
-- ---------------------------------------------------------------------

-- 8. ¿Qué clientes tuvieron al menos 15 movimientos?
--    Del que más tuvo al que menos.


-- 9. Exportaciones por naviera y cliente: cuántos contenedores y kilos.
--    Solo las parejas con al menos 5 contenedores. Ordenadas por naviera
--    y, dentro de cada naviera, de más kilos a menos.



-- ---------------------------------------------------------------------
-- BLOQUE 4. INDICADORES CALCULADOS
-- ---------------------------------------------------------------------

-- 10. ¿Qué porcentaje de los kilos exportados (3.076.500 kg) movió cada
--     naviera? Toneladas con un decimal y porcentaje con un decimal,
--     de mayor a menor.


-- 11. Por naviera: diferencia en toneladas entre su contenedor más pesado
--     y el más liviano, con un decimal. De mayor diferencia a menor.


-- 12. Clientes que exportaron más de 300 toneladas: toneladas (un decimal),
--     porcentaje del total exportado (dos decimales) y cuántas toneladas
--     les faltan para llegar a 500 (un decimal). Del mayor porcentaje al menor.

