# 🛒 E-Commerce ELT Analytics Pipeline (dbt + DuckDB)

Pipeline analítico **ELT End-to-End** diseñado para transformar datos transaccionales crudos en un **Modelo Dimensional en Esquema Estrella**, aplicando pruebas de calidad automatizadas, exportación a formato **Parquet** e integración con herramientas de BI.

---

## 📐 Arquitectura General del Repositorio

```text
  [ CSV Seeds / Raw Data ]
             │
             ▼
   [ DuckDB (Warehouse) ] ◄─── dbt seed (Inicializa la base local)
             │
             ▼
      [ dbt Staging ]    ───► Limpieza, casteos y nombres estándar
             │
             ▼
   [ dbt Intermediate ]  ───► Reglas de negocio, prorrateo y margen
             │
             ▼
       [ dbt Marts ]     ───► Modelo Dimensional (Fact & Dim)
             │
             ▼
  [ Parquet Export Script ] ──► Archivos .parquet para Power BI / BI
```

---

## 📁 Estructura del Repositorio

```text
dbt_elt_analytics/
├── .gitignore                    # Exclusión de binarios y entornos
├── README.md                     # Documentación principal
├── requirements.txt              # Dependencias de Python (dbt-duckdb, pandas, etc.)
│
├── dbt_project/                  # Proyecto dbt Core
│   ├── dbt_project.yml
│   ├── profiles.yml.example      # Plantilla de conexión local
│   ├── seeds/                    # Fuentes en CSV
│   ├── models/                   # Capas Staging, Intermediate y Marts
│   ├── tests/                    # Tests singulares en SQL
│   └── README.md                 # Documentación técnica de dbt
│
├── scripts/                      # Scripts de automatización
│   ├── README.md
│   └── export_marts_to_parquet.py # Exportador de Marts a Parquet
│
├── database/                     # Creado localmente (ignorado por Git)
│   └── warehouse.duckdb          # Base analítica DuckDB
│
└── data_marts_parquet/           # Creado por script (ignorado por Git)
    └── *.parquet                 # Tablas dimensionales listas para BI
```

---

## 🛠️ Requisitos Previos

* **Python 3.8+**
* **Sin base de datos externa:** DuckDB funciona como motor analítico embebido de alto rendimiento desde Python. No requiere instalación de servidores de bases de datos.

---

## 🚀 Guía de Replicación Local

### 1. Clonar el repositorio y configurar el entorno

```bash
git clone [https://github.com/tu_usuario/dbt_elt_analytics.git](https://github.com/tu_usuario/dbt_elt_analytics.git)
cd dbt_elt_analytics

# Crear y activar entorno virtual
python -m venv venv

# Windows:
venv\Scripts\activate
# Linux/macOS:
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt
```

### 2. Configurar perfil de conexión (`profiles.yml`)

```bash
# Linux/macOS:
cp dbt_project/profiles.yml.example ~/.dbt/profiles.yml

# Windows (PowerShell):
copy dbt_project/profiles.yml.example $env:USERPROFILE\.dbt\profiles.yml
```

### 3. Ejecutar el Pipeline (dbt)

```bash
cd dbt_project

# Cargar CSVs y crear la base DuckDB
dbt seed

# Construir capas analíticas
dbt run

# Ejecutar tests de calidad
dbt test
```

### 4. Exportar Tablas a Parquet (para BI)

```bash
cd ..
python scripts/export_marts_to_parquet.py
```

Los archivos `.parquet` se guardarán en `data_marts_parquet/` para ser consumidos desde **Power BI**, Excel o Python.

---

## 📊 Consumo en Power BI / BI

Las tablas exportadas corresponden al Esquema Estrella listo para modelado:
* **Dimensiones:** `dim_customers`, `dim_products`, `dim_date`.
* **Tablas de Hechos:** `fact_orders`, `fact_order_items`, `fact_payments`, `fact_shipments`, `fact_returns`.
