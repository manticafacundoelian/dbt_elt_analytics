# 📊 TechnoShop: Diagnóstico Comercial y Análisis PVM de Rentabilidad

## 🎯 Introducción y Metodología
Este proyecto investiga la causa raíz de la contracción de rentabilidad sufrida por TechnoShop en 2026 mediante un enfoque analítico de dos capas:

1. **Capa Comercial (Pasos 1 al 3B):** Utiliza la **Demanda Real en Checkout** (`is_cancelled = 0`) para aislar el comportamiento de compra directo del cliente, analizar la canasta ($AOV = UPT \times ASP$) y detectar cambios en la elección del catálogo sin sesgos logísticos.
2. **Capa Financiera y Devengada (Pasos 4 al 5B):** Utiliza la **Efectividad de Caja Real** (`order_status = 'delivered'`) basada en el **Margen Bruto Retenido Real** (`final_net_sales` y `final_item_cogs`). Esto garantiza que el modelo PVM (*Price-Volume-Mix*) y la evaluación de SKUs midan la ganancia bruta consolidada **post-devoluciones y post-notas de crédito**, eliminando "ganancias fantasma" de productos devueltos.

---
```text
========================================================================================
                      ARQUITECTURA DE INVESTIGACIÓN TECHNOSHOP 2026
========================================================================================

 🛒 CAPA COMERCIAL (Demanda Checkout | is_cancelled = 0)
 ├── Paso 1: Diagnóstico Macro YoY
 │    └── AOV caye -42.53% (Métrica responsable del quiebre de ingresos y ganancia)
 ├── Paso 2: Descomposición de la Canasta (AOV = UPT × ASP)
 │    └── Caída simétrica: UPT -24.00% | ASP -24.48%
 ├── Paso 3A: Descomposición del ASP
 │    └── El descuento no es el culpable (+3.18 pp); se eligió catálogo más barato (-21.92%)
 └── Paso 3B: Mix por Categoría
      └── Fuga de Share en TV/Video (-6.39 pp) y deflación en Computación (ASP -33.21%)

                                      │
                                      ▼ [Puente Analítico: De Checkout a Caja Real]
 💰 CAPA FINANCIERA (Devengado | order_status = 'delivered')
 ├── Paso 4: P&L y Fugas de Caja
 │    └── Compresión del Margen Neto (18.5% -> 10.4%) por Fletes, COGS y Devoluciones
 ├── Paso 5A: Descomposición PVM del Margen Bruto (Price-Volume-Mix)
 │    └── Caída de -$185.36M en MB. El Efecto Precio explica el 60.26% (-$111.70M)
 └── Paso 5B: Zoom a Nivel SKU (Top Destructores)
      └── 3 SKUs explican el 50.1% de la pérdida. TCL Monitor TV 19 pasa a MB Negativo
========================================================================================
```

## 📈 Paso 1: Diagnóstico Macro YoY (Aislamiento de la Variable Crítica)

### 🎯 Objetivo
Evaluar el desempeño consolidado de la compañía para identificar la métrica macro responsable del quiebre financiero entre 2025 y 2026.

### 📊 Resultados

| Métrica | 2024 | 2025 | 2026 | Var. YoY 25-26 (%) | Estado |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Clientes Activos** | 30 | 62 | 99 | **+59.68%** | 🟢 Crecimiento |
| **Pedidos Totales (Orders)** | 1,365 | 1,581 | 1,755 | **+11.01%** | 🟢 Crecimiento |
| **Ventas Netas Comerciales** | $1,290.47M | $1,633.93M | $1,042.36M | **-36.21%** | 🔴 Caída Crítica |
| **Ventas Netas Finales (Delivered)** | $1,253.31M | $1,580.25M | $972.10M | **-38.48%** | 🔴 Caída Crítica |
| **Ganancia Neta** | $297.56M | $292.82M | $100.80M | **-65.57%** | 🔴 Colapso |
| **Margen Neto (%)** | 23.74% | 18.53% | 10.37% | **-8.16 pp** | 🔴 Compresión |
| **Ticket Promedio (AOV)** | $945,397.31 | $1,033,477.34 | $593,935.88 | **-42.53%** | 🔴 Causa Raíz |

### 🔍 Hallazgos Clave
* **La "Trampa del Volumen":** La base de clientes creció un **+59.68%** y las transacciones un **+11.01%**, descartando un problema de adquisición de usuarios o de tráfico en la plataforma.
* **Quiebre de Facturación:** A pesar del mayor volumen operacional, las Ventas Netas cayeron un **-36.21%** y la Ganancia Neta colapsó un **-65.57%**.
* **Diagnóstico Macro:** La pérdida total de ingresos se explica enteramente por la compresión masiva del **Ticket Promedio (AOV)**, que cayó un **-42.53%** (de $1.03M a $593.9K por transacción).

🔗 [📂 Ver consulta SQL en GitHub](./queries/01_diagnostico_macro.sql)

---

### 🌉 Puente Analítico al Paso 2
Dado que confirmamos que el quiebre responde exclusivamente al desplome del **AOV (Ticket Promedio)**, el siguiente paso lógico es desarmar matemáticamente esta métrica ($AOV = UPT \times ASP$) para descubrir si el cliente está comprando menos cantidad de productos por pedido o si está eligiendo artículos de menor valor unitario.

---

## 🛒 Paso 2: Descomposición de la Canasta ($AOV = UPT \times ASP$)

### 🎯 Objetivo
Aislar matemáticamente los dos componentes de la canasta de compra:
1. **Efecto Volumen ($UPT$ - Unidades por Pedido):** Cantidad de ítems agregados al carrito.
2. **Efecto Precio ($ASP$ - Precio Promedio por Unidad):** Valor promedio de cada ítem vendido.

### 📊 Resultados

| Métrica | 2024 | 2025 | 2026 | Var. YoY 25-26 (%) | Diagnóstico |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Pedidos Totales** | 1,365 | 1,581 | 1,755 | **+11.01%** | Aumento de frecuencia |
| **Unidades Totales Vendidas** | 3,946 | 4,746 | 4,009 | **-15.53%** | Menos volumen físico |
| **Unidades por Pedido (UPT)** | 2.89 | 3.00 | 2.28 | **-24.00%** | **Efecto Volumen (-24.0%)** |
| **Precio Unitario Prom. (ASP)** | $327,031.76 | $344,274.69 | $260,004.36 | **-24.48%** | **Efecto Precio (-24.5%)** |
| **Ticket Promedio (AOV)** | $945,397.31 | $1,033,477.34 | $593,935.88 | **-42.53%** | **Impacto Combinado** |

### 🔍 Hallazgos Clave
* **Doble Impacto Simultáneo:** La caída del AOV (-42.53%) se debe a un deterioro equilibrado en ambos componentes de la canasta.
* **Contracción de Carrito (UPT):** Cayó un **-24.00%**. En 2025 los clientes llevaban en promedio 3 ítems por compra, mientras que en 2026 cayeron a 2.28 ítems.
* **Devaluación de la Unidad (ASP):** Cayó un **-24.48%**. Cada producto vendido ingresó $84,270 menos en promedio respecto al año anterior.

🔗 [📂 Ver consulta SQL en GitHub](./queries/02_descomposicion_canasta.sql)

---

### 🌉 Puente Analítico al Paso 3
Con la caída del volumen del carrito ($UPT$) confirmada, la investigación debe profundizar sobre la caída del **Precio Promedio Unitario ($ASP$)**. Necesitamos determinar si el $ASP$ se desplomó porque la empresa aplicó **descuentos y cupones agresivos** o porque los usuarios están comprando **productos de menor valor facial** dentro del catálogo.

---

## 🏷️ Paso 3A: Descomposición del ASP (¿Promociones Agresivas o Cambio de Selección?)

### 🎯 Objetivo
Determinar si el desplome del $ASP$ Neto (-24.48%) fue provocado por un **exceso de descuentos/cupones** aplicados sobre los productos o por una **elección de productos con menor Precio de Lista (ASP Bruto)** por parte de los usuarios.

### 📊 Resultados

| Métrica | 2024 | 2025 | 2026 | Var. YoY 25-26 | Diagnóstico |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Unidades Totales Vendidas** | 3,946 | 4,746 | 4,009 | **-15.53%** | Menor volumen total |
| **ASP Bruto (Precio Lista Prom.)** | $333,625.58 | $354,911.08 | $277,117.38 | **-21.92%** | **Fuga de valor inicial** |
| **Tasa de Descuento Prom. (%)** | 1.98% | 3.00% | 6.18% | **+3.18 pp** | Incremento marginal |
| **ASP Neto Comercial** | $327,031.76 | $344,274.69 | $260,004.36 | **-24.48%** | **Caída Total** |

### 🔍 Hallazgos Clave
* **El Descuento NO es el Culpable Principal:** Aunque la tasa de descuento creció de un 3.00% a un 6.18% (+3.18 puntos porcentuales), este ajuste explica una fracción menor de la pérdida.
* **Elección de Catálogo Devaluado:** El **ASP Bruto (Precio de Lista)** cayó un **-21.92%**. Esto demuestra que los clientes están armando sus carritos con productos intrínsecamente más baratos desde el origen.

🔗 [📂 Ver consulta SQL 3A en GitHub](./queries/03a_descomposicion_asp.sql)

---

## 📦 Paso 3B: Análisis de Mix por Categoría (Fuga de Share y Canibalización)

### 🎯 Objetivo
Analizar la distribución del volumen de ventas (*Share of Units*) y la evolución del $ASP$ por categoría de producto para identificar qué líneas de negocio perdieron participación y cuáles sufrieron erosión de precios.

### 📊 Resultados

| Categoría | Share Vol 2025 | Share Vol 2026 | Cambio Share | ASP Neto 2025 | ASP Neto 2026 | Var. ASP YoY | Tasa Desc 2025 | Tasa Desc 2026 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Hogar** | 21.07% | 25.72% | **+4.65 pp** | $109,885.04 | $113,491.22 | **+3.28%** | 3.05% | 7.16% |
| **Audio** | 14.90% | 23.02% | **+8.13 pp** | $221,365.50 | $225,924.77 | **+2.06%** | 2.93% | 7.03% |
| **Accesorios** | 25.75% | 20.68% | **-5.07 pp** | $79,855.86 | $82,822.81 | **+3.72%** | 2.92% | 6.75% |
| **Computación** | 16.16% | 17.71% | **+1.55 pp** | $316,964.95 | $211,716.15 | **-33.21% 🔴** | 3.02% | 5.92% |
| **TV y Video** | 16.67% | 10.28% | **-6.39 pp 🔴**| $1,071,104.75 | $1,022,922.01 | **-4.50%** | 2.97% | 5.72% |
| **Telefonía** | 5.46% | 2.59% | **-2.86 pp 🔴**| $693,426.22 | $734,586.64 | **+5.94%** | 3.17% | 4.76% |

### 🔍 Hallazgos Clave
* **Efecto "Mix Shift" (Fuga a Tickets Bajos):** Las categorías de alto ticket sufrieron un colapso en su participación sobre el total de unidades vendidas. *TV y Video* ($1.02M ASP) cayó **-6.39 pp** y *Telefonía* ($734K ASP) cayó **-2.86 pp**. Esas unidades migraron hacia *Audio* (**+8.13 pp**) y *Hogar* (**+4.65 pp**), cuyos valores promedios son sustancialmente más bajos (~$113K - $225K).
* **Deflación Severa en Computación:** La categoría *Computación* mantuvo un volumen de ventas estable (+1.55 pp de share), pero sufrió una caída catastrófica en su $ASP$ Neto del **-33.21%** (pasando de $316.9K a $211.7K). Esto evidencia una fuerte canibalización o guerra de precios en el segmento de equipos/periféricos.

🔗 [📂 Ver consulta SQL 3B en GitHub](./queries/03b_mix_categoria.sql)

---

### 🌉 Puente Analítico a la Rama de Rentabilidad Financiera (Pasos 4 y 5)
Hasta este punto, el análisis comercial confirmó que la pérdida de ingresos responde a carritos más pequeños ($UPT$) y a una migración de la demanda hacia categorías baratas ($Mix$). 

Sin embargo, **vender menos ingresos no siempre significa perder rentabilidad en la misma proporción**. Para entender el verdadero impacto en el bolsillo de la empresa, debemos cambiar de la Capa Comercial a la **Capa Financiera / Devengada (`order_status = 'delivered'`)** y aplicar la desarmaduría de **Margen Bruto mediante el Análisis PVM (*Price-Volume-Mix*)**.

---

## 💰 Paso 4: Estado de Resultados Devengado (P&L) y Análisis de Fugas de Caja

### 🎯 Objetivo
Evaluar el estado de resultados devengado (`order_status = 'delivered'`) para identificar cómo las pérdidas comerciales se traducen en erosión de la **Ganancia Neta Final**, aislando las tres principales "fugas" de caja: Devoluciones, Costos de Mercadería (COGS) y Logística (Shipping).

### 📊 Resultados

| Métrica P&L | 2024 | 2025 | 2026 | Var. YoY 25-26 (pp) | Impacto Financiero |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Ventas Netas Comerciales** | $1,290.47M | $1,633.93M | $999.11M | **-38.85%** | Caída de facturación |
| **(-) Devoluciones (Refunds)** | $37.16M | $53.67M | $70.26M | **+3.75 pp 🔴** | **Fuga 1:** Tasa subió de 3.28% a 7.03% |
| **(=) Ventas Netas Finales** | $1,253.31M | $1,580.25M | $928.86M | **-41.22%** | Caja retenida real |
| **(-) Costo Mercadería (COGS)** | $943.06M | $1,270.04M | $804.00M | **-36.69%** | **Fuga 2:** COGS representó 86.56% |
| **(=) Margen Bruto (%)** | **24.75%** | **19.63%** | **13.44%** | **-6.19 pp 🔴** | Compresión severa de margen |
| **(-) Costo de Envío (Shipping)** | $12.69M | $17.40M | $25.87M | **+1.69 pp 🔴** | **Fuga 3:** Flete subió de 1.10% a 2.79% |
| **(=) Ganancia Neta Real** | $297.56M | $292.82M | $98.99M | **-66.20%** | **Colapso del Bottom-Line** |
| **Margen Neto (%)** | **23.74%** | **18.53%** | **10.66%** | **-7.87 pp** | Pérdida total de eficiencia |

### 🔍 Hallazgos Clave
* **Colapso del Margen Neto (-7.87 pp):** La rentabilidad sobre la caja retenida cayó del 18.53% al 10.66%, provocando que la ganancia neta se redujera a un tercio de lo obtenido en 2025 ($98.99M vs $292.82M).
* **Fuga 1 — Explosión de Devoluciones (+3.75 pp):** La tasa de devolución más que se duplicó (pasó de 3.28% a 7.03%), erosionando $70.26M directamente de la caja depositada.
* **Fuga 2 — Erosión del Margen Bruto (-6.19 pp):** El costo de la mercadería vendida absorbió un porcentaje mucho mayor de la venta (el Margen Bruto se contrajo de 19.63% a 13.44%).
* **Fuga 3 — Ineficiencia Logística (+1.69 pp):** A pesar de vender menos unidades, el costo total de envíos subió de $17.40M a $25.87M (representando el 2.79% de las ventas netas finales).

🔗 [📂 Ver consulta SQL 04 en GitHub](./queries/04_pl_devengado_fugas.sql)

---

## 🔬 Paso 5A: Descomposición PVM del Margen Bruto (Price-Volume-Mix)

### 🎯 Objetivo
Explicar matemáticamente la caída de **-$185.36M** en el Margen Bruto mediante un modelo **PVM (Price-Volume-Mix)** por categoría, separando los efectos monetarios causados por variación de precios, cambios en costos de adquisición, contracción de volumen y distorsión de mix.  

> 📌 **Nota Metodológica sobre el PVM:** El modelo se ejecuta utilizando `final_net_sales` y `final_item_cogs`. Por lo tanto, el Precio Promedio ($P$) y el Margen Bruto ($MB$) analizados corresponden al **Margen Bruto Retenido Efectivo**, absorbiendo el impacto de las devoluciones y notas de crédito de cada categoría.

### 📊 Resultados (Variación 2025 vs 2026)

| Categoría | Margen Bruto 2025 | Margen Bruto 2026 | Delta MB Total | Contrib. a la Caída (%) | Efecto Precio | Efecto Costo | Efecto Volumen | Efecto Mix |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **TV y Video** | $142.27M | $41.39M | **-$100.88M** | **54.43% 🔴** | -$36.07M | +$5.15M | -$69.97M | -$40.95M |
| **Computación** | $61.49M | $29.16M | **-$32.34M** | **17.45%** | -$73.75M 🔴 | +$47.59M 🟢 | -$6.17M | +$6.37M |
| **Telefonía** | $31.77M | $9.70M | **-$22.07M** | **11.90%** | +$2.12M | -$4.93M | -$19.26M | -$12.78M |
| **Accesorios** | $17.98M | $6.66M | **-$11.32M** | **6.11%** | +$1.30M | -$6.14M | -$6.47M | -$2.81M |
| **Audio** | $32.32M | $22.49M | **-$9.84M** | **5.31%** | -$6.16M | -$10.76M | +$7.09M | +$13.68M |
| **Hogar** | $24.38M | $15.46M | **-$8.92M** | **4.81%** | +$0.85M | -$8.31M | -$1.46M | +$3.51M |
| **TOTAL EMPRESA** | **$310.22M** | **$124.86M** | **-$185.36M** | **100.00%** | **-$111.70M (60.26%)** | **+$22.59M (-12.19%)** | **-$63.27M (34.14%)** | **-$32.98M (17.79%)** |

### 🔍 Hallazgos Clave
* **El Efecto Precio explica el 60.26% de la destrucción (-$111.70M):** La incapacidad de sostener los precios de venta netos fue la mayor fuerza destructora de valor a nivel global.
* **TV y Video es el Epicentro de la Pérdida (54.43% del total):** Explicó **-$100.88M** del margen perdido. Las causas principales fueron la contracción masiva de volumen (**-$69.97M**) y un mix desfavorable (**-$40.95M**).
* **Computación y la Trampa del Descuento:** Tuvo un **Efecto Precio devastador (-$73.75M)** que fue parcialmente neutralizado por un **Efecto Costo positivo (+$47.59M)** gracias a menores costos de insumos. Sin embargo, la guerra de precios redujo su margen a la mitad.

🔗 [📂 Ver consulta SQL 05 en GitHub](./queries/05_descomposicion_pvm_categoria.sql)

---

## 🎯 Paso 5B: Zoom a Nivel SKU — Principales Destructores de Margen

### 🎯 Objetivo
Aislar los productos específicos dentro de las dos categorías más afectadas (*TV y Video* y *Computación*) que concentraron la mayor pérdida monetaria de Margen Bruto.

### 📊 Resultados (Top 10 SKUs Destructores de Margen)

| Categoría | ID | Producto / SKU | Unid. 2025 | Unid. 2026 | Margen 2025 | Margen 2026 | Delta MB Total | Ef. Precio | Ef. Costo | Ef. Volumen |
| :--- | :---: | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **TV y Video** | 21 | TCL Monitor TV 21 | 295 | 136 | $64.91M | $20.12M | **-$44.79M** | -$3.67M | -$6.13M | -$34.98M |
| **TV y Video** | 25 | TCL Chromecast 25 | 178 | 91 | $42.34M | $15.47M | **-$26.87M** | -$8.66M | +$2.48M | -$20.70M |
| **Computación** | 2 | Acer Memoria RAM 2 | 219 | 56 | $27.65M | $6.46M | **-$21.19M** | -$0.19M | -$0.42M | -$20.58M |
| **TV y Video** | 19 | TCL Monitor TV 19 | 84 | 39 | $12.68M | -$1.55M | **-$14.23M** | -$4.18M | -$3.26M | -$6.79M |
| **Computación** | 1 | Lenovo Mouse 1 | 329 | 108 | $16.85M | $4.15M | **-$12.70M** | -$0.36M | -$1.02M | -$11.32M |
| **TV y Video** | 20 | Samsung Smart TV 20 | 123 | 36 | $10.95M | $1.02M | **-$9.93M** | +$1.33M | -$3.52M | -$7.74M |
| **Computación** | 5 | ASUS Notebook 5 | 157 | 82 | $10.96M | $3.80M | **-$7.16M** | -$0.80M | -$1.13M | -$5.23M |
| **TV y Video** | 23 | Samsung Monitor TV 23 | 97 | 91 | $6.42M | $3.58M | **-$2.84M** | -$0.04M | -$2.40M | -$0.40M |
| **TV y Video** | 24 | Samsung Chromecast 24 | 11 | 6 | $3.82M | $1.73M | **-$2.10M** | +$0.25M | -$0.61M | -$1.74M |
| **Computación** | 9 | HP Teclado 9 | 42 | 16 | $2.50M | $0.73M | **-$1.77M** | -$0.18M | -$0.04M | -$1.55M |

### 🔍 Hallazgos Clave
* **Alta Concentración del Daño:** Tan solo 3 productos (*TCL Monitor TV 21*, *TCL Chromecast 25* y *Acer Memoria RAM 2*) explican más de **-$92.85M** de la pérdida total de margen bruto de la empresa (un 50.1% de la caída global).
* **Caso Crítico — TCL Monitor TV 19 (Margen Negativo):** Este producto no solo destruyó **-$14.23M** de margen, sino que en 2026 pasó a terreno negativo (-$1.55M), lo que significa que el precio neto de venta no cubrió el costo de adquisición devengado.

🔗 [📂 Ver consulta SQL 06 en GitHub](./queries/06_top_skus_destruccion_margen.sql)

---

## 🛠️ Limitaciones Técnicas y Próximos Pasos

### ⚠️ Limitación Metodológica: Margen Bruto vs. Margen Neto a Nivel SKU
* **Prorrateo de Costos Indirectos:** En el modelo de datos de TechnoShop, los costos logísticos (fletes/shipping) y las comisiones bancarias existen en la entidad de la **Orden** (`fact_orders`), no a nivel de ítem individual (`fact_order_items`).
* **Criterio de Evaluación de Producto:** Asignar el flete de un paquete con múltiples productos a un SKU individual requeriría reglas de prorrateo arbitrarias (por peso o valor). Por este motivo, siguiendo las mejores prácticas de *Category Management*, la rentabilidad individual de los productos se evalúa mediante el **Margen Bruto Directo Retenido**, dejando la evaluación del **Margen Neto Final** para la escala consolidada de la empresa y la orden.

### 💡 Recomendaciones de Negocio (Acciones Sugeridas)
1. **Descontinuación / Reprueba del TCL Monitor TV 19:** Retirar del catálogo o renegociar de inmediato el costo de adquisición (COGS) del SKU 19, dado que opera en **Margen Bruto Negativo** (-$1.55M), destruyendo caja en cada venta.
2. **Revisión de Precios en Computación:** Frenar la estrategia de descuentos agresivos en periféricos y notebooks. El efecto precio destruyó **-$73.75M** en la categoría, demostrando que la rebaja de precios no generó un volumen compensatorio suficiente.
3. **Control de Calidad en TV y Video:** Investigar el motivo detrás de la explosión de la tasa de devoluciones (que subió del 3.28% al 7.03% global), focalizada en la línea de televisores y monitores TCL.
