# City Hotel — Análisis de factores de cancelación de reservas

**¿Quién cancela una reserva de hotel y por qué?** Análisis de **53.050 reservas** de un hotel urbano de Lisboa (jul 2015 – ago 2017), donde **3 de cada 10 reservas se cancelan (30,07 %)**. Proyecto final (*capstone*) del certificado **Google Data Analytics**.

> **SQL (DuckDB) · Python (pandas) · Jupyter · Tableau** — análisis reproducible y documentado de principio a fin.

📊 **Dashboard interactivo:** [City Hotel — Factores de cancelación (Tableau Public)](https://public.tableau.com/app/profile/gonzalo.gil.pereira2437/viz/CityHotelFactoresdecancelacindereservas/Factoresdecancelacin)

---

## El problema

Identificar los factores que más influyen en la cancelación de reservas del City Hotel y traducirlos en recomendaciones para **reducir la tasa de cancelación y mejorar la previsión de ocupación**. Cada cancelación es una habitación que se revende tarde o queda vacía: impacta en ingresos, overbooking y planificación de personal.

**Preguntas guía:** tasa de cancelación por mes · antelación (lead time) · segmento/canal · tipo de depósito · precio (ADR) y peticiones especiales · señales de cliente (repeat guest, cancelaciones previas).

## Los datos

- **Fuente:** [Hotel Booking Demand](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand) (Kaggle) — licencia **CC BY 4.0**. Datos originales: Antonio, de Almeida & Nunes (2019), *Data in Brief*.
- **Periodo y tamaño:** jul 2015 – ago 2017 · 119.390 reservas → **86.999 tras la limpieza** · 53.050 del City Hotel.
- El **City Hotel** es un hotel urbano de **Lisboa** (ubicación del artículo de origen, no del CSV).
- Diccionario de columnas y limitaciones en [`docs/data_dictionary.md`](docs/data_dictionary.md). El CSV limpio (en `data/clean/`) es una **versión modificada** del original —limpieza en [`docs/changelog.md`](docs/changelog.md) y atribución en [`data/clean/README.md`](data/clean/README.md)—; los datos crudos no se versionan (ver [`data/raw/README.md`](data/raw/README.md)).

## Método (Ask → Act)

1. **Prepare** — profiling del dataset ([`notebooks/01_prepare.ipynb`](notebooks/01_prepare.ipynb)).
2. **Process** — limpieza documentada, 119.390 → 86.999 filas ([`notebooks/02_process.ipynb`](notebooks/02_process.ipynb) · [`docs/changelog.md`](docs/changelog.md)).
3. **Analyze** — análisis en **SQL sobre DuckDB** ([`notebooks/03_analyze.ipynb`](notebooks/03_analyze.ipynb) · queries en [`sql/04_analyze.sql`](sql/04_analyze.sql)).
4. **Share / Act** — presentación, dashboard y recomendaciones ([`presentation/`](presentation/)).

Análisis **descriptivo + correlacional**: mide asociación, no causalidad. `reservation_status` y `reservation_status_date` se excluyen por *data leakage*.

## Hallazgos clave

Base de referencia: **City Hotel, 53.050 reservas, 30,07 % de cancelación**.

1. **La cancelación es, sobre todo, un fenómeno de canal.** Online TA cancela el **36,10 %** y concentra el **79 % de todas las cancelaciones** del hotel (con el 65 % del volumen): casi el doble que el resto de canales juntos (18,62 %).
2. **A más antelación, más cancelación.** La tasa crece de forma monotónica con el lead time: del **10,51 %** (0–7 días) al **44,87 %** (180+ días), con un salto claro a partir de los 90 días.
3. **Las señales se potencian, no se suman.** Online TA **+** reserva con más de 90 días de antelación = **44,70 %** de cancelación (3,1× el grupo más seguro, 14,37 %). Ese único perfil es el **23 % del volumen** y el **34 % de todas las cancelaciones**.
4. **El dato más extremo engaña.** Las tarifas Non Refund cancelan el **97,16 %**… pero es **selección, no causa**: son reservas hechas con ~6 meses de antelación (mediana de 198,5 días) y 91 % de Groups + Offline TA/TO. Asociación ≠ causalidad.
5. **Señales de cliente accionables.** Sin peticiones especiales se cancela el **38,36 %** frente al 21,99 % (1,74×); y quien ya canceló antes **reincide al 80,35 %**, de forma independiente del depósito.

## Recomendaciones

1. **Confirmación escalonada** en reservas Online TA con >90 días de antelación (recordatorios a 60 y 30 días de la estancia): actúa sobre **12.122 reservas (23 % del volumen) que aportan el 34 % de las cancelaciones**.
2. **Fomentar el engagement pre-llegada** (peticiones especiales, upgrades, check-in online) e incorporar el perfil "0 peticiones" al scoring de riesgo.
3. **Garantía diferenciada por riesgo**, no un Non Refund universal: el análisis muestra que el depósito **no causa** la cancelación.

## Estructura del repositorio

```
.
├── README.md
├── requirements.txt
├── data/
│   ├── raw/README.md            # cómo descargar el dataset original (no versionado)
│   └── clean/hotel_bookings_clean.csv
├── notebooks/
│   ├── 01_prepare.ipynb         # profiling
│   ├── 02_process.ipynb         # limpieza
│   └── 03_analyze.ipynb         # análisis (SQL/DuckDB)
├── sql/
│   └── 04_analyze.sql           # 18 consultas (Q0–Q15 + sub-análisis Q8b, Q13b)
├── docs/
│   ├── business_task.md
│   ├── data_dictionary.md
│   └── changelog.md
└── presentation/
    ├── City_Hotel_cancelaciones.pptx
    ├── guion_presentacion.md
    ├── tableau_plan.md
    └── charts/
```

## Cómo reproducir

```bash
pip install -r requirements.txt
```

El CSV limpio ya está en `data/clean/`, así que basta con abrir y ejecutar `notebooks/03_analyze.ipynb` (DuckDB consulta el CSV directamente). Para regenerar la limpieza desde cero, descarga el dataset original (ver `data/raw/README.md`) y ejecuta los notebooks `01` → `02` → `03`.

## Limitaciones

Un solo hotel urbano (City Hotel, Lisboa) · 26 meses (jul 2015 – ago 2017), datos pre-COVID · análisis de asociación, no de causalidad · Non Refund no evaluable causalmente (selección de muestra) · ADR como proxy de precio.

## Licencia

El **código y la documentación** de este repositorio se publican bajo licencia **MIT** (ver [`LICENSE`](LICENSE)). El **dataset** `data/clean/hotel_bookings_clean.csv` **no** está cubierto por MIT: es un derivado de *Hotel Booking Demand* y se redistribuye bajo **CC BY 4.0** con atribución e indicación de cambios (ver [`data/clean/README.md`](data/clean/README.md)).

## Autor

**Gonzalo Gil Pereira** · [LinkedIn](https://www.linkedin.com/in/gonzalo-gil-pereira-b8470a179/)
