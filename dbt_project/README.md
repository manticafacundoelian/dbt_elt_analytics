# ⚙️ Módulo dbt: Transformación y Modelado Dimensional

Capa analítica desarrollada con **dbt Core** sobre **DuckDB**, orientada a transformar datos transaccionales en un **Modelo Dimensional (Esquema Estrella)** reproducible, testeado y listo para consumo de negocio.

---

## 🛠️ Stack Tecnológico

* **DuckDB** — Data Warehouse analítico local de alto rendimiento.
* **dbt Core** — Transformación de datos, modelado dimensional, linaje y tests de calidad.
* **SQL (Dialecto DuckDB)** — Lógica de transformación, agregaciones y analítica.
* **CSV** — Fuentes de datos raw ingeridas mediante `dbt seed`.

---

## 📐 Arquitectura de Capas (DAG)

```text
CSV (Seeds)
  │
  ▼
Staging (vistas de limpieza, casteos y estandarización)
  │
  ▼
Intermediate (transformaciones, prorrateos y enriquecimiento)
  │
  ▼
Marts (Modelo Dimensional: Tablas de Hechos y Dimensiones)
```

---

## 📦 Desglose de Modelos

### 1. Staging (`models/staging/`)
Limpieza inicial, renombrado de columnas a estándares del proyecto y casteo de tipos de datos sobre la capa raw.
* `stg_customers`, `stg_orders`, `stg_order_items`, `stg_products`, `stg_payments`, `stg_shipments`, `stg_returns`.

### 2. Intermediate (`models/intermediate/`)
Lógica de negocio compleja, prorrateo de costos de envío a nivel ítem y cálculo de márgenes.
* `int_order_items_enriched`, `int_order_shipping_allocated`, `int_order_metrics`.

### 3. Marts (`models/marts/`)
Modelo Dimensional final para consumo analítico:
* **Dimensiones:** `dim_customers`, `dim_products`, `dim_date`.
* **Hechos:** `fact_orders`, `fact_order_items`, `fact_payments`, `fact_shipments`, `fact_returns`.

---

## 💡 Reglas de Negocio Clave

1. **Cancelaciones:** En pedidos cancelados (`is_cancelled = 1`), las ventas netas (`net_sales`) se fuerzan a $0 preservando los montos brutos para análisis de demanda perdida.
2. **Prorrateo de Envíos:** El costo logístico de la orden se asigna a cada línea de pedido proporcionalmente a su peso sobre el total bruto.
3. **Devoluciones:** `final_net_sales` ajusta el reembolso (`refund_amount`) y recalcula el COGS real descontando stock devuelto.

---

## 🧪 Data Quality & Governance

* **Tests Genéricos (`schema.yml`):** Unicidad (`unique`), no nulidad (`not_null`), integridad referencial (`relationships`) y valores permitidos (`accepted_values`).
* **Tests Singulares (`tests/`):** Validaciones SQL customizadas para coherencia temporal de fechas, montos pagados vs. ventas netas y rangos de precios/costos.

---

## 🚀 Comandos de Ejecución (dbt CLI)

Ubicado dentro de la carpeta `dbt_project/`:

```bash
# 1. Cargar semillas CSV a DuckDB
dbt seed

# 2. Ejecutar transformaciones SQL
dbt run

# 3. Correr pruebas de calidad
dbt test

# 4. Construir todo secuencialmente (seed + run + test)
dbt build

# 5. Generar documentación interactiva y grafo de linaje
dbt docs generate
dbt docs serve
```
