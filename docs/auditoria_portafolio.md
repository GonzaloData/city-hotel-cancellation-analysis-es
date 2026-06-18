# Auditoría de portafolio — City Hotel (cancelaciones)

> Revisión de calidad del repositorio para presentarlo como proyecto de portafolio.
> Fecha: 2026-06-18 · Alcance: repo + presentación (.pptx + gráficos) + notebooks + dashboard de Tableau.

## Método: sistema de autorevisado en 3 capas

1. **Capa 1 — auditoría independiente:** cinco revisiones especializadas en paralelo, sin verse entre sí — (1) técnica/cifras/reproducibilidad, (2) narrativa y negocio, (3) documentación y profesionalismo, (4) legal y licencias, (5) presentación visual.
2. **Capa 2 — consolidación:** cruce de los cinco informes + verificación propia con DuckDB, resolución de contradicciones y priorización (P0/P1/P2).
3. **Capa 3 — re-verificación independiente:** un revisor distinto comprueba el repo ya corregido desde cero (que ninguna cifra quede descuadrada y que los arreglos no introduzcan errores nuevos).

Restricción del encargo: **no se modifica el código Python ni la lógica SQL.** Las correcciones se limitan a documentación, presentación, consistencia de cifras y limpieza legal/higiene. La única excepción fue **reparar una línea truncada** del `.sql` (con autorización explícita), sin cambiar lógica.

## Veredicto global

Proyecto **sólido y por encima de la media de un capstone**. La aritmética es fiable al 100 %: las ~35 cifras citadas en documentación, presentación y notebooks **reproducen exactas** sobre el CSV (verificadas con DuckDB). El rigor metodológico (distinción asociación/causalidad, control de *data leakage*, base de referencia siempre visible) es destacable. Los defectos eran de **consistencia documental, higiene y un archivo `.sql` truncado**, no de análisis.

| Dimensión | Nota (capa 1) | Estado tras arreglos |
|---|---|---|
| Técnica / cifras / reproducibilidad | 8,5/10 | P0 del `.sql` corregido → ejecuta entero |
| Narrativa y negocio | 8/10 | lenguaje causal corregido; mejora de € en riesgo pendiente (opcional) |
| Documentación y profesionalismo | 8,5/10 | archivo basura eliminado; consistencia unificada |
| Legal y licencias | 8,5/10 | CC BY 4.0 «cambios» declarado; doble licencia explícita |
| Presentación visual | 8,5/10 | cifras correctas; rediseño de gráficos pendiente (opcional) |

## Verificación de cifras (DuckDB sobre `data/clean/`, filtrado a City Hotel)

Base: City Hotel = **53.050** reservas, cancelación **30,07 %**. Todas las siguientes reproducen exactas: Online TA 36,10 % (n=34.743), Resto 18,62 %, Online TA = 79 % de las cancelaciones (78,62 % redondeado) con 65 % del volumen; tramos lead time 10,51 / 27,86 / 33,17 / 36,72 / 44,87 %; depósito Non Refund 97,16 % (n=844), No Deposit 28,98 % (n=52.191); mediana lead por depósito 198,5 / 52 / 49 d; peticiones 0 = 38,36 % (49 % del volumen, 63 % de cancelaciones) vs 1+ = 21,99 %; cruce Online TA·>90 = 44,70 % (n=12.122) vs Resto·0-90 = 14,37 % (n=12.747); perfil de riesgo 23 % del volumen / 34 % de cancelaciones (5.419/15.953); cancelación previa = 1 → 80,35 %; repeat guest 11,35 % (n=1.656). **0 cifras incorrectas.**

## Hallazgos y estado

Leyenda: ✅ corregido · 🔧 pendiente (tú / es código) · 💡 mejora opcional.

### P0

| ID | Hallazgo | Estado |
|---|---|---|
| P0-1 | `sql/04_analyze.sql` truncado en la última línea (`ORDER BY cancel_r`) → `duckdb < sql/04_analyze.sql` fallaba con *BinderException*. Contradecía la cabecera del propio archivo y las instrucciones de reproducción del README. | ✅ Restaurada la línea a `ORDER BY cancel_rate_pct DESC;` (copiada del notebook 03). Verificado: el archivo ejecuta de Q0 a Q15 sin error. |
| P0-2 | `_probe_root.txt` (archivo basura, contenido «probe») versionado en la raíz. | ✅ Eliminado. |
| P0-3 | CC BY 4.0: ningún aviso declaraba que el CSV redistribuido es una versión **modificada** del original (requisito formal de la licencia). | ✅ Declarado en README, `LICENSE`, `data/raw/README.md` y el nuevo `data/clean/README.md`. |

### P1

| ID | Hallazgo | Estado |
|---|---|---|
| P1-1 | Periodo inconsistente: `data_dictionary` decía «01/07/2015 – 14/09/2017» (mezcla fecha de llegada con `reservation_status_date`); el resto del proyecto dice «jul 2015 – ago 2017». Verificado: llegadas City = jul 2015–ago 2017; `reservation_status_date` = oct 2014–sep 2017. | ✅ Diccionario desglosado en dos rangos etiquetados. |
| P1-2 | `data_dictionary` describía la columna `company` (eliminada en la limpieza) y listaba nulos en estado «crudo» sin etiquetar la etapa → describía un dataset distinto al CSV real. | ✅ Añadida nota de alcance (esquema original vs CSV limpio); `company` marcada como eliminada; sección de faltantes etiquetada como estado original. |
| P1-3 | Lenguaje causal incoherente con la tesis «asociación ≠ causa»: «¿El depósito **reduce** las cancelaciones?» (business_task y notebook 03). | ✅ Reformulado a «¿El tipo de depósito **se asocia** a la cancelación?» en `business_task.md` y en la celda markdown del notebook 03 (sin tocar código). |
| P1-4 | Faltaba atribución de la licencia **junto al dato** (`data/clean/`). | ✅ Creado `data/clean/README.md` con atribución CC BY 4.0, cambios, contenido y nota de privacidad. |
| P1-5 | `requirements.txt` no declaraba `jinja2` (lo usa `pandas .style` al renderizar tablas en los notebooks). | ✅ Añadido `jinja2` a `requirements.txt`. |

### P2

| ID | Hallazgo | Estado |
|---|---|---|
| P2-1 | Recuento de consultas inconsistente: README «18 queries» vs business_task «Q1–Q15». | ✅ Unificado a «18 consultas (Q0–Q15, con sub-análisis Q8b y Q13b)» en ambos. |
| P2-2 | Comentarios de `sql/04_analyze.sql` sin tildes (a diferencia de los `.md`) y referencia a una «Q9b» inexistente. | ✅ Acentuados los comentarios (solo comentarios, sin tocar lógica) y corregida la referencia «Q9b» → **Q8b** (la sub-consulta que respalda la lectura de selección, junto con Q9). Verificado: el `.sql` sigue ejecutando entero. |
| P2-3 | Gráficos: `matriz_riesgo.png` usa la paleta equivocada (naranja en gradiente en vez de teal+gris) y le falta visualmente la 4ª celda; las barras horizontales (`segmento`, `deposito`, `peticiones`, `antelacion_x_deposito`) salen con proporción aplastada. Las **cifras son correctas**; es diseño. | 🔧 Señalado. Puedo regenerarlos a petición. |
| P2-4 | `data/clean/hotel_bookings_clean.csv` aparece sin *commitear* en `git status`; commit `8cf8088` con errata («Pepared public Repo»). | 🔧 Señalado (decisión de git tuya). |

### Mejoras opcionales de alto impacto

| ID | Mejora | Estado |
|---|---|---|
| M-1 | Cuantificar el **€ en riesgo** del segmento accionable (tienes `adr` para una estimación ilustrativa) — es lo que más eleva la percepción ante un reclutador. | 💡 Recomendado. |
| M-2 | Añadir una columna «Query» a las preguntas guía y un mini-mapa pregunta→hallazgo→slide→recomendación (trazabilidad Ask→Act de un vistazo). | 💡 Recomendado. |

## Cambios aplicados (resumen)

1. **Eliminado** `_probe_root.txt`.
2. **`sql/04_analyze.sql`** — restaurada la última línea truncada (ejecuta entero). *Único cambio en SQL, autorizado; sin tocar lógica.*
3. **`docs/data_dictionary.md`** — nota de alcance (original vs limpio), periodo desglosado, `company` marcada como eliminada, sección de faltantes etiquetada como estado original.
4. **`docs/business_task.md`** — Pregunta 4 reformulada a asociación; recuento de consultas unificado.
5. **`README.md`** — nota de «versión modificada», recuento unificado y nueva sección **Licencia** (MIT código / CC BY 4.0 datos).
6. **`LICENSE`** — nota de datos reforzada (versión modificada + indicación de cambios).
7. **`data/raw/README.md`** — sección «Cambios respecto al original (CC BY 4.0)».
8. **`data/clean/README.md`** — *nuevo*: atribución CC BY 4.0 junto al dato, cambios, contenido (los dos hoteles) y privacidad.
9. **`notebooks/03_analyze.ipynb`** — solo la celda markdown de la Pregunta 4 (sin tocar ninguna celda de código).
10. **`requirements.txt`** — añadido `jinja2` (lo usa `pandas .style`).
11. **`sql/04_analyze.sql`** — comentarios acentuados y referencia «Q9b» → «Q8b» (solo comentarios; la lógica no cambia; verificado que ejecuta entero).

## Lo que ya estaba bien (no romper)

- Exactitud total de las cifras y trazabilidad cifra→query.
- Control de *data leakage* (`reservation_status`/`_date` excluidas como predictores).
- Distinción asociación/causalidad (el desmontaje del «97 % de Non Refund» como selección es el mejor activo del proyecto).
- Changelog de limpieza con 14 transformaciones documentadas; evaluación ROCCC.
- README escaneable y completo; enlaces internos sin roturas; cita académica correcta (DOI verificado).
- Presentación coherente con el guion (15/15 slides) y sin activos de terceros con copyright.
