# Diccionario de datos

Ficha del dataset usado en el análisis: fuente, licencia, diccionario de columnas y limitaciones conocidas.

> **Alcance de este diccionario.** Describe el **esquema del dataset original** (32 columnas). El CSV de `data/clean/` es una **versión modificada (limpiada)**: se eliminó la columna `company` y se trataron los valores `"Undefined"`/NaN, entre otros cambios. Los conteos de nulos, «Undefined» y outliers de más abajo reflejan el estado **original** (profiling de la Fase 2); el detalle del tratamiento está en [`changelog.md`](changelog.md).

## Fuente

| Campo | Detalle |
|---|---|
| Nombre | Hotel Booking Demand |
| Origen | Kaggle (autor: Jesse Mostipak). Datos originales: Antonio, de Almeida & Nunes (2019), *Data in Brief* |
| URL | https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand |
| Licencia | CC BY 4.0 — https://creativecommons.org/licenses/by/4.0/ |
| Periodo (fecha de llegada) | jul 2015 – ago 2017 |
| Rango de `reservation_status_date` | oct 2014 – sep 2017 |
| Tamaño original | 119.390 filas × 32 columnas |
| Tamaño tras limpieza | 86.999 filas (ver `changelog.md`) |
| Variable objetivo | `is_canceled` |

El **City Hotel** es un hotel urbano de **Lisboa** y el **Resort Hotel** uno vacacional del **Algarve** (Portugal). Esta ubicación procede del artículo de origen, no del CSV (la columna `country` es la nacionalidad del huésped, no la ubicación del hotel). Este análisis se centra únicamente en el City Hotel.

> Cita: Antonio, N., de Almeida, A., & Nunes, L. (2019). *Hotel booking demand datasets*. Data in Brief, 22, 41–49. https://doi.org/10.1016/j.dib.2018.11.126

## Diccionario de columnas

Los valores categóricos son los reales del dataset (obtenidos con `value_counts()`), sin traducir.

| Columna | Tipo | Descripción | Valores / rango |
|---|---|---|---|
| `hotel` | str | Tipo de hotel | City Hotel, Resort Hotel |
| `is_canceled` | int | Si la reserva fue cancelada | 0 (No), 1 (Sí) |
| `lead_time` | int | Días entre la reserva y la llegada | entero ≥ 0 |
| `arrival_date_year` | int | Año de llegada | 2015, 2016, 2017 |
| `arrival_date_month` | str | Mes de llegada | January … December |
| `arrival_date_week_number` | int | Semana del año de llegada | 1–53 |
| `arrival_date_day_of_month` | int | Día del mes de llegada | 1–31 |
| `stays_in_weekend_nights` | int | Noches en fin de semana | entero ≥ 0 |
| `stays_in_week_nights` | int | Noches entre semana | entero ≥ 0 |
| `adults` | int | Nº de adultos | entero ≥ 0 |
| `children` | float | Nº de niños | entero ≥ 0 (tiene NaN) |
| `babies` | int | Nº de bebés | entero ≥ 0 |
| `meal` | str | Régimen de comida | BB (aloj+desayuno), HB (media pensión), FB (pensión completa), SC (solo alojamiento), Undefined |
| `country` | str | País de origen del cliente | código ISO 3166-1 alpha-3; 178 países; 488 NaN |
| `market_segment` | str | Segmento de mercado | Direct, Corporate, Online TA, Offline TA/TO, Groups, Complementary, Aviation, Undefined |
| `distribution_channel` | str | Canal de distribución | Direct, Corporate, TA/TO, GDS, Undefined |
| `is_repeated_guest` | int | Cliente repetido | 0 (No), 1 (Sí) |
| `previous_cancellations` | int | Cancelaciones previas del cliente | entero ≥ 0 |
| `previous_bookings_not_canceled` | int | Reservas previas no canceladas | entero ≥ 0 |
| `reserved_room_type` | str | Tipo de habitación reservada | A–H, L, P (codificado) |
| `assigned_room_type` | str | Tipo de habitación asignada | A–I, K, L, P (codificado) |
| `booking_changes` | int | Nº de cambios en la reserva | entero ≥ 0 |
| `deposit_type` | str | Tipo de depósito | No Deposit, Non Refund, Refundable |
| `agent` | float | ID de la agencia | ID numérico (tiene NaN) |
| `company` | float | ID de la empresa (solo en el dataset **original**) | **Eliminada en la limpieza** (94 % NaN); no está en `data/clean/` |
| `days_in_waiting_list` | int | Días en lista de espera | entero ≥ 0 |
| `customer_type` | str | Tipo de cliente | Transient, Transient-Party, Contract, Group |
| `adr` | float | Tarifa media diaria (Average Daily Rate) | decimal (tiene un mínimo negativo) |
| `required_car_parking_spaces` | int | Plazas de parking pedidas | entero ≥ 0 |
| `total_of_special_requests` | int | Nº de peticiones especiales | entero ≥ 0 |
| `reservation_status` | str | Estado final de la reserva | Check-Out, Canceled, No-Show |
| `reservation_status_date` | str | Fecha del último estado | YYYY-MM-DD (es texto; se convierte a fecha en la Fase 3) |

## Valores faltantes y limitaciones

> Los conteos de esta sección reflejan el **dataset original** (profiling de la Fase 2). El CSV limpio ya **no** contiene estos problemas; ver el tratamiento en [`changelog.md`](changelog.md).

### Nulos reales (NaN)
`company` 112.593 (94,3 %) · `agent` 16.340 (13,7 %) · `country` 488 (0,4 %) · `children` 4 (~0 %).

### Nulos disfrazados (texto "Undefined", no NaN)
`meal` 1.169 · `distribution_channel` 5 · `market_segment` 2. pandas no los cuenta como nulos, así que hay más datos faltantes de los que reporta `isnull()`.

### Outliers / valores sospechosos
`adr` mín **−6,38** (imposible) y máx **5.400** (extremo) · `adults` máx 55 · `children` máx 10 · `babies` máx 10 · `stays_in_week_nights` máx 50.

### Otras consideraciones
- **Duplicados exactos:** 31.994 filas. Sin ID único de reserva no se puede distinguir un duplicado-error de dos reservas legítimas idénticas.
- **180 filas con 0 huéspedes** (`adults + children + babies = 0`).
- **Geografía:** dos hoteles de Portugal (City = Lisboa, Resort = Algarve; ubicación del artículo, no del CSV) → no generaliza a otros mercados.
- **Antigüedad:** 2015–2017, pre-COVID → no refleja la demanda actual.
- **Data leakage:** `reservation_status` y `reservation_status_date` revelan el resultado (Canceled/No-Show = cancelación) y solo se conocen DESPUÉS de la reserva → no se usan como predictores en el análisis.

### Evaluación ROCCC
- **Reliable:** sí (consistente; algún outlier y nulo tratado en la limpieza).
- **Original:** parcial (fuente secundaria Kaggle; original = artículo de Antonio et al., 2019).
- **Comprehensive:** sí (32 variables; cubre todas las preguntas guía).
- **Current:** no (datos 2015–2017, pre-COVID).
- **Cited:** sí (autores y publicación citables).
