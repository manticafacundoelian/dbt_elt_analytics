# 🛒 E-commerce Analytics End-to-End: De la Ingeniería ELT al Impacto de Negocio

**Pipeline ELT con dbt Core + DuckDB, Consultas SQL Avanzadas sobre Data Warehouse y Dashboard Interactivo con Hallazgos Estratégicos**

---

## 📐 Arquitectura General del Repositorio

```mermaid
flowchart LR
    A[📄 CSV Raw Seeds] -->|dbt seed| B[(🦆 DuckDB Warehouse)]

    subgraph DBT ["⚙️ dbt Core (Transformación)"]
        B --> C[Staging]
        C --> D[Intermediate]
        D --> E[Marts - Star Schema]
    end

    E -->|DBeaver / SQL| F[🔍 Consultas SQL Ad-hoc]
    E -->|Python Script| G[📦 Archivos Parquet]
    G --> H[📊 Dashboard Power BI]
```

---

## 📌 Resumen Ejecutivo, Hallazgos & Recomendaciones Estratégicas

> ⚠️ *Para priorizar la perspectiva de negocio, esta sección incluirá las capturas del dashboard en Power BI, los principales hallazgos de rentabilidad y las recomendaciones accionables una vez finalizado el modelo visual.*

```text
[ Próximamente: Dashboard Hero Image / Capturas de Tableros ]
```

---

## 📁 Estructura del Repositorio y Guía de Replicación Local

```text
dbt_elt_analytics/
├── .gitignore                    # Exclusión de binarios y entornos
├── README.md                     # Documentación principal del proyecto
├── requirements.txt              # Dependencias de Python (dbt-duckdb, pandas, pyarrow)
│
├── dbt_core_pipeline/            # Módulo dbt Core (Modelado ELT)
│   ├── dbt_project.yml           # Configuración global de dbt
│   ├── profiles.yml.example      # Plantilla de conexión local a DuckDB
│   ├── seeds/                    # Fuentes de datos crudas (CSV)
│   ├── models/                   # Capas Staging, Intermediate y Marts
│   ├── tests/                    # Pruebas de calidad y reglas de negocio
│   └── README.md                 # Documentación técnica del módulo dbt
│
├── sql_business_analysis/        # Investigaciones SQL 
│   ├── README.md                 # Catálogo de consultas y preguntas de negocio
│   └── *.sql                     # Scripts de análisis (RFM, Cohortes, Envíos)
│
├── power_bi_analytics/           # Capa de BI y Reportes
│   ├── README.md                 # Documentación del modelo de datos y medidas DAX
│   └── *.pbix                    # Dashboard ejecutable de Power BI
│
├── scripts/                      # Scripts de automatización
│   ├── README.md                 # Documentación de utilidad
│   └── export_marts_to_parquet.py # Exportador de DuckDB a formato Parquet
│
├── database/                     # Generado localmente (ignorado por Git)
│   └── warehouse.duckdb          # Base de datos analítica DuckDB
│
└── data_marts_parquet/           # Generado por script (ignorado por Git)
    └── *.parquet                 # Tablas dimensionales optimizadas para BI
```

---

## 🚀 Guía de Replicación Local

### Requisitos Previos
* **Python 3.8+**
* **DuckDB embebido:** No requiere instalar ni levantar servidores de bases de datos externos.

### Paso a Paso

1. **Clonar el repositorio y configurar el entorno:**
   ```bash
   git clone [https://github.com/tu_usuario/dbt_elt_analytics.git](https://github.com/tu_usuario/dbt_elt_analytics.git)
   cd dbt_elt_analytics

   # Crear y activar entorno virtual
   python -m venv venv
   
   # En Windows:
   venv\Scripts\activate
   # En Linux/macOS:
   source venv/bin/activate

   # Instalar dependencias
   pip install -r requirements.txt
   ```

2. **Configurar el perfil de conexión dbt:**
   ```bash
   # Linux/macOS:
   cp dbt_project/profiles.yml.example ~/.dbt/profiles.yml

   # Windows (PowerShell):
   copy dbt_project/profiles.yml.example $env:USERPROFILE\.dbt\profiles.yml
   ```

3. **Ejecutar la canalización ELT:**
   ```bash
   cd dbt_project
   dbt seed   # Crea database/warehouse.duckdb e ingesta CSVs
   dbt run    # Construye Staging, Intermediate y Marts
   dbt test   # Valida reglas de negocio y calidad de datos
   ```

4. **Exportar Marts a Parquet:**
   ```bash
   cd ..
   python scripts/export_marts_to_parquet.py
   ```

---

## 📂 Módulos del Proyecto y Documentación Técnica

<details>
<summary>🏗️ <b>1. Módulo dbt Core & Pipeline ELT</b></summary>

<br>

Transformación de datos en 3 capas (Staging, Intermediate y Marts) estructurada en Esquema Estrella y respaldada por una suite de pruebas automáticas.

* **Highlights:** Modelado de hechos y dimensiones, prorrateo de costos logísticos a nivel de ítem y reglas estricta para ventas netas en pedidos cancelados.
* 📂 **Ver documentación completa:** [`/dbt_project/README.md`](./dbt_project/README.md)

</details>

<details>
<summary>🔍 <b>2. Investigaciones y Consultas SQL (Data Warehouse)</b></summary>

<br>

Análisis exploratorio ad-hoc y consultas avanzadas en SQL dialecto DuckDB (ejecutadas desde DBeaver) sobre la capa dimensional de Marts.

* **Highlights:** Segmentación de clientes RFM, análisis de cohortes de retención y rentabilidad por tipo de envío.
* 📂 **Ver catálogo de queries:** [`/sql_queries/README.md`](./sql_queries/README.md)

</details>

<details>
<summary>📊 <b>3. Power BI Dashboard & Modelo DAX</b></summary>

<br>

Modelo semántico conectado a los archivos `.parquet`, relaciones dimensionales y tablero interactivo orientado a la toma de decisiones.

* **Highlights:** Medidas DAX avanzadas (ventas netas, AOV, margen %, retención) y diseño enfocado en la experiencia del usuario de negocio.
* 📂 **Ver modelo y medidas DAX:** [`/power_bi_dashboard/README.md`](./power_bi_dashboard/README.md)

</details>




























# 🛒 TechnoShop Analytics End-to-End: De la Ingeniería ELT al Impacto de Negocio

Pipeline ELT con dbt Core + DuckDB, Consultas SQL Avanzadas sobre Data Warehouse y Dashboard Interactivo con Hallazgos Estratégicos. 

## 📐 Arquitectura General del Repositorio

```mermaid
flowchart LR
    A[📄 CSV Raw Seeds] -->|dbt seed| B[(🦆 DuckDB Warehouse)]

    subgraph DBT ["⚙️ dbt Core (Transformación)"]
        B --> C[Staging]
        C --> D[Intermediate]
        D --> E[Marts - Star Schema]
    end

    E -->|DBeaver / SQL| F[🔍 Consultas SQL Ad-hoc]
    E -->|Python Script| G[📦 Archivos Parquet]
    G --> H[📊 Dashboard Power BI]
```
---
Para priorizar la perspectiva de negocio, este README presenta primero los hallazgos, el impacto y las recomendaciones estratégicas.

---
ESTA PARTE VAMOS A DEJAR PARA CUANDO TENGA LA CAPTURA DEL DASHBOARD, LOS INSIGHTS Y RECOMENDACIONES ESTRATEGICAS
---

ahora creo que podria poner los desplegables. pero no se como encarar esto. Quizas asi:

1. Estructura del Repositorio
   incluiria esto mas detalles que te voy a pasar ahora sobre las consultas sql. se va a ir completando mientras cargue las carpetas sql_queries y power_bi_dashboard:
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
2. Guía de Replicación Local
con todos los requisitos y todo lo que ya hicimos sobre como clonar el proyecto
3. Pipeline ELT (dbt)
aca no se... una especie de resumen corto mas el linbk a la carpeta y readme especifico de dbt_project
4. Investigacion SQl
tambien un resumen y el link que lleve a sql_queries y readme especifico
5. Power Bi dashboard
resumen y accesoa  la carpeta power_bi_dashboard y readme especifico que va a tener algunas dax, relaciones y demas cosas

o quizas deberia tener 1. Estructura del Repositorio y 2. Guía de Replicación Local
con todos los requisitos y todo lo que ya hicimos sobre como clonar el proyecto a lo ultimo o sepaardos.












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
