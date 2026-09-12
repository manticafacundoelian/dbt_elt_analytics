# Capa Intermediate

En esta capa se aplica la lógica de negocio intermedia, consolidando costos, métricas financieras y prorrateos antes de alimentar el modelo dimensional (`marts`).

## Modelos Incluidos (2)

* `int_order_items_enriched`: Lógica a nivel línea de pedido (`order_item_id`). Consolida ventas brutas, descuentos, devoluciones aprobadas, costo de reposición (`replacement_cost`) y el prorrateo del costo de envío calculado sobre las unidades del pedido.
* `int_sales_enriched`: Agregación a nivel cabecera de pedido (`order_id`). Consolida métricas totales del pedido: diversidad de productos, unidades totales, ventas netas finales, COGS total, método de envío y ganancia neta (`net_profit`).

## Reglas de Negocio y Calidad
* **Materialización:** Vistas (`view`).
* **Prefijo:** `int_`.
* **Tratamiento de Cancelaciones:** Flag explícito (`is_cancelled`) que anula las ventas netas y costos para reflejar correctamente el impacto financiero real.
* **Calidad de Datos:** Validaciones de unicidad, no nulos e integridad referencial contra la capa `staging`.
