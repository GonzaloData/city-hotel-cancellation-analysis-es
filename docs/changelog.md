# Changelog de datos

> Registro de CADA transformación de la Fase 3 (limpieza), en orden de ejecución. Espejo de `3️⃣ Fase 3 Process.md`.
> Dataset: **119.390 → 86.999 filas (−32.391)**. Código: `notebooks/02_process.ipynb`.

| #  | Fecha      | Transformación | Motivo | Herramienta |
| -- | ---------- | -------------- | ------ | ----------- |
| 1  | 2026-06-09 | Eliminar duplicados exactos (119.390 → 87.396) | Sin ID único; filas 100 % idénticas en las 32 columnas = probables duplicados de exportación. | Python, pandas |
| 2  | 2026-06-09 | `"Undefined"` → NaN en `meal`, `distribution_channel`, `market_segment` | Nulos disfrazados de categoría; unificar faltantes antes de tratarlos. | Python, pandas |
| 3  | 2026-06-09 | Eliminar columna `company` | 94 % de valores faltantes → inservible. | Python, pandas |
| 4  | 2026-06-09 | `agent`: NaN → `0` | ID numérico; `0` = sin agencia (venta directa). No imputar con la media. | Python, pandas |
| 5  | 2026-06-09 | `country`: NaN → `"Unknown"` | Categórica; "Unknown" es honesto y claro para stakeholders. | Python, pandas |
| 6  | 2026-06-09 | `children`: NaN → `0` (4 filas) | Razonable asumir 0 niños cuando falta el dato. | Python, pandas |
| 7  | 2026-06-09 | Eliminar fila con `adr` negativo (−6.38) | Tarifa negativa = error imposible. `adr = 0` se conserva (cortesía). | Python, pandas |
| 8  | 2026-06-10 | Eliminar outliers aislados: `adr ≥ 5400`, `babies ≥ 9`, `children ≥ 10` | Aislados con salto brusco al resto (sig. adr 510, babies 2, children 3) → probables errores. | Python, pandas |
| 9  | 2026-06-10 | Eliminar reservas sin ocupantes (`adults + children + babies = 0`) | Registro inválido para análisis de demanda (≈180 detectadas en Fase 2). | Python, pandas |
| 10 | 2026-06-10 | Eliminar reservas con `adults = 0` y `children`/`babies > 0` (219 filas) | Un menor no puede ser el único huésped sin adulto responsable = registro inválido. | Python, pandas |
| 11 | 2026-06-10 | `reservation_status_date`: texto → datetime | Corregir tipo. `reservation_status`(_date) excluidas como predictores en Fase 4 (data leakage). | Python, pandas |
| 12 | 2026-06-10 | Re-dedup final (7 filas): 87.006 → **86.999** | Tras eliminar `company` e imputar, 7 filas quedaron idénticas. | Python, pandas |
| 13 | 2026-06-10 | **Mantener** `adults` (26–55) y `stays_in_week_nights` (30–50) | Gradiente suave → grupos / estancias largas, no errores. Decisión consciente. | Decisión |
| 14 | 2026-06-10 | **Mantener** NaN en `meal` (492), `market_segment` (2), `distribution_channel` (5) | Faltantes reales (ex-"Undefined"); se excluyen al agrupar en Fase 4 (`dropna`). | Decisión |
