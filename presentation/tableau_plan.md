# Dashboard de Tableau — especificación de visualizaciones

Especificación de las vistas del dashboard publicado en Tableau Public (enlazado en el README). El dashboard reproduce en formato visual los hallazgos del análisis SQL (`sql/04_analyze.sql`), con los datos filtrados al City Hotel (53.050 reservas).

## Convención visual

El título de cada hoja es el insight, no un nombre neutro. Color de acento teal (`#0E7C7B`) para lo relevante, gris para el resto y naranja (`#E2711D`) solo para el riesgo máximo. Escala de porcentaje consistente entre gráficos comparables.

## Campos calculados

- **Tasa de cancelación** = `AVG([Is Canceled])`, formato porcentaje.
- **Tramo lead time** = tramos 0-7, 8-30, 31-90, 91-180, 180+.
- **Grupo segmento** = Online TA / Resto.
- **Grupo lead** = lead >90 / lead 0-90.

## Visualizaciones

| Hoja | Slide | Tipo | Campos | Qué muestra |
|---|---|---|---|---|
| Segmento | 5 | barras horizontales | `market_segment` × tasa | Online TA es el canal que más cancela (36,10 %) |
| Lead time | 6 | barras verticales | tramo lead time × tasa | la cancelación crece con la antelación (11 % → 45 %) |
| Depósito | 7 | barras | `deposit_type` × tasa | Non Refund cancela el 97,16 % |
| Antelación por depósito | 8 | barras | `deposit_type` × `MEDIAN(lead_time)` | las Non Refund son reservas de ~6 meses (mediana 198,5 d) |
| Peticiones 0 vs 1+ | 9 | barras | nº de peticiones × tasa | sin peticiones se cancela casi el doble (38 % vs 22 %) |
| Matriz de riesgo 2×2 | 10 | mapa de calor | grupo segmento × grupo lead, color = tasa | el perfil de máximo riesgo: Online TA + lead >90 = 44,70 % |

## Notas de reproducibilidad

- Al importar el CSV, Tableau renombra los campos: `is_canceled` → `Is Canceled`, `lead_time` → `Lead Time`, `market_segment` → `Market Segment`, `deposit_type` → `Deposit Type`.
- `market_segment` tiene 2 nulos: se filtran (`≠ Null`) para replicar el `WHERE … IS NOT NULL` del SQL. Con ese filtro, la matriz de riesgo da exactamente 44,70 % / 14,37 %.
- `Tramo lead time` se ordena manualmente (0-7 → 8-30 → 31-90 → 91-180 → 180+), no alfabéticamente.
- `is_canceled` es 0/1, por lo que `AVG` devuelve la tasa de cancelación directamente.
