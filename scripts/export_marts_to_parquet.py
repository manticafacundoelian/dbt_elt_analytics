import os
import duckdb

# Rutas adaptadas a la estructura de carpetas del proyecto
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(BASE_DIR, "database", "warehouse.duckdb")
OUTPUT_DIR = os.path.join(BASE_DIR, "data_marts_parquet")

# Crear carpeta de destino si no existe
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Conexión a DuckDB
con = duckdb.connect(DB_PATH)

# Tablas analíticas finales (Marts)
marts_tables = [
    "fact_orders",
    "fact_order_items",
    "fact_payments",
    "fact_shipments",
    "fact_returns",
    "dim_customers",
    "dim_products",
    "dim_date",
]

print(f"Conectando a {DB_PATH}...")
print("Iniciando exportación a Parquet...")

for table in marts_tables:
    parquet_file = os.path.join(OUTPUT_DIR, f"{table}.parquet")
    query = f"COPY {table} TO '{parquet_file}' (FORMAT PARQUET);"
    con.execute(query)
    print(f"  ✓ Tabla '{table}' exportada a '{parquet_file}'")

con.close()
print(f"Exportación finalizada. Archivos disponibles en: {OUTPUT_DIR}")