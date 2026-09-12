# Modern Data Stack: Data Warehouse & ELT Pipeline (dbt + DuckDB)

Capa analítica desarrollada con **dbt Core** sobre **DuckDB**, orientada a transformar datos transaccionales en modelos analíticos reproducibles, testeados y listos para consumo de negocio.

El proyecto implementa una arquitectura ELT por capas que separa la preparación, enriquecimiento, modelado dimensional y exposición final de los datos.

---

## 🛠️ Stack Tecnológico

* **DuckDB** — Data Warehouse analítico local de alto rendimiento.
* **dbt Core** — Transformación de datos, modelado dimensional, linaje y tests de calidad.
* **SQL (Dialecto DuckDB)** — Lógica de transformación, agregaciones y analítica.
* **CSV** — Fuentes de datos raw ingeridas mediante `dbt seed`.

---

## 📐 Arquitectura del Pipeline (DAG)

```text
CSV (Seeds)
  │
  ▼
Staging (vistas de limpieza y estandarización)
  │
  ▼
Intermediate (transformaciones y enriquecimiento)
  │
  ▼
Dimensions & Facts (tablas dimensionales y de hechos)
  │
  ▼
Marts (capa final de consumo analítico / BI)
```

---

## 📦 Desglose de Capas y Modelos

### 1. Staging (`models/staging/`)
Limpieza inicial, renombrado de columnas a estándares del proyecto y casteo de tipos de datos sobre la capa raw.

* `stg_customers`
* `stg_orders`
* `stg_order_items`
* `stg_products`
* `stg_payments`
* `stg_shipments`
* `stg_returns`

### 2. Intermediate (`models/intermediate/`)
Transformaciones intermedias y uniones complejas antes de estructurar el modelo dimensional final.

* `int_order_items_enriched`
* `int_sales_enriched`

### 3. Dimensions (`models/marts/`)
Entidades de negocio utilizadas para contextualizar las métricas.

* `dim_customers`
* `dim_products`
* `dim_date`

### 4. Facts (`models/marts/`)
Tablas de hechos con las métricas y eventos transaccionales del proceso comercial.

* `fact_orders`
* `fact_order_items`
* `fact_payments`
* `fact_shipments`
* `fact_returns`

---

## 🧪 Data Quality & Governance

El proyecto aplica tests automatizados de dbt para garantizar la confiabilidad de la información:

* **Integridad Primaria:** Unicidad (`unique`) y no nulidad (`not_null`) en PKs.
* **Integridad Referencial:** Claves foráneas validadas entre tablas de hechos y dimensiones (`relationships`).
* **Reglas de Negocio:** Validación de importes monetarios no negativos, rangos de descuentos válidos y cantidades coherentes.

---

## 📁 Estructura del Módulo `dbt_project`

```text
dbt_project/
├── analyses/       # Consultas SQL exploratorias fuera del DAG
├── macros/         # Macros Jinja reutilizables
├── models/         # Transformaciones (staging, intermediate, marts)
│   ├── staging/
│   ├── intermediate/
│   └── marts/
├── seeds/          # Archivos CSV de datos fuente
├── snapshots/      # Control de cambios de dimensión (SCD)
├── tests/          # Tests de datos SQL personalizados
├── dbt_project.yml # Configuración principal del proyecto dbt
└── README.md       # Documentación del módulo
```

---

## 🚀 Ejecución y Comandos

Si estás ubicado en la **raíz del repositorio general (`dbt_elt_analytics`)**:

```bash
# Construir todos los modelos y ejecutar los tests indicando el directorio del proyecto
dbt build --project-dir dbt_project

# Validar la conexión con DuckDB y los perfiles
dbt debug --project-dir dbt_project
```

Si estás ubicado **dentro de la carpeta `dbt_project/`**:

```bash
# Cargar archivos CSV iniciales a DuckDB
dbt seed

# Ejecutar las transformaciones SQL
dbt run

# Correr las pruebas de calidad de datos
dbt test

# Construir todo en un solo comando (seed + run + test)
dbt build
```

---

## 🎯 Objetivo de la Capa

Transformar registros transaccionales sin procesar en una estructura de **Modelado Dimensional (Star Schema)** confiable, documentada y lista para abastecer consultas analíticas avanzadas o tableros en Power BI.
