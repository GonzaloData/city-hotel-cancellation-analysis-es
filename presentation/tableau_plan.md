# Plan Tableau — Fase 5 (City Hotel)

> **Objetivo:** construir los 6–7 gráficos del deck + un dashboard en Tableau Public.
> **Método:** construido en Tableau Public, worksheet por worksheet.
> **Regla visual (igual que el deck):** título de cada hoja = el *insight* (McCandless), no un nombre neutro. Acento teal `#0E7C7B` para lo importante, gris para el resto, naranja `#E2711D` solo para el riesgo máximo.

---

## Fase A · Setup (una sola vez)

1. **Cuenta + app:** crear cuenta en Tableau Public y descargar **Tableau Public Desktop** (gratis).
2. **Conectar datos:** `Connect → Text file →` `data/clean/hotel_bookings_clean.csv`.
3. **Filtro de fuente de datos:** `hotel = 'City Hotel'` como *Data Source Filter* (botón Add, arriba a la derecha en la pestaña Data Source). Así TODO el libro trabaja sobre las 53.050 reservas y no tienes que filtrar en cada hoja.
4. **Campos calculados reutilizables** (crear ya los 2 primeros; el resto cuando toquen):
   - **`Tasa de cancelación`** = `AVG([Is Canceled])` → formato Porcentaje, 2 decimales. *(Lo usan casi todos los gráficos.)*
   - **`Tramo lead time`** = IF/ELSEIF por los cortes 0-7, 8-30, 31-90, 91-180, 180+.
   - **`Grupo segmento`** = `IF [Market Segment]='Online TA' THEN 'Online TA' ELSE 'Resto' END`.
   - **`Grupo lead`** = `IF [Lead Time] > 90 THEN 'lead >90' ELSE 'lead 0-90' END`.

### Notas para que cuadre con los datos (verificado 2026-06-16)
- **Tableau renombra los campos** al importar: `is_canceled` → `Is Canceled`, `lead_time` → `Lead Time`, `market_segment` → `Market Segment`, `deposit_type` → `Deposit Type`. Confírmalo al conectar.
- **`market_segment` tiene 2 nulos.** En los gráficos de segmento (#1 y matriz #7) añade un filtro **`Market Segment` ≠ Null** para replicar el `WHERE … IS NOT NULL` del SQL; si no, esos 2 registros caen en "Resto" y la tasa se mueve una milésima. Con el filtro, la matriz da exactamente 44,70% / 14,37%.
- **`Tramo lead time` se ordenará alfabético** ("0-7", "180+", "31-90"…). Hay que **ordenarlo a mano** (0-7 → 8-30 → 31-90 → 91-180 → 180+) arrastrando los encabezados, o crear una clave numérica de orden.
- `is_canceled` es 0/1 entero → `AVG` da la tasa directamente (formatear como %). `lead_time` es entero → `MEDIAN` funciona.

---

## Fase B · Worksheets (orden recomendado: de fácil a difícil)

| # | Hoja (→ slide del deck) | Tipo | Campos clave | Qué enseña |
|---|---|---|---|---|
| 1 | **Segmento** (→ slide 5) | barras horizontales | `Market Segment` + `Tasa de cancelación`, orden desc, color acento a Online TA | el patrón base que se repite en casi todo |
| 2 | **Lead time** (→ slide 6) | barras verticales | `Tramo lead time` + `Tasa de cancelación` (ordenar tramos a mano) | usar un campo calculado de tramos |
| 3 | **Depósito** (→ slide 7) | barras | `Deposit Type` + `Tasa de cancelación` | refuerzo del patrón (resaltar Non Refund) |
| 4 | **Antelación por depósito** (→ slide 8) | barras | `Deposit Type` + `MEDIAN([Lead Time])` | cambiar la agregación (mediana, no tasa) |
| 5 | **Peticiones 0 vs 1+** (→ slide 9) | barras | campo calc `0 / 1+` + `Tasa de cancelación` | campo calculado binario |
| 6 | **Donut 30%** (→ slide 3) | donut | `Tasa de cancelación` / conteo | *opcional* — el número grande ya está en la slide; técnica de pie + agujero |
| 7 | **Matriz de riesgo 2×2** (→ slide 10) ⭐ | mapa de calor | `Grupo segmento` (filas) × `Grupo lead` (columnas), color = `Tasa de cancelación` | la pieza estrella; dos calc fields + color |

> Empezamos por la **#1 (Segmento)**: una vez la domines, las #2–#5 son la misma mecánica. La **#7 (matriz)** la dejamos para el final.

---

## Fase C · Dashboard (Tableau Public)
- Combinar las vistas (mínimo la **matriz #7**, que es el titular) en un dashboard: título, leyenda de color, fecha de actualización.
- (Opcional) un filtro interactivo por segmento o tramo de lead.
- **Publish to Tableau Public** → copiar el link → pegarlo en la **slide 15** del deck.

## Fase D · Exportar al deck
- Por cada hoja: `Worksheet → Export → Image` (PNG) → pegar en el hueco correspondiente del `.pptx` y borrar el recuadro discontinuo.
- Mantener el mismo tamaño/estilo entre gráficos comparables (escala de % consistente).

---

## Checklist
- [ ] A · datos conectados + filtro City Hotel + campos calculados base
- [ ] B1 Segmento · B2 Lead · B3 Depósito · B4 Antelación×depósito · B5 Peticiones · B6 Donut · B7 Matriz
- [ ] C · dashboard publicado en Tableau Public (link)
- [ ] D · imágenes exportadas y pegadas en el deck
- [ ] Títulos = insight (McCandless) · colores consistentes con el deck
