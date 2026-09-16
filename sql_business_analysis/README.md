# 🔎 Investigaciones y Consultas SQL (Data Warehouse)

## Contexto

# 📊 Investigaciones SQL & Deep Dives de Negocio

Este módulo contiene la capa de diagnóstico analítico mediante SQL. Forma parte de un proyecto analítico **End-to-End de E-Commerce** estructurado de la siguiente manera:

*   **[🏗️ dbt_core_pipeline](../dbt_core_pipeline/):** Transformación, modelado físico y testing de datos sobre **DuckDB**.
*   **[📂 sql_business_analysis](../sql_business_analysis/):** Investigaciones avanzadas (RFM, Cohortes y Análisis PVM) *(Estás aquí)*.
*   **[🤖 scripts](../scripts/):** Automatización con **Python** para exportar los marts a formato Parquet.
*   **[📈 power_bi_analytics](../power_bi_analytics/):** Modelado estrella (DAX) y reporte ejecutivo en **Power BI**.

👉 Para comprender la arquitectura completa del ecosistema, los requerimientos de software y cómo replicarlo de forma local, visita el **[README Principal del Proyecto](../README.md)**.

---




---

# 🎯 Objetivo de la investigación

La investigación busca responder progresivamente:

> **¿Cómo evolucionó el negocio entre 2024 y 2026, qué factores explican el deterioro observado en 2026 y dónde se concentra el impacto sobre ventas y rentabilidad?**

Para evitar mezclar universos diferentes, las comparaciones anuales utilizan como universo principal los pedidos con:

```sql
order_status = 'delivered'
```

Esto permite comparar períodos cerrados bajo una misma condición operacional.

---

# 🧭 Enfoque analítico

La investigación se divide en dos ramas:

```text
                         INVESTIGACIÓN DE NEGOCIO
                                  │
                 ┌────────────────┴────────────────┐
                 │                                 │
          RAMA COMERCIAL                    RAMA RENTABILIDAD
                 │                                 │
        ¿Qué pasó con las ventas?          ¿Qué pasó con la ganancia?
                 │                                 │
        Pedidos × Ticket                    Ventas finales
                 │                                 │
          Ticket = UPT × ASP                - Devoluciones
                 │                          - COGS
          Precio + Descuentos               - Logística
                 │                          = Ganancia
             Mix / Categorías                    │
                                                 PVM
```

La lógica de investigación sigue una progresión:

```text
Medición
   ↓
Comparación
   ↓
Descomposición
   ↓
Profundización
   ↓
Hallazgo
   ↓
Nueva pregunta
```

No se busca explicar causalidad con una sola consulta. Cada etapa reduce el espacio de posibles explicaciones.

---

# 📊 Rama comercial

## Q1 — ¿Cómo evolucionó el negocio?

### Pregunta de negocio

> **¿Cómo evolucionaron el volumen, las ventas, las devoluciones y la rentabilidad entre 2024 y 2026?**

La primera consulta funciona como diagnóstico macro. Su objetivo es identificar **qué cambió**, no explicar todavía por qué cambió.

### Métricas principales

* Pedidos
* Ventas brutas
* Descuentos
* Ventas netas comerciales
* Devoluciones
* Tasa de devolución
* Ventas netas finales
* Ganancia neta
* Margen neto
* Ticket promedio comercial

### Resultado

| Métrica                  |       2024 |       2025 |     YoY 2025 |     2026 |     YoY 2026 |
| ------------------------ | ---------: | ---------: | -----------: | -------: | -----------: |
| Pedidos                  |      1.365 |      1.581 |  **+15,82%** |    1.649 |   **+4,30%** |
| Ventas netas comerciales | $1.290,5 M | $1.633,9 M |  **+26,62%** | $999,1 M |  **-38,85%** |
| Devoluciones             |    $37,2 M |    $53,7 M |  **+44,45%** |  $70,3 M |  **+30,90%** |
| Tasa de devolución       |      2,88% |      3,28% | **+0,40 pp** |    7,03% | **+3,75 pp** |
| Ventas netas finales     | $1.253,3 M | $1.580,3 M |  **+26,09%** | $928,9 M |  **-41,22%** |
| Ganancia neta            |   $297,6 M |   $292,8 M |   **-1,59%** |  $99,0 M |  **-66,20%** |
| Margen neto              |     23,74% |     18,53% | **-5,21 pp** |   10,66% | **-7,87 pp** |
| Ticket comercial         |   $945.397 | $1.033.477 |   **+9,32%** | $605.891 |  **-41,37%** |

### Lectura

**2025**

El negocio presenta crecimiento comercial:

* Los pedidos aumentan **15,82%**.
* Las ventas netas comerciales aumentan **26,62%**.
* El ticket comercial aumenta **9,32%**.

Sin embargo, ese crecimiento no se traduce en una mayor ganancia:

* La ganancia neta cae **1,59%**.
* El margen neto cae **5,21 puntos porcentuales**.
* Las devoluciones aumentan **44,45%**, por encima del crecimiento de las ventas.
* La tasa de devolución pasa de **2,88% a 3,28%**.

**2026**

El deterioro es considerablemente mayor:

* Los pedidos todavía crecen **4,30%**.
* Las ventas netas comerciales caen **38,85%**.
* El ticket comercial cae **41,37%**.
* Las devoluciones aumentan otro **30,90%**.
* La tasa de devolución alcanza **7,03%**.
* La ganancia neta cae **66,20%**.
* El margen neto cae hasta **10,66%**.

### Hallazgo

> **El deterioro de 2026 no se explica por una caída del número de pedidos: los pedidos continúan creciendo. La principal caída comercial se encuentra en el valor generado por cada pedido, mientras que el aumento de las devoluciones y la reducción del margen profundizan el impacto sobre la rentabilidad.**

### Siguiente pregunta

> **¿Por qué cayó el valor promedio de cada pedido?**

---

# Q2 — ¿Por qué cayó el ticket comercial?

### Pregunta de negocio

El ticket comercial puede descomponerse como:

```text
Ticket Comercial = UPT × ASP
```

donde:

* **UPT (Units Per Transaction)** = unidades por pedido
* **ASP (Average Selling Price)** = valor comercial promedio por unidad

La pregunta pasa a ser:

> **¿La caída del ticket se debe a que los clientes compran menos unidades, a un menor valor por unidad, o a ambos factores?**

### Resultado

| Métrica          |     2024 |       2025 |   YoY 2025 |     2026 |    YoY 2026 |
| ---------------- | -------: | ---------: | ---------: | -------: | ----------: |
| Pedidos          |    1.365 |      1.581 |    +15,82% |    1.649 |      +4,30% |
| Unidades         |    3.946 |      4.746 |          — |    3.778 |           — |
| UPT              |     2,89 |       3,00 | **+3,81%** |     2,29 | **-23,67%** |
| ASP comercial    | $327.032 |   $344.275 | **+5,27%** | $264.456 | **-23,18%** |
| Ticket comercial | $945.397 | $1.033.477 | **+9,32%** | $605.891 | **-41,37%** |

### Lectura

En 2025 ambos componentes evolucionan positivamente:

* UPT: **+3,81%**
* ASP: **+5,27%**
* Ticket: **+9,32%**

En 2026 ambos componentes se deterioran:

* UPT: **-23,67%**
* ASP: **-23,18%**
* Ticket: **-41,37%**

Un dato particularmente relevante es la relación entre pedidos y unidades.

En 2025 hubo **1.581 pedidos y 4.746 unidades**.

En 2026 hubo **1.649 pedidos**, pero solamente **3.778 unidades**.

Por lo tanto, el crecimiento del número de pedidos no representa un crecimiento equivalente en unidades vendidas.

### Hallazgo

> **La caída del ticket comercial en 2026 tiene dos componentes: menor profundidad de compra (UPT -23,67%) y menor valor comercial promedio por unidad (ASP -23,18%).**

La investigación comercial se divide entonces en dos caminos:

```text
Ticket Comercial ↓
       │
       ├── UPT ↓ 23,67%
       │       └── ¿Por qué se compran menos unidades?
       │
       └── ASP ↓ 23,18%
               └── ¿Por qué cayó el valor por unidad?
```

La siguiente investigación se concentra en el ASP.

---

# Q3 — ¿Por qué cayó el ASP?

El ASP agregado puede modificarse por diferentes mecanismos:

```text
ASP ↓
 │
 ├── Precio bruto ↓
 │
 ├── Descuentos ↑
 │
 └── Cambio en el mix de productos/categorías
```

Por eso la investigación se divide en:

* **Q3.1 — Precio bruto vs. descuentos**
* **Q3.2 — Mix de categorías**

---

# Q3.1 — ¿La caída del ASP viene de precio o de descuentos?

### Pregunta de negocio

> **¿La caída del ASP comercial se explica por una reducción del precio bruto, por una mayor presión de descuentos, o por ambos factores?**

### Resultado

| Métrica            |     2024 |     2025 |     YoY 2025 |     2026 |     YoY 2026 |
| ------------------ | -------: | -------: | -----------: | -------: | -----------: |
| ASP bruto          | $333.626 | $354.911 |   **+6,38%** | $281.632 |  **-20,65%** |
| Tasa de descuento  |    1,98% |    3,00% | **+1,02 pp** |    6,10% | **+3,10 pp** |
| ASP neto comercial | $327.032 | $344.275 |   **+5,27%** | $264.456 |  **-23,18%** |

### Lectura

En 2026 el **ASP bruto cae 20,65%**.

Esto indica que el menor ASP neto no se debe únicamente a descuentos: también existe una reducción del valor bruto promedio por unidad.

Al mismo tiempo, aumenta considerablemente la tasa de descuento:

```text
2025 → 3,00%
2026 → 6,10%
Cambio → +3,10 pp
```

Por lo tanto, los descuentos también profundizan la reducción del valor comercial obtenido por unidad.

La evolución queda:

```text
ASP bruto
$354.911 → $281.632
      ↓ -20,65%

Descuentos
3,00% → 6,10%
      ↑ +3,10 pp

ASP neto
$344.275 → $264.456
      ↓ -23,18%
```

### Hallazgo

> **La caída del ASP comercial en 2026 combina una reducción del ASP bruto (-20,65%) con un aumento de la tasa de descuento (+3,10 pp), llevando el ASP neto a una caída del 23,18%.**

Sin embargo, el ASP bruto agregado todavía puede estar afectado por la composición de las categorías vendidas.

### Siguiente pregunta

> **¿Cuánto del deterioro del ASP está relacionado con un cambio en el mix de categorías y cuánto con cambios dentro de las propias categorías?**

---

# Q3.2 — ¿El ASP cayó por precio o por mix?

### Pregunta de negocio

> **¿El cambio en la composición de las unidades vendidas contribuyó a reducir el ASP agregado?**

Para responderla se analiza, para cada categoría:

* participación sobre las unidades totales;
* ASP neto comercial;
* evolución del ASP;
* tasa de descuento.

### Resultado 2025 → 2026

| Categoría   | Mix 2025 | Mix 2026 |        Δ Mix |   ASP 2025 |   ASP 2026 |       Δ ASP | Δ Descuento |
| ----------- | -------: | -------: | -----------: | ---------: | ---------: | ----------: | ----------: |
| Hogar       |   21,07% |   24,88% | **+3,81 pp** |   $109.885 |   $112.885 |  **+2,73%** |    +4,00 pp |
| Audio       |   14,90% |   22,82% | **+7,92 pp** |   $221.366 |   $223.283 |  **+0,87%** |    +4,05 pp |
| Accesorios  |   25,75% |   20,70% | **-5,05 pp** |    $79.856 |    $83.864 |  **+5,02%** |    +3,73 pp |
| Computación |   16,16% |   18,26% | **+2,10 pp** |   $316.965 |   $213.195 | **-32,74%** |    +2,82 pp |
| TV y Video  |   16,67% |   10,64% | **-6,03 pp** | $1.071.105 | $1.027.052 |  **-4,11%** |    +2,73 pp |
| Telefonía   |    5,46% |    2,70% | **-2,76 pp** |   $693.426 |   $735.022 |  **+6,00%** |    +1,45 pp |

### Lectura

Se observa un cambio importante en la composición de las unidades vendidas.

**Audio** aumenta su participación en **7,92 pp**, mientras que **TV y Video**, una categoría de ASP superior al millón de pesos, reduce su participación en **6,03 pp**.

También aumenta la participación de:

* Hogar: **+3,81 pp**
* Computación: **+2,10 pp**

Mientras disminuyen:

* Accesorios: **-5,05 pp**
* Telefonía: **-2,76 pp**

Esto es compatible con la existencia de un **efecto mix** sobre el ASP agregado.

Sin embargo, los datos muestran que el cambio de mix no es la única explicación.

El caso más evidente es **Computación**:

```text
Participación:
16,16% → 18,26%
         +2,10 pp

ASP:
$316.965 → $213.195
           -32,74%
```

Es decir, la categoría aumenta su peso dentro de las unidades vendidas, pero al mismo tiempo reduce fuertemente su ASP.

Además, la tasa de descuento aumenta en **todas las categorías analizadas**.

### Hallazgo

> **La caída del ASP comercial en 2026 responde a una combinación de factores. Se observa un cambio de mix hacia categorías de menor ASP relativo, junto con reducciones del ASP dentro de algunas categorías importantes y un aumento generalizado de la presión de descuentos.**

El caso de Computación muestra especialmente que **no sería suficiente atribuir el deterioro únicamente al mix**.

### Cierre de la rama comercial

Hasta este punto, la investigación permite reconstruir el deterioro comercial:

```text
Ventas netas comerciales ↓ 38,85%
              │
              ↓
      Ticket comercial ↓ 41,37%
              │
       ┌──────┴──────┐
       ↓             ↓
     UPT ↓          ASP ↓
   -23,67%        -23,18%
                     │
             ┌───────┼────────┐
             ↓       ↓        ↓
        ASP bruto  Descuentos  Mix
          ↓20,65%    +3,10 pp   cambio
```

La rama comercial muestra que la caída de ventas de 2026 no proviene principalmente de una reducción del número de pedidos, sino de una **menor cantidad de unidades por pedido y un menor valor comercial por unidad**.

---

# 💰 Rama de rentabilidad

La rama comercial responde:

> **¿Por qué cayó el nivel de ventas?**

Pero Q1 muestra un fenómeno adicional:

> **La ganancia neta cae 66,20%, mientras las ventas netas comerciales caen 38,85%.**

Por lo tanto, la siguiente pregunta es diferente.

## Q4 — ¿Por qué la rentabilidad se deterioró más que las ventas?

La investigación de rentabilidad parte de:

```text
Ventas netas comerciales
          │
          ├── Devoluciones
          ↓
Ventas netas finales
          │
          ├── COGS
          ├── Logística
          ↓
Ganancia neta
```

Esta rama utilizará las métricas finales del modelo, incorporando devoluciones, costo de mercadería y logística.

---

## Q4.1 — Evolución de la rentabilidad

### Pregunta de negocio

> **¿Qué componentes explican la caída del margen y de la ganancia neta entre 2025 y 2026?**

Se analizarán:

* Ventas netas comerciales
* Devoluciones
* Tasa de devolución
* Ventas netas finales
* COGS
* Margen bruto
* Costos logísticos
* Ganancia neta
* Margen neto

### Siguiente etapa

La respuesta permitirá determinar si la erosión de rentabilidad está asociada principalmente a:

```text
Ventas finales ↓
       │
       ├── Devoluciones ↑
       │
       ├── COGS / ventas ↑
       │
       └── Logística / ventas ↑
```

---

# Q4.2 — PVM: Precio, Volumen, Mix y Costos

Una vez identificados los principales movimientos de rentabilidad, se profundizará en la variación del margen mediante una descomposición **PVM**.

El objetivo será separar el cambio de resultado en componentes asociados a:

* **Precio**
* **Volumen**
* **Mix**
* **Costo**

La descomposición permitirá pasar de:

> "La ganancia cayó"

a una explicación más precisa sobre **qué movimientos comerciales y de costos explican esa variación**.

---

# 🧠 Resumen de la investigación

| Etapa    | Pregunta                                 | Resultado principal                                                                        |
| -------- | ---------------------------------------- | ------------------------------------------------------------------------------------------ |
| **Q1**   | ¿Cómo evolucionó el negocio?             | Pedidos +4,30%, ventas -38,85%, ganancia -66,20%, margen -7,87 pp en 2026                  |
| **Q2**   | ¿Por qué cayó el ticket?                 | UPT -23,67% y ASP -23,18%                                                                  |
| **Q3.1** | ¿Por qué cayó el ASP?                    | ASP bruto -20,65% y descuentos +3,10 pp                                                    |
| **Q3.2** | ¿Hay efecto mix?                         | Sí se observa un cambio relevante de mix, pero también cambios de ASP dentro de categorías |
| **Q4.1** | ¿Por qué cayó la rentabilidad?           | Pendiente: devoluciones, COGS y logística                                                  |
| **Q4.2** | ¿Qué explica la variación del resultado? | Pendiente: descomposición PVM                                                              |

---

# 📌 Principios de medición

La investigación mantiene distintas definiciones de ventas según la pregunta de negocio.

### Ventas netas comerciales

```text
net_sales
```

Representan las ventas después de descuentos pero **antes de devoluciones**.

Se utilizan principalmente para analizar:

* ventas comerciales;
* ticket;
* UPT;
* ASP;
* precio;
* descuentos;
* mix.

### Ventas netas finales

```text
final_net_sales
```

Representan las ventas después de considerar las devoluciones aprobadas.

Se utilizan en el análisis de:

* resultado final;
* rentabilidad;
* margen;
* impacto de devoluciones.

### Ganancia neta

```text
net_profit
```

Representa el resultado después de considerar las ventas finales, COGS y costos logísticos definidos en el modelo.

### Universo analítico

Las comparaciones anuales principales utilizan:

```sql
WHERE order_status = 'delivered'
```

Esto permite trabajar con un universo comparable entre años y evitar mezclar pedidos que todavía se encuentran en estados operativos diferentes.

---

# 🔬 Metodología

La investigación sigue un enfoque de **Business Analytics** basado en descomposición progresiva.

### 1. Medir

Primero se establece qué ocurrió mediante KPIs agregados.

### 2. Comparar

Se calculan variaciones interanuales para identificar cambios relevantes.

### 3. Descomponer

Los KPIs se separan en sus componentes:

```text
Ventas = Pedidos × Ticket

Ticket = UPT × ASP
```

### 4. Profundizar

Los componentes se investigan mediante:

```text
ASP
 ├── Precio bruto
 ├── Descuentos
 └── Mix

Rentabilidad
 ├── Devoluciones
 ├── COGS
 ├── Logística
 └── PVM
```

### 5. Encontrar

Cada consulta debe terminar en un hallazgo respaldado por los datos y generar la siguiente pregunta de investigación.

---

# 🎯 Objetivo final

La investigación busca transformar una observación general como:

> **"El negocio empeoró en 2026."**

en una explicación progresivamente más precisa:

> **"Las ventas disminuyeron a pesar de que los pedidos continuaron creciendo porque cayó fuertemente el valor generado por pedido. Esta caída se explica por una menor cantidad de unidades por pedido y un menor ASP, asociado a una combinación de menor ASP bruto, mayor presión de descuentos y cambios en el mix de categorías. La siguiente etapa busca determinar por qué la rentabilidad se deterioró todavía más que las ventas."**

El objetivo final es construir un análisis que no se limite a describir indicadores, sino que permita **explicar los movimientos relevantes del negocio utilizando evidencia cuantitativa y una cadena de investigación reproducible en SQL**.

















# Investigación SQL de Negocio

## Contexto

Este análisis forma parte de un proyecto de **ELT Analytics para un ecommerce**, construido sobre una arquitectura moderna con **DuckDB + dbt**, donde los datos operacionales son transformados y modelados para su posterior análisis en SQL y Power BI.

El objetivo de esta etapa no es simplemente obtener métricas, sino **investigar la evolución del negocio y explicar, a partir de los datos, qué factores están detrás de los principales cambios observados**.

La investigación toma como período de análisis **2024–2026** y utiliza como universo principal los pedidos con estado `delivered`, permitiendo comparar períodos bajo una misma condición de negocio: operaciones efectivamente completadas.

---

## Objetivo de la investigación

La investigación parte de una pregunta general:

> **¿Cómo evolucionó el desempeño del ecommerce y qué factores explican los cambios en ventas y rentabilidad?**

Para responderla, el análisis se divide en dos ramas:

* **Rama Comercial:** investiga la evolución de las ventas generadas por el negocio y busca explicar los cambios en el volumen monetario.
* **Rama de Rentabilidad:** analiza qué ocurrió entre las ventas generadas y el beneficio finalmente obtenido.

Esta separación permite evitar mezclar fenómenos comerciales con fenómenos posteriores a la venta, como devoluciones, costos de mercadería o logística.

---

## Enfoque analítico

La investigación sigue una lógica **de lo general a lo particular**.

Primero se construye una visión macro de la evolución del negocio. A partir de los cambios observados, se abren distintas líneas de investigación para identificar sus posibles causas.

```text
                    EVOLUCIÓN DEL NEGOCIO
                            │
                            ▼
                    Q1 · VISIÓN MACRO
                            │
             ¿Qué está cambiando y dónde?
                            │
             ┌──────────────┴──────────────┐
             │                             │
             ▼                             ▼
      RAMA COMERCIAL                RAMA RENTABILIDAD
             │                             │
             ▼                             ▼
      Ventas comerciales             Ventas finales
             │                             │
       Pedidos × Ticket              Devoluciones
             │                             │
          ┌──┴──┐                    COGS / Logística
          │     │                         │
         UPT   ASP                       PVM
          │     │                         │
          │  Precio + Mix                 ▼
          │     │                     Margen / Profit
          ▼     ▼
      Comportamiento
       comercial
```

---

## Rama Comercial

La primera rama busca explicar la evolución de las **ventas netas comerciales**, entendidas como las ventas posteriores a descuentos pero anteriores a devoluciones.

La investigación parte de la identidad:

```text
Ventas Netas Comerciales
        =
Pedidos × Ticket Comercial
```

Por lo tanto, una variación en las ventas puede explicarse inicialmente mediante:

* evolución de la cantidad de pedidos;
* evolución del ticket promedio.

A su vez, el ticket se descompone en:

```text
Ticket Comercial
        =
Unidades por Pedido (UPT)
        ×
Precio Promedio por Unidad (ASP)
```

Esto permite profundizar progresivamente:

1. **¿Cambió la cantidad de pedidos?**
2. **¿Cambió el ticket promedio?**
3. **¿Los clientes están comprando más o menos unidades por pedido?**
4. **¿Cambió el valor promedio de cada unidad vendida?**
5. **¿La caída del ASP está relacionada con precios, descuentos o cambios en el mix de productos?**

### Investigaciones

* **Q2 — Descomposición del Ticket:** Pedidos, UPT, ASP y Ticket Comercial.
* **Q3.1 — Evolución del ASP:** precio bruto, descuentos y ASP neto comercial.
* **Q3.2 — Precio vs. Mix:** evolución del ASP y participación de las categorías para identificar cambios en la composición de las ventas.

---

## Rama de Rentabilidad

La segunda rama cambia la perspectiva y analiza la transformación de las ventas comerciales en resultado económico.

En esta etapa sí se incorporan las **devoluciones**, ya que representan una pérdida posterior a la generación de la venta.

La lógica es:

```text
Ventas Netas Comerciales
          │
          ├── Devoluciones
          │
          ▼
Ventas Netas Finales
          │
          ├── Costo de Mercadería
          ├── Logística
          │
          ▼
Ganancia Neta
```

Las preguntas principales son:

* ¿Qué proporción de las ventas comerciales se pierde por devoluciones?
* ¿Cómo evolucionó el costo de mercadería respecto de las ventas?
* ¿Cómo evolucionaron los costos logísticos?
* ¿Por qué se deterioró el margen?
* ¿La erosión del margen está relacionada con precio, costo, volumen o mix?

Esta última pregunta conduce al análisis **PVM (Price–Volume–Mix)**, utilizado para descomponer el cambio en el margen bruto entre distintos efectos económicos.

### Investigaciones

* **Q4.1 — Evolución de la Rentabilidad:** devoluciones, ventas finales, COGS, logística, ganancia y márgenes.
* **Q4.2 — Análisis PVM:** descomposición del cambio en el margen bruto entre efectos de precio, costo, volumen y mix.

---

## Principios de medición

Para mantener consistencia analítica, cada métrica se calcula según la pregunta que intenta responder.

### Ventas comerciales

`net_sales`

Representan las ventas después de descuentos y antes de devoluciones.

Se utilizan principalmente en la **rama comercial**.

### Ventas finales

`final_net_sales`

Representan las ventas comerciales después de descontar las devoluciones aprobadas.

Se utilizan principalmente en la **rama de rentabilidad**.

### Ganancia neta

`net_profit`

Representa el resultado después de ventas finales, costo de mercadería y costos logísticos según las reglas definidas en el modelo analítico.

### Universo de análisis

Las investigaciones comparativas utilizan:

```sql
WHERE order_status = 'delivered'
```

Esto permite trabajar con pedidos efectivamente completados y evitar mezclar en la misma evolución anual operaciones todavía en proceso.

---

## Metodología

Cada consulta sigue una estructura de investigación progresiva:

**1. Medición → 2. Comparación → 3. Descomposición → 4. Profundización → 5. Hallazgo**

No se parte de una conclusión predeterminada. Las consultas se utilizan para identificar dónde se producen los cambios y luego profundizar en aquellos indicadores que muestran variaciones relevantes.

Las comparaciones interanuales utilizan principalmente variaciones **YoY (%)** y, cuando se trata de tasas o márgenes, **puntos porcentuales (pp)**.

---

## Estructura de la investigación

| Consulta | Pregunta                             | Nivel de análisis  |
| -------- | ------------------------------------ | ------------------ |
| **Q1**   | ¿Cómo evolucionó el negocio?         | Macro              |
| **Q2**   | ¿Por qué cambió el ticket comercial? | Comercial          |
| **Q3.1** | ¿Por qué cambió el ASP?              | Precio / Descuento |
| **Q3.2** | ¿Precio o cambio de mix?             | Categoría          |
| **Q4.1** | ¿Dónde se deterioró la rentabilidad? | Rentabilidad       |
| **Q4.2** | ¿Qué explica el cambio del margen?   | PVM                |

---

## De las métricas a los hallazgos

Cada consulta será acompañada por:

* **Pregunta de negocio**
* **Consulta SQL**
* **Resultado**
* **Interpretación**
* **Hallazgo**
* **Implicancia para la siguiente investigación**

De esta manera, el SQL no se presenta como un conjunto aislado de queries, sino como una **investigación analítica encadenada**, donde cada resultado determina qué pregunta se aborda a continuación.































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
