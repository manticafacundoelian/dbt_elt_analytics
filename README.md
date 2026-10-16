# 🛒 Proyecto de Analítica End-to-End sobre Retail de Tecnología

### Introducción:
Este proyecto abarca el ciclo completo de un proceso de analítica de datos moderno: desde la **generación de un dataset sintético con una narrativa de negocio deliberada**, la construcción de un **Pipeline ELT con dbt Core + DuckDB**, una **Investigación Analítica SQL** sobre el datawarehouse con DBeaver, hasta la elaboración de un **Reporte Interactivo en Power BI**.

### Objetivo:
Identificar las causas raíz de la caída de facturación y, sobre todo, de la rentabilidad de una empresa de retail tecnológico entre 2025 y 2026, y elaborar recomendaciones estratégicas basadas en evidencia para apoyar la toma de decisiones ejecutivas.

### Stack Técnico Principal:

![Python](https://img.shields.io/badge/python-3670A0?style=flat-square&logo=python&logoColor=ffdd54) ![SQL](https://img.shields.io/badge/sql-%2300758F.svg?style=flat-square&logo=sqlite&logoColor=white) ![DuckDB](https://img.shields.io/badge/DuckDB-FFF000?style=flat-square&logo=duckdb&logoColor=black) ![dbt](https://img.shields.io/badge/dbt-%23FF694B.svg?style=flat-square&logo=dbt&logoColor=white) ![DBeaver](https://img.shields.io/badge/DBeaver-%23382923.svg?style=flat-square&logo=dbeaver&logoColor=white) ![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)

---

## 🔄 Flujo de los Datos Completo (Arquitectura Pipeline)

```mermaid
flowchart LR

    Z[🐍 Generador Sintético] -->|genera| A[📄 CSV Seeds]
    A -->|dbt seed| B[(🦆 DuckDB Warehouse)]

    subgraph DBT["⚙️ Pipeline ELT con dbt Core"]
        C[Staging] --> D[Intermediate]
        D --> E[Marts]
    end

    B --> C

    E --> F[🔍 Investigación Analítica SQL]

    E --> G[🐍 Script de Exportación en Python]
    G --> H[📦 Parquet]
    H --> I[📊 Modelo de Datos & Reporte en Power BI]

    E --> J[🧪 dbt Tests]
```

---

> ⚠️ Para priorizar la perspectiva de negocio, este README presenta primero el problema, los principales hallazgos obtenidos con el Reporte en Power BI y las recomendaciones estratégicas. A continuación, se detallan los **módulos y componentes que conforman el proyecto**, junto con sus respectivas documentaciones, dejando para el final la estructura del repositorio y la guía de replicación.

---

### 🗺️ Índice
- [Problema de Negocio](#-problema-de-negocio)
- [Hallazgos del Análisis en Power BI](#-hallazgos-del-análisis-en-power-bi)
- [Recomendaciones Estratégicas](#-recomendaciones-estratégicas-basadas-en-evidencia)
- [Desarrollo Técnico & Módulos](#%EF%B8%8F-desarrollo-técnico--módulos)
  - [1. Pipeline ELT con dbt Core + DuckDB](#%EF%B8%8F-1-pipeline-elt-con-dbt-core--duckDB)
  - [2. Investigación Analítica SQL](#-2-investigación-analítica-sql)
  - [3. Script de Exportación en Python](#-3-script-de-exportación-en-python)
  - [4. Modelo de Datos & Reporte en Power BI](#-4-modelo-de-datos--reporte-en-power-bi)
- [Estructura del Repositorio y Guía de Replicación](#-estructura-del-repositorio--guía-de-replicación-local)
- [Autor](#-autor)

---

## 📉 Problema de Negocio

A pesar de haber alcanzado un volumen récord de transacciones entre 2025 y 2026 (**+4.30% en pedidos**), la compañía enfrenta un severo deterioro financiero. 

Las **Ventas Netas cayeron un -38.85%** como consecuencia de un desplome directo en el **Ticket Promedio Comercial (-41.37%)**. Sobre esta menor base de ingresos, la presión de la estructura de costos provocó que la **Ganancia Neta colapsara un -66.20%**, reduciendo el margen neto de la empresa del **18.53% al 10.66%**.

El objetivo de este proyecto es identificar las causas raíz detrás de la caída de ingresos y la compresión de márgenes, evaluando el impacto del mix de productos, los descuentos y la estructura de costos para proponer recomendaciones estratégicas basadas en evidencia.

---
---

## 📊 Hallazgos del Análisis en Power BI 

<details>
<summary><b>1. Vista Ejecutiva — ¿Qué pasó con el negocio? (Clic para expandir)</b></summary><br>

<!-- Aqui pongo los hallazgos -->

![Vista Ejecutiva](./power_bi_analytics/vista_ejecutiva.gif)
</details>

<!-- Y asi repito con las otras hojas de BI -->

---
---

## 🎯 Recomendaciones Estratégicas Basadas en Evidencia



---
---

## 🛠️ Desarrollo Técnico & Módulos

A continuación se detallan los módulos técnicos que dan soporte al análisis de negocio, junto con sus respectivas documentaciones.

---
---

## ⚙️ 1. Pipeline ELT con dbt Core + DuckDB

Construcción de una capa analítica reproducible sobre **DuckDB**, utilizando **dbt Core** para transformar datos transaccionales en un **Modelo Dimensional (Star Schema)** preparado para el análisis de negocio y el consumo en Power BI.

El pipeline organiza las transformaciones en tres capas, separando progresivamente la limpieza de datos, la aplicación de lógica de negocio y la construcción del modelo analítico final:

**CSV Raw → Staging → Intermediate → Marts**

**Principales componentes:**

* **Staging:** limpieza, estandarización de nombres y casteo de tipos sobre las fuentes raw.
* **Intermediate:** aplicación de lógica de negocio, enriquecimiento de datos, prorrateo de costos logísticos y cálculo de métricas de margen.
* **Marts:** construcción del modelo dimensional compuesto por tablas de hechos y dimensiones para el análisis posterior.

**Reglas de negocio destacadas:**

* Los pedidos cancelados conservan sus montos brutos para analizar demanda perdida, pero sus ventas netas se establecen en $0.
* Los costos de envío se prorratean a nivel de línea de pedido según su participación sobre el valor bruto de la orden.
* Las devoluciones ajustan las ventas netas finales y el COGS para reflejar el impacto económico del stock devuelto.

**Calidad y reproducibilidad:**

* Implementación de tests de **unicidad, no nulidad, integridad referencial y valores permitidos** mediante dbt.
* Validaciones SQL personalizadas para controlar la coherencia temporal y la consistencia de métricas y montos.
* Pipeline completamente reproducible mediante comandos `dbt seed`, `dbt run`, `dbt test` y `dbt build`.

📁 **Directorio:** [`/dbt_core_pipeline`](./dbt_core_pipeline)
📄 **Documentación:** [Ver README técnico del módulo dbt](./dbt_core_pipeline/README.md)

---
---

## 🔍 2. Investigación Analítica SQL

Análisis de un retail de tecnología (dataset ficticio, 2024–2026) sobre **DuckDB** y modelos **dbt** (staging → intermediate → marts). Son 8 consultas encadenadas en dos ramas, comercial y de rentabilidad, que responden una sola pregunta: **¿por qué cayeron las ventas y, sobre todo, la ganancia?** Los puentes concilian con la variación observada y la rentabilidad se mide sobre pedidos entregados, netos de devoluciones.

| Consulta | Pregunta | Qué encontró |
|---|---|---|
| **Q1** | ¿Qué cambió? | Ventas Netas −38,85% y Ganancia Neta −65,58% (2025 → 2026) |
| **Q2–Q4** | ¿Por qué se vende menos? | Por volumen y mezcla, no por precio. El ticket cae 41,37% (UPT −23,67%, ASP −23,18%) y TV y Video explica cerca del 68% de la caída |
| **Q5** | ¿Cuándo se rompió la rentabilidad? | En el 2S: el margen neto pasa de 16,89% (1S) a 2,30% (2S) |
| **Q6** | ¿Por qué cae la Ganancia Bruta? | −$77,44 M, sobre todo por el costo (56,0%) y la mezcla (33,8%) |
| **Q7** | ¿Y el margen bruto? | −12,07 pp, de los cuales el 91% es margen propio de los productos |
| **Q8** | ¿Qué pierde plata hoy? | 31 de 86 segmentos pierden −$13,23 M; cinco productos concentran el 76,6% |

**Conclusión:** el costo unitario subió en los 78 segmentos continuos (mediana +13,9%) y el precio casi no se movió (+0,2%). La pérdida del 2S no está repartida: está concentrada en pocos productos, con TV y Video y dos lanzamientos a pérdida como focos.

👉 [Ver la investigación completa, con consultas, resultados y recomendaciones](./sql_business_analysis/README.md)


* 📁 **Directorio:** [`/sql_business_analysis`](./sql_business_analysis)

* 📄 **Documentación:** [Ver Catálogo de Consultas SQL](./sql_business_analysis/README.md)

---
---

## 🐍 3. Script de Exportación en Python
Script automatizado que extrae los datos modelados en los Marts de DuckDB y los convierte a archivos optimizados en formato Parquet para una ingesta eficiente desde Power BI.
* 📁 **Directorio:** [`/scripts`](./scripts)
* 📄 **Documentación:** [Ver README de scripts](./scripts/README.md)

---
---

## 📊 4. Modelo de Datos & Reporte en Power BI
Diseño de la capa de visualización analítica sobre los archivos Parquet. Incluye la arquitectura del modelo de datos en estrella (Star Schema), implementación de medidas DAX avanzadas (Time Intelligence, KPIs dinámicos, análisis YoY), optimización del rendimiento y diseño de UX/UI enfocado en decisiones ejecutivas.
* 📁 **Directorio:** [`/power_bi_analytics`](./power_bi_analytics)
* 📄 **Documentación:** [Ver README técnico de Power BI](./power_bi_analytics/README.md)

---
---

## 📂 Estructura del Repositorio & Guía de Replicación Local

<details>
<summary><b>🛠️ Ver Árbol de Carpetas y Pasos de Instalación (Clic para expandir)</b></summary><br>

### Estructura del Repositorio

```text
dbt_elt_analytics/
├── .gitignore                       # Exclusión de binarios y entornos
├── README.md                        # Documentación principal del proyecto
├── requirements.txt                 # Dependencias de Python (dbt-duckdb, pandas, pyarrow)
│
├── dbt_core_pipeline/               # Módulo dbt Core (Modelado ELT)
│   ├── dbt_project.yml              # Configuración global de dbt
│   ├── profiles.yml.example         # Plantilla de conexión local a DuckDB
│   ├── seeds/                       # Fuentes de datos crudas (CSV)
│   ├── models/                      # Capas Staging, Intermediate y Marts
│   ├── tests/                       # Pruebas de calidad y reglas de negocio
│   └── README.md                    # Documentación técnica del módulo dbt
│
├── sql_business_analysis/           # Investigaciones SQL
│   ├── README.md                    # Documentación de la investigación
│   └── *.sql                        # Scripts de investigación y análisis de negocio
│
├── power_bi_analytics/              # Capa de BI y Reportes
│   ├── README.md                    # Documentación del modelo de datos y medidas DAX
│   └── *.pbix                       # Dashboard ejecutable de Power BI
│
├── scripts/                         # Scripts de automatización
│   ├── README.md                    # Documentación de utilidad
│   └── export_marts_to_parquet.py   # Exportador de DuckDB a formato Parquet
│
├── database/                        # Generado localmente (ignorado por Git)
│   └── warehouse.duckdb             # Base de datos analítica DuckDB
│
└── data_marts_parquet/              # Generado por script (ignorado por Git)
    └── *.parquet                    # Tablas dimensionales optimizadas para BI
```

### Guía de Replicación Local

### Requisitos Previos
* **Python 3.8+**
* **DuckDB embebido:** No requiere instalar ni levantar servidores de bases de datos externos.

### Paso a Paso

1. **Clonar el repositorio y configurar el entorno:**
   ```bash
   git clone https://github.com/tu_usuario/dbt_elt_analytics.git
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
   cp dbt_core_pipeline/profiles.yml.example ~/.dbt/profiles.yml

   # Windows (PowerShell):
   copy dbt_core_pipeline\profiles.yml.example $env:USERPROFILE\.dbt\profiles.yml
   ```

3. **Ejecutar la canalización ELT:**
   ```bash
   cd dbt_core_pipeline
   dbt seed   # Crea database/warehouse.duckdb e ingesta CSVs
   dbt run    # Construye Staging, Intermediate y Marts
   dbt test   # Valida reglas de negocio y calidad de datos
   ```

4. **Exportar Marts a Parquet:**
   ```bash
   cd ..
   python scripts/export_marts_to_parquet.py
   ```

Los archivos `.parquet` se guardarán en `data_marts_parquet/` para ser consumidos desde **Power BI**, Excel o Python.

</details>

---
---

## 👤 Autor

<!-- Tu nombre, LinkedIn y/o portfolio -->

























