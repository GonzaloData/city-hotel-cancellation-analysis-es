# Guion de la presentación

Estructura narrativa del deck de resultados (`City_Hotel_cancelaciones.pptx`), dirigido a una audiencia no técnica. Documenta el orden de las slides, el mensaje (titular) de cada una y los datos que la sostienen. Todas las cifras proceden de `sql/04_analyze.sql`.

## Principios visuales (McCandless)

- Cada visual lleva nombre + el insight como titular (p. ej. "Online TA cancela el 36 %", no "Cancelación por segmento").
- Un solo color de acento para lo importante (riesgo alto); el resto en gris. Paleta apta para daltonismo.
- Regla de los 5 segundos: si la slide no se entiende en 5 s, sobra texto.
- Escala consistente entre gráficos comparables.
- Base de referencia siempre visible: City Hotel, 53.050 reservas, 30,07 % de cancelación.

## Arco narrativo

Problema → pistas (quién y cuándo) → el giro (el dato que engañaba) → la revelación (selección, no causa) → clímax (el perfil de máximo riesgo) → recomendaciones → cierre y limitaciones.

## Slides

**1 · Portada.** Título "¿Quién cancela en el City Hotel — y por qué?". Subtítulo: factores de cancelación en 53.050 reservas, jul 2015 – ago 2017.

**2 · Agenda.** Cinco bloques: el problema · qué se encontró · el giro y lo que revela · recomendaciones · próximos pasos.

**3 · El problema.** Titular: "3 de cada 10 reservas del City Hotel se cancelan". 30,07 % de 53.050 reservas (2015–2017). Cada cancelación es una habitación que se revende tarde o queda vacía. Visual: número grande 30,07 % o donut canceladas vs no canceladas. (Fuente: Q1.)

**4 · Método.** Titular: "53.050 reservas · 6 preguntas · SQL sobre DuckDB". Un solo hotel de Lisboa; datos limpios y documentados; análisis por segmento, antelación, depósito, precio (ADR), peticiones especiales y señales de cliente. Énfasis en reproducibilidad: todas las queries en el repo.

**5 · El canal de venta.** Titular: "Online TA cancela el 36 % — y aporta el 79 % de todas las cancelaciones". Barras horizontales por `market_segment`, orden descendente, Online TA en color de acento. Datos: Online TA 36,10 % (n=34.743) · Groups 33,87 % (n=2.619) · Aviation 19,91 % (n=226) · Offline TA/TO 17,35 % · Direct 16,43 % · Corporate 11,86 % · Complementary 10,62 %. Grupos pequeños (Groups, Aviation) no son comparables con los grandes: la base importa. (Fuente: Q4, Q6.)

**6 · La antelación (lead time).** Titular: "Cuanto antes se reserva, más se cancela: del 11 % al 45 %". Relación monotónica por tramo; salto fuerte a partir de 90 días. Datos: 0-7 = 10,51 % · 8-30 = 27,86 % · 31-90 = 33,17 % · 91-180 = 36,72 % · 180+ = 44,87 %. (Fuente: Q3.)

**7 · El giro.** Titular: "El dato que parecía la respuesta: las tarifas Non Refund cancelan el 97 %". Por tipo de depósito, Non Refund cancela el 97,16 % frente al 29 % sin depósito. Datos: Non Refund 97,16 % (n=844) · Refundable 66,67 % (n=15) · No Deposit 28,98 % (n=52.191). (Fuente: Q8.) Se mantiene separada de la slide 8 para construir el contraste.

**8 · La revelación (asociación ≠ causa).** Titular: "No es el depósito: son reservas hechas con ~6 meses de antelación". Las Non Refund tienen una mediana de lead time de 198,5 días (vs 49 del resto) y son 91 % Groups + Offline TA/TO: un grupo auto-seleccionado de larga antelación, no un efecto del depósito. Datos: lead mediana → Non Refund 198,5 d · Refundable 52,0 d · No Deposit 49,0 d. (Fuente: Q9, Q8b.)

**9 · Señal: peticiones especiales.** Titular: "Sin peticiones especiales se cancela casi el doble (38 % vs 22 %)". 0 peticiones → 38,36 % (49 % del volumen y 63 % de las cancelaciones) vs 1+ → 21,99 % (1,74×). (Fuente: Q12.)

**10 · Clímax: el cruce.** Titular: "El perfil de máximo riesgo: Online TA + reserva con >90 días = 45 %". Al combinar las dos señales fuertes la tasa sube a 44,70 %, 3,1× el grupo de menor riesgo (14,37 %). Matriz 2×2 (segmento × lead time), color = cancel rate. Datos: Online TA·>90 = 44,70 % (n=12.122) · Online TA·0-90 = 31,49 % · Resto·>90 = 28,36 % · Resto·0-90 = 14,37 % (n=12.747). (Fuente: Q15.)

**11 · Qué significa para el negocio.** Titular: "Ese único perfil = 23 % de las reservas, pero 34 % de todas las cancelaciones". Actuar solo sobre ese grupo ataca un tercio del problema con menos de un cuarto del volumen. Datos: 12.122 / 53.050 = 22,8 % del volumen · 5.419 / 15.953 = 34,0 % de las cancelaciones. (Fuente: Q15.)

**12 · Recomendaciones.** (1) Confirmación escalonada en Online TA con >90 días (recordatorios a 60 y 30 días). (2) Fomentar el engagement pre-llegada (peticiones, upgrades, check-in online). (3) Garantía diferenciada por riesgo, no un Non Refund universal: el depósito no es causal.

**13 · Próximos pasos.** Test A/B del recordatorio sobre el segmento de riesgo · capturar la fecha de cancelación para separar bajas tempranas de tardías · sumar más años y hoteles para validar el patrón.

**14 · Limitaciones.** Un solo hotel (City Hotel, Lisboa) · 26 meses (jul 2015 – ago 2017), pre-COVID · asociación, no causalidad · Non Refund no evaluable causalmente (selección) · ADR como proxy de precio.

**15 · Apéndice (soporte y reproducibilidad).** Enlace al dashboard de Tableau Public · repo de GitHub · `sql/04_analyze.sql` y `notebooks/03_analyze.ipynb` · señal secundaria: una cancelación previa = 80,35 %, independiente del depósito (Q13b, Q14) · cita del dataset (Antonio, de Almeida & Nunes, 2019; City Hotel = Lisboa).
