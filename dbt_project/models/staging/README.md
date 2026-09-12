# Capa Staging

En esta capa se realiza la ingestión, limpieza inicial y estandarización de las fuentes de datos transaccionales (`seeds`).

## Modelos Incluidos (7)
* `stg_customers`: Información demográfica, provincia y estado del cliente (`active`/`inactive`).
* `stg_products`: Catálogo de productos, marcas, categorías, precios de lista y costos.
* `stg_orders`: Cabecera de pedidos, canal de venta (`online`/`physical`) y estado de la orden.
* `stg_order_items`: Detalle a nivel de ítem por pedido, cantidades, precios cobrados y descuentos.
* `stg_payments`: Registro de transacción de pago (relación 1:1 con pedidos).
* `stg_shipments`: Datos logísticos y costos de envío (relación 0..1 con pedidos).
* `stg_returns`: Registro de devoluciones y reembolsos a nivel de ítem.

## Reglas de Negocio y Calidad
* **Materialización:** Vistas (`view`).
* **Pruebas de Calidad (`data_tests`):** Se validan claves primarias unicas y no nulas (`unique`, `not_null`), claves foráneas e integridad referencial (`relationships`) y valores permitidos (`accepted_values`).
