# Business task

Definición del problema de negocio, las preguntas que guían el análisis y su alcance. Es el punto de partida del proyecto (fase *Ask* del proceso de Google Data Analytics): qué se quiere responder y por qué, antes de tocar los datos.

## Contexto

El **City Hotel** es un hotel urbano de Lisboa que, entre julio de 2015 y agosto de 2017, canceló el **30,07 % de sus 53.050 reservas** (3 de cada 10). Cada cancelación es una habitación que se revende tarde o queda vacía: afecta a ingresos, a la política de overbooking y a la planificación de personal. El negocio necesita saber **qué reservas tienen más riesgo de cancelarse y por qué** para poder anticiparse.

## Business task (en una frase)

Identificar los factores que más influyen en la cancelación de reservas del City Hotel (Lisboa) y traducirlos en recomendaciones accionables para reducir la tasa de cancelación y mejorar la previsión de ocupación.

## Stakeholders

| Stakeholder | Rol | Interés principal |
|---|---|---|
| Hotel Manager | Dirección | Mantener una ocupación ≥ 80 % durante todo el año. |
| Revenue Manager | Pricing / revenue | Ajustar overbooking y precio según el riesgo de cancelación. |
| Recepción / Operaciones | Operaciones | Planificar el personal según la ocupación real esperada. |

## Preguntas guía

| # | Pregunta | Qué decisión ayuda a tomar | Métrica | Columnas |
|---|---|---|---|---|
| 1 | ¿Qué tasa de cancelación hay y cómo varía por mes? | Dónde reforzar overbooking / políticas | % de `is_canceled` | `is_canceled`, `arrival_date_month` |
| 2 | ¿La antelación (lead time) predice la cancelación? | Cuándo pedir garantía / depósito | cancel rate por tramo | `lead_time`, `is_canceled` |
| 3 | ¿Qué segmento o canal cancela más? | Dónde ajustar condiciones por canal | cancel rate por grupo | `market_segment`, `distribution_channel` |
| 4 | ¿El tipo de depósito se asocia a la cancelación? | Si condicionar la garantía según el riesgo | cancel rate por tipo | `deposit_type` |
| 5 | ¿El precio (ADR) o las peticiones especiales se relacionan con cancelar? | Pricing / detección de riesgo | cancel rate por tramo | `adr`, `total_of_special_requests` |
| 6 | ¿Las señales de cliente (repeat guest, cancelaciones previas) predicen la cancelación? | A quién priorizar / exigir garantía | cancel rate por grupo | `is_repeated_guest`, `previous_cancellations` |

> La pregunta 6 se formalizó durante la fase de análisis a partir del alcance de «señales de cliente»; por eso el análisis, la presentación y las recomendaciones hablan de 6 preguntas.

Cada pregunta se responde en el notebook `03_analyze.ipynb` y en `sql/04_analyze.sql` (18 consultas: Q0–Q15, con sub-análisis Q8b y Q13b).

## Métricas de éxito

- Cuantificar la tasa de cancelación global y por temporada, segmento y canal.
- Identificar y cuantificar los 3 o más factores más asociados a cancelar.
- Entregar 3 o más recomendaciones accionables, cada una ligada a un hallazgo.

## Alcance

**Qué SÍ responde este análisis**
- Análisis descriptivo y correlacional de la cancelación: tasa global y por mes, lead time, canal/segmento, depósito, precio (ADR), peticiones especiales y señales de cliente.
- Foco en el City Hotel (urbano, Lisboa). Periodo: julio 2015 – agosto 2017.
- Recomendaciones accionables ligadas a hallazgos.

**Qué NO responde (fuera de alcance)**
- Modelo predictivo o de machine learning formal: se mide asociación, no predicción.
- Causalidad: asociación ≠ causa.
- Optimización de pricing/revenue ni algoritmo de overbooking.
- Demanda actual o posterior a 2017 (datos pre-COVID).
