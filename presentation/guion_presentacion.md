# Guion de la presentación — Fase 5 Share

> **Cómo usar este guion:** montas tú el deck en OnlyOffice Impress siguiendo slide a slide.
> Los gráficos los construyes en Tableau (sirven también para el dashboard) y los pegas.
> Todos los números salen de `sql/04_analyze.sql` (query citada en cada slide). Regla: ningún número en una slide sin su query.

## Principios visuales (McCandless) — aplican a TODAS las slides
- Cada visual lleva **nombre + el insight declarado** como titular (no "Cancelación por segmento", sino "Online TA cancela el 36%").
- **Un color de acento** para lo importante (riesgo alto); el resto en gris. Paleta apta para daltonismo (evita rojo/verde juntos; usa azul/naranja).
- Regla de los **5 segundos**: si no se entiende la slide en 5 s, sobra texto.
- **Escala consistente** entre gráficos comparables (mismos % en el mismo eje).
- Base de referencia siempre visible: **City Hotel, 53.050 reservas, 30,07% de cancelación**.

---

## Arco narrativo
Problema → pistas (quién y cuándo) → **el giro** (el dato que engañaba) → **la revelación** (selección, no causa) → **clímax** (el perfil de máximo riesgo) → recomendaciones → cierre + caveats.

---

## Slide 1 — Portada
- **Título:** ¿Quién cancela en el City Hotel — y por qué?
- **Subtítulo:** Factores de cancelación en 53.050 reservas · jul 2015 – ago 2017
- **Pie:** Gonzalo · junio 2026 · Google Data Analytics Capstone
- **Gráfico:** ninguno (fondo sobrio, quizá foto de hotel atenuada).
- **Talking points:** "Un hotel urbano de Lisboa cancela 3 de cada 10 reservas. Hoy os enseño quién las cancela, por qué, y dónde concentrar el esfuerzo."

## Slide 2 — Agenda
- **Contenido (5 bloques con minutos):** El problema (3') · Qué encontré (10') · El giro y lo que revela (7') · Recomendaciones (6') · Próximos pasos y Q&A (4').
- **Gráfico:** ninguno.
- **Talking points:** marca el ritmo; avisa de que habrá un "giro" a mitad (engancha).

## Slide 3 — El problema (Purpose)
- **Headline:** 3 de cada 10 reservas del City Hotel se cancelan
- **Texto:** 30,07% de 53.050 reservas (2015–2017). Cada cancelación es una habitación que se revende tarde o queda vacía → ingresos y forecasting.
- **Gráfico (Tableau):** número grande **30,07%**, o donut canceladas vs no canceladas (gris + acento). Resaltar el 30%.
- **Fuente:** Q1.
- **Talking points:** por qué le importa al negocio (revenue, overbooking, planificación).

## Slide 4 — Cómo lo analicé (método, clave para portfolio)
- **Headline:** 53.050 reservas · 6 preguntas · SQL sobre DuckDB
- **Texto:** un solo hotel de Lisboa; datos limpios y documentados (notebook); análisis por segmento, antelación, depósito, precio (ADR), peticiones especiales y señales de cliente.
- **Gráfico:** ninguno — iconos o mini-flujo (datos → limpieza → SQL → insight).
- **Talking points:** mencionar reproducibilidad: todas las queries en el repo, auditadas dos veces.

## Slide 5 — Pista 1: el canal de venta
- **Headline:** Online TA cancela el 36% — y aporta el 79% de todas las cancelaciones
- **Texto:** es el de mayor tasa entre los segmentos grandes y, por volumen (65% de las reservas), concentra ~8 de cada 10 cancelaciones.
- **Gráfico (Tableau):** barras horizontales. Filas = `market_segment`; Columnas = AVG(`is_canceled`) en %. Orden descendente. Online TA en color acento, resto gris. Etiqueta de % en cada barra. Filtrar nulos. (Opcional 2ª medida: % del total de cancelaciones.)
- **Datos:** Online TA 36,10% (n=34.743) · Groups 33,87% (n=2.619) · Aviation 19,91% (n=226) · Offline TA/TO 17,35% · Direct 16,43% · Corporate 11,86% · Complementary 10,62%.
- **Fuente:** Q4, Q6.
- **Talking points:** ojo con Groups (33,87% pero n pequeño) y Aviation (n=226) → **base rate**: una tasa alta con pocos casos no es comparable.

## Slide 6 — Pista 2: la antelación (lead time)
- **Headline:** Cuanto antes se reserva, más se cancela: del 11% al 45%
- **Texto:** relación monotónica por tramo de antelación; el salto fuerte aparece a partir de los 90 días.
- **Gráfico (Tableau):** barras verticales (o línea) por tramo de `lead_time` ordenado 0-7 → 180+. Eje Y = cancel rate %. Resaltar 91-180 y 180+. Anotar el umbral de 90 días.
- **Datos:** 0-7 = 10,51% · 8-30 = 27,86% · 31-90 = 33,17% · 91-180 = 36,72% · 180+ = 44,87%.
- **Fuente:** Q3.
- **Talking points:** tiene lógica de negocio — más tiempo hasta la estancia, más probable que cambien los planes.

## Slide 7 — El giro (red herring) ⚠️ mantener separada de la 8
- **Headline:** El dato que parecía la respuesta: las tarifas Non Refund cancelan el 97%
- **Texto:** por tipo de depósito, Non Refund cancela el 97,16% frente al 29% sin depósito. *Instinto inicial: "exigir depósito no reembolsable dispara las cancelaciones".*
- **Gráfico (Tableau):** barras por `deposit_type`, cancel rate %. Resaltar Non Refund 97%. Mostrar el n pequeño (n=844 = 1,6% de las reservas).
- **Datos:** Non Refund 97,16% (n=844) · Refundable 66,67% (n=15) · No Deposit 28,98% (n=52.191).
- **Fuente:** Q8.
- **Talking points:** plantéalo como pregunta abierta: "¿Solución: poner depósitos no reembolsables? Antes de recomendarlo, miré quién hace esas reservas…" → corta aquí, pasa a la 8.

## Slide 8 — La revelación (asociación ≠ causa) ⭐ momento portfolio
- **Headline:** No es el depósito: son reservas hechas con ~6 meses de antelación
- **Texto:** las Non Refund tienen una mediana de lead time de 198,5 días (vs 49 del resto) y son 91% Groups + Offline TA/TO. No es que el depósito cause cancelación: es un grupo **auto-seleccionado** de reservas de larguísima antelación. Asociación ≠ causalidad → no es accionable como palanca.
- **Gráfico (Tableau):** barras de MEDIAN(`lead_time`) por `deposit_type`. Resaltar Non Refund 198,5 frente a ~49.
- **Datos:** lead mediana → Non Refund 198,5 d · Refundable 52,0 d · No Deposit 49,0 d. Composición del Non Refund: Groups 59,6% + Offline TA/TO 31,9% = 91,5%.
- **Fuente:** Q9, Q8b.
- **Talking points:** *este es tu material de entrevista.* "Mi primer instinto fue causal y estaba equivocado; el cruce reveló selección. Por eso no recomiendo imponer depósitos."

## Slide 9 — Señal · peticiones especiales (UNA sola idea)
- **Headline:** Sin peticiones especiales se cancela casi el doble (38% vs 22%)
- **Texto:** 0 peticiones especiales → 38,36% vs 1+ → 21,99% (1,74×). Ese grupo es el 49% del volumen y el 63% de las cancelaciones. Una petición especial = señal de intención real de venir.
- **Gráfico (Tableau):** barras 0 vs 1+ peticiones, cancel rate %. Resaltar el 0.
- **Datos:** 0 = 38,36% (vol 49,4%, 63,0% de las canc) · 1+ = 21,99%.
- **Fuente:** Q12.
- **Talking points:** señal secundaria pero accionable (las peticiones = engagement = intención de venir). *(La señal de cancelaciones previas se movió al apéndice para no romper la regla de una idea por slide.)*

## Slide 10 — Clímax: el cruce ⭐ TITULAR
- **Headline:** El perfil de máximo riesgo: Online TA + reserva con >90 días = 45% de cancelación
- **Texto:** al combinar las dos señales fuertes, la tasa sube a 44,70% — **3,1× el grupo de menor riesgo (14,37%)**. Las señales se potencian, no se suman.
- **Gráfico (Tableau):** matriz 2×2 — filas `market_segment` (Online TA / Resto), columnas `lead_time` (>90 / 0-90), color = cancel rate (heatmap) y etiqueta con el %. Alternativa: barras agrupadas. Resaltar la celda 44,70% y el suelo 14,37%.
- **Datos:** Online TA·>90 = 44,70% (n=12.122) · Online TA·0-90 = 31,49% · Resto·>90 = 28,36% · Resto·0-90 = 14,37% (n=12.747).
- **Fuente:** Q15.
- **Talking points:** este es el hallazgo accionable; lo demás construye hacia aquí.

## Slide 11 — Qué significa para el negocio
- **Headline:** Ese único perfil = 23% de las reservas, pero 34% de todas las cancelaciones
- **Texto:** actuar solo sobre ese grupo ataca un tercio del problema con menos de un cuarto del volumen. Foco, no dispersión.
- **Gráfico (Tableau):** dos barras o callouts comparando 23% (volumen) vs 34% (cancelaciones) del perfil.
- **Datos:** 12.122 / 53.050 = 22,8% del volumen · 5.419 / 15.953 = 34,0% de las cancelaciones.
- **Fuente:** Q15.
- **Talking points:** eficiencia de la intervención — argumento de negocio.

## Slide 12 — Recomendaciones
- **Headline:** Tres palancas sobre el grupo de máximo riesgo
1. **Confirmación escalonada** para reservas Online TA con >90 días de antelación (recordatorio a 60 y 30 días de la estancia) para detectar bajas antes de tiempo.
2. **Fomentar el engagement pre-llegada** (peticiones especiales, upgrades, check-in online): a más interacción, menos cancelación.
3. **Garantía diferenciada por riesgo**, NO un Non Refund universal — el análisis muestra que el depósito no es causal; segmentar flexibilidad/ofertas por perfil.
- **Gráfico:** ninguno (3 bloques con icono).
- **Talking points:** cada rec ligada a un hallazgo; sé honesto sobre lo que NO se puede concluir (depósitos).

## Slide 13 — Call to action / próximos pasos
- **Headline:** Siguientes pasos: medir, no solo observar
- **Texto:** (1) test A/B del recordatorio sobre el segmento de riesgo; (2) capturar la *fecha* de cancelación para separar bajas tempranas de tardías; (3) sumar más años/hoteles para validar el patrón.
- **Talking points:** el marco de experimento demuestra pensamiento causal — bien valorado en entrevista.

## Slide 14 — Caveats / limitaciones
- **Headline:** Qué NO dicen estos datos
- **Bullets:** un solo hotel (City Hotel, Lisboa) · 26 meses (jul 2015 – ago 2017) · asociación, no causalidad · Non Refund no evaluable causalmente (selección) · ADR como proxy de precio.
- **Talking points:** mostrar los límites es señal de madurez analítica, no de debilidad.

## Slide 15 — Apéndice (para Q&A)
- **Headline:** Soporte y reproducibilidad
- **Contenido:** link al dashboard de Tableau Public · repo GitHub · `sql/04_analyze.sql` (DuckDB) y notebook `03_analyze` · señal secundaria (1 cancelación previa = 80,35%, independiente del depósito; Q13b, Q14) · cita del dataset (Antonio, de Almeida & Nunes 2019; City Hotel = Lisboa, Resort = Algarve) · tabla con todas las cifras de soporte.
- **Talking points:** "Todo lo que habéis visto es reproducible; aquí están las queries."

---

## Checklist antes de dar por hecho el deck
- [ ] Título + subtítulo + fecha en portada
- [ ] Flujo Agenda → Purpose → Data → Recs → CTA
- [ ] Cada visual con nombre + insight (McCandless)
- [ ] Slides 7 y 8 SEPARADAS (el giro y la revelación)
- [ ] Texto ≤ 5 s por slide
- [ ] Recomendaciones en slide dedicada
- [ ] Caveats incluidos
- [ ] Talking points ensayados ≈ 30 min
- [ ] Link al dashboard Tableau en apéndice
