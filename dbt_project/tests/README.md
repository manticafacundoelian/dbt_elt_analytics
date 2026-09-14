# Pruebas Singulares (Singular Tests)

En esta carpeta se alojan las pruebas de datos personalizadas en SQL. Cada consulta retorna **0 filas** si la prueba pasa exitosamente; si retorna filas, la prueba falla señalando los registros en infracción.

## Tests Incluidos

### Reglas Comerciales y Financieras
* `assert_payments_match_net_sales.sql`: Controla que los pagos aprobados coincidan con la venta neta del pedido.
* `assert_returned_quantity_not_exceeding_ordered.sql`: Asegura que las unidades devueltas no superen las compradas.
* `assert_returns_after_delivery.sql`: Garantiza que una devolución ocurra únicamente después de la fecha de entrega.
* `assert_cancelled_orders_have_zero_net_sales.sql`: Confirma que los pedidos cancelados tengan venta neta igual a 0.

### Integridad Operativa y Logística
* `assert_shipments_dates_and_cost.sql`: Valida que los costos de envío sean positivos y que las fechas tengan coherencia cronológica (orden <= despacho <= entrega).

### Validaciones de Rango en Staging (`stg_*`)
* `assert_stg_order_items_valid_ranges.sql`: Precios, cantidades, costos de reposición y % de descuento dentro de límites válidos.
* `assert_stg_payments_amount_non_negative.sql`: Montos de pago no negativos.
* `assert_stg_products_valid_ranges.sql`: Precios y costos de catálogo mayores a 0.
* `assert_stg_returns_valid_ranges.sql`: Cantidades positivas y reembolsos coherentes según el estado de la devolución.
