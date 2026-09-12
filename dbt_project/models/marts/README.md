# Capa Marts

En esta capa se expone el modelo dimensional (Esquema Estrella) listo para consumo de Business Intelligence, analítica avanzada y tableros de control en herramientas como Power BI.

## Modelos Incluidos

### Dimensiones (3)
* `dim_customers`: Atributos del cliente (demografía, provincia, estado).
* `dim_products`: Catálogo maestro de productos (categoría, marca, costos y precios de lista).
* `dim_date`: Dimensión calendario continua (2024 - 2027) construida con series nativas de DuckDB.

### Tablas de Hechos (5)
* `fact_orders`: Granularidad por pedido (`order_id`). Consolida ventas netas finales, COGS, costo de envío total, ganancia neta (`net_profit`) y flags de resolución/cancelación.
* `fact_order_items`: Granularidad por línea de pedido (`order_item_id`). Detalla rentabilidad fina con prorrateo de envíos y devoluciones por producto.
* `fact_payments`: Registro transaccional de medios de pago y montos cobrados (relación 1:1 con pedidos).
* `fact_shipments`: Datos logísticos y métricas de eficiencia operativa como días transcurridos hasta la entrega (`delivery_days`).
* `fact_returns`: Detalle de devoluciones aprobadas/rechazadas integradas con dimensión de cliente y producto.

## Reglas de Negocio y Calidad
* **Materialización:** Tablas (`table`) para optimizar el rendimiento de lectura e ingesta.
* **Integridad Referencial:** Tests de claves foráneas (`relationships`) entre todas las tablas de hechos y las dimensiones principales (`dim_customers`, `dim_products`, `dim_date`).
