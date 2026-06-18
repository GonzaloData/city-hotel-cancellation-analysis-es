# data/clean — Dataset derivado (CC BY 4.0)

`hotel_bookings_clean.csv` es una **versión modificada (limpiada)** del dataset
*Hotel Booking Demand*. **No** está cubierto por la licencia MIT del repositorio:
se rige por **CC BY 4.0**.

## Atribución (CC BY 4.0)

- **Fuente:** Hotel Booking Demand — https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand (autor: Jesse Mostipak).
- **Datos originales:** Antonio, N., de Almeida, A., & Nunes, L. (2019). *Hotel booking demand datasets*. Data in Brief, 22, 41–49. https://doi.org/10.1016/j.dib.2018.11.126
- **Licencia:** CC BY 4.0 — https://creativecommons.org/licenses/by/4.0/
- **Cambios realizados:** versión limpiada (eliminación de duplicados y outliers aislados, tratamiento de nulos, conversión de tipos y eliminación de la columna `company`). 119.390 → 86.999 filas. Detalle completo en [`../../docs/changelog.md`](../../docs/changelog.md).

## Contenido

- Conserva los **dos hoteles** del dataset original (City Hotel + Resort Hotel). El análisis del proyecto filtra a **City Hotel** (53.050 reservas) en `sql/04_analyze.sql`.
- **31 columnas** (la original `company` se eliminó en la limpieza).

## Privacidad

El archivo **no contiene datos personales identificables**: no hay nombres ni
identificadores de individuos. `country` es la nacionalidad (agregada) del huésped
y `agent`/`company` son IDs de organización, no de personas.
