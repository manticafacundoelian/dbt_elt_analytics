# Capa Staging

En esta capa se realiza la ingestión, limpieza inicial y estandarización de los datos de origen (`seeds`).

## Responsabilidades
* **Renombrado y estandarización:** Conversión de nombres de columnas a la convención `snake_case` y traducción a nombres del dominio.
* **Casteo de tipos:** Definición explícita de tipos de datos (fechas, numéricos, texto).
* **Limpieza básica:** Limpieza de espacios en blanco, tratamiento inicial de nulos y formateo.
* **Mapeo 1 a 1:** Cada modelo representa directamente una entidad fuente sin aplicar joins ni agregaciones de negocio.

## Configuración
* **Materialización:** Vistas (`view`).
* **Prefijo de modelos:** `stg_` (ej. `stg_customers.sql`).
