# data/raw — Datos crudos (no incluidos en el repo)

Los datos crudos no se versionan (ver `.gitignore`). El **dataset ya limpio** está en
`../clean/hotel_bookings_clean.csv`, así que puedes reproducir el análisis
(`notebooks/03_analyze.ipynb`) **sin descargar nada**.

Solo necesitas el CSV original si quieres regenerar la limpieza desde cero
(`notebooks/01_prepare.ipynb` → `02_process.ipynb`).

## Cómo obtener los datos
1. **Fuente:** Hotel Booking Demand — https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand
2. **Licencia:** CC BY 4.0 — https://creativecommons.org/licenses/by/4.0/
3. Descarga `hotel_bookings.csv` y colócalo en esta carpeta (`data/raw/hotel_bookings.csv`).

## Cita del dataset
> Antonio, N., de Almeida, A., & Nunes, L. (2019). *Hotel booking demand datasets*.
> Data in Brief, 22, 41–49. https://doi.org/10.1016/j.dib.2018.11.126

El **City Hotel** es un hotel urbano de **Lisboa** (el Resort Hotel del dataset está en el
**Algarve**). Esta ubicación procede del artículo de origen, no del CSV: la columna `country`
es la nacionalidad del huésped, no la ubicación del hotel.
