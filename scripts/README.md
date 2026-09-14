# Scripts de Utilidad y Automatización

Esta carpeta contiene scripts de Python auxiliares para el pipeline analítico.

## Scripts Incluidos

### `export_marts_to_parquet.py`
* **Propósito:** Se conecta a la base de datos DuckDB local (`database/warehouse.duckdb`), lee las tablas finales de la capa de negocio (`marts`) y las exporta en formato **Apache Parquet** dentro de la carpeta `data_marts_parquet/`.
* **Caso de Uso:** Facilita la ingesta eficiente de los modelos dimensionales desde herramientas de BI (como Power BI) o motores de procesamiento sin necesidad de mantener la base de datos DuckDB abierta.

## Ejecución

```bash
python scripts/export_marts_to_parquet.py
