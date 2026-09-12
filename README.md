# Proyecto dbt: Transformación y Modelado Analytics (e-Commerce)

Este proyecto dbt transforma los datos crudos del sistema transaccional de e-commerce en un **Modelo Dimensional (Esquema Estrella)** optimizado para análisis de negocio, reportes ejecutivos y consumo en herramientas de BI como Power BI.

---

## 🏗️ Arquitectura de Capas (ELT Pipeline)

El modelado sigue la arquitectura de tres capas recomendada por dbt:

1. **Staging:** Limpieza inicial, estandarización de nombres de columnas y casteos de tipos de datos a partir de la fuente cruda.
2. **Intermediate:** Implementación de reglas de negocio complejas, prorrateo de envíos a nivel ítem, cálculo de costos de reposición y agregación de métricas.
3. **Marts:** Construcción del Esquema Estrella final (Tablas de Hechos y Dimensiones) listo para consumo analítico.

---

## 📁 Estructura del Proyecto

```text
dbt_project/
├── dbt_project.yml          # Configuración global del proyecto dbt y materializaciones
├── README.md                # Documentación principal del proyecto dbt
├── seeds/                   # Tablas semilla en CSV (lookups, parámetros)
├── models/
│   ├── staging/             # Vistas de limpieza y estandarización
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_order_items.sql
│   │   ├── stg_products.sql
│   │   ├── stg_payments.sql
│   │   ├── stg_shipments.sql
│   │   ├── stg_returns.sql
│   │   ├── schema.yml       # Definición de fuentes, modelos y pruebas base
│   │   └── README.md
│   │
│   ├── intermediate/        # Transformaciones intermedias y lógica de negocio
│   │   ├── int_order_items_enriched.sql
│   │   ├── int_order_shipping_allocated.sql
│   │   ├── int_order_metrics.sql
│   │   ├── schema.yml       # Pruebas de calidad intermedias
│   │   └── README.md
│   │
│   └── marts/               # Modelo Dimensional (Esquema Estrella)
│       ├── dim_customers.sql
│       ├── dim_products.sql
│       ├── dim_date.sql
│       ├── fact_orders.sql
│       ├── fact_order_items.sql
│       ├── fact_payments.sql
│       ├── fact_shipments.sql
│       ├── fact_returns.sql
│       ├── schema.yml       # Pruebas de unicidad, no nulidad y relaciones FK
│       └── README.md
└── scripts/                 # Scripts auxiliares y automatizaciones
```

---

## 📊 Modelo Dimensional (Esquema Estrella - Marts)

### Dimensiones (`dim_*`)
* **`dim_customers`**: Datos demográficos y estado del cliente (`active` / `inactive`).
* **`dim_products`**: Catálogo de productos con categoría, costo y precio de lista.
* **`dim_date`**: Calendario continuo generado dinámicamente con funciones nativas de DuckDB (`generate_series`).

### Tablas de Hechos (`fact_*`)
* **`fact_orders`** *(Grano: Pedido)*: Consolida el ciclo comercial completo por orden. Mide ventas brutas, descuentos, ventas netas finales (`final_net_sales`), COGS real (`final_cogs`), costo de envío total y ganancia neta (`net_profit`). Incluye flags de control (`is_cancelled`, `is_resolved`).
* **`fact_order_items`** *(Grano: Línea de Pedido)*: Análisis fino por ítem vendido. Incorpora costo de reposición (`replacement_cost`), costo de envío prorrateado por ítem y márgenes por producto.
* **`fact_payments`** *(Grano: Pago)*: Registro transaccional de medios de pago (`credit_card`, `debit_card`, `transfer`, `digital_wallet`) y estados de pago.
* **`fact_shipments`** *(Grano: Envío)*: Métricas de eficiencia logística, incluyendo fechas de despacho, entrega y días de tránsito (`delivery_days`).
* **`fact_returns`** *(Grano: Devolución)*: Registro de productos devueltos, razones de devolución y montos reembolsados integrados con clientes y productos.

---

## 💡 Reglas de Negocio Clave

1. **Gestión de Cancelaciones:**
   - En pedidos cancelados (`is_cancelled = 1`), los montos brutos (`gross_amount`) y descuentos se preservan para medir la demanda perdida, mientras que las ventas netas (`net_sales`) y cobranzas se fuerzan a 0.
2. **Impacto de Devoluciones:**
   - `final_net_sales = net_sales - refund_amount`.
   - `final_cogs`: Ajusta el costo de mercadería descontando las unidades recuperadas en devoluciones aprobadas.
3. **Prorrateo de Envíos:**
   - El costo de envío del pedido se asigna a cada línea proporcionalmente a su peso en la venta bruta del pedido (`gross_amount`).
4. **Flag de Pedidos Resueltos (`is_resolved`):**
   - Identifica pedidos en estado final (`delivered` o `cancelled`) para aislar transacciones en tránsito al evaluar la rentabilidad mensual.

---

## 🛡️ Estrategia de Calidad y Tests

El proyecto implementa pruebas de datos automatizadas mediante dbt:
* **Integridad Primaria:** Tests `unique` y `not_null` en las claves primarias de todas las tablas.
* **Integridad Referencial:** Tests `relationships` entre las tablas de hechos (`fact_*`) y las dimensiones (`dim_*`).
* **Valores Aceptados:** Tests `accepted_values` en estados de pedidos, métodos de pago, canales y flags (`0` o `1`).

---

## 🚀 Guía de Ejecución

1. **Cargar semillas (lookup tables):**
   ```bash
   dbt seed
   ```

2. **Ejecutar modelos (construcción de capas):**
   ```bash
   dbt run
   ```

3. **Ejecutar pruebas de calidad:**
   ```bash
   dbt test
   ```

4. **Generar y visualizar la documentación interactiva (Lineage Graph):**
   ```bash
   dbt docs generate
   dbt docs serve
   ```
