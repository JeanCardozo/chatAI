# PLAN MAESTRO COMPETITIVO — JeanCRG
**Fecha:** 2026-08-14 · **Objetivo:** primer cliente HOY · **Estado del sistema:** pipeline funcional + prompt interactivo + alerta de leads activa

---

## 1. Mapa competitivo (investigación verificada, ago-2026)

### SaaS internacionales (self-serve, venden suscripción)
| Competidor | Precio | Modelo | Cómo venden | Ángulo principal |
|---|---|---|---|---|
| **WhatChimp** | US$12–40/mes (anual, -40%); Enterprise US$600+ | SaaS sobre Cloud API oficial, **0% markup** | Ads FB en español + landing countdown "precio fundador de por vida" + trial 7 días + Trustpilot | **"Sin baneo, API oficial, riesgo cero"** |
| **WATI** | US$49–349/mes + asientos | SaaS por asiento | Self-serve + demo, trial 7 días | CRM + chatbot pymes |
| **AiSensy** | Gratis (API) / US$18–42+/mes | Freemium, regala la API | Self-serve, créditos Meta ads | Marketing masivo + blue tick |
| **Interakt** | US$23–63/mes | SaaS trimestral | Trial + asistido | E-commerce/D2C |
| **Zoko** | US$50–500/mes + AI US$25/agente | SaaS e-commerce | Self-serve + calculadora | Shopify |
| **Twilio/360dialog** | Por uso, ~US$0.005–0.011/conversación | API developer-first | Self-serve | Infraestructura |

### Agencias locales (Colombia)
- **Consolidación Digital (Bogotá):** bot reglas US$300–800 único · IA conversacional **US$1.500–4.000** · agente autónomo US$5.000+. Capta por **SEO en español** ("cuánto cuesta chatbot whatsapp").
- **Cosas Inteligentes (Bogotá):** a cotizar · diagnóstico pago US$200 · **funnel: diagnóstico 20 min gratis → propuesta PDF 72h → WhatsApp (<1 min)** · demo de IA en vivo.
- **Freelancers (TikTok/IG):** US$50–100/mes — presión de precio en pymes, mala calidad.

### Qué vende cada uno (resumen)
- SaaS: software + templates + marketing masivo + inbox. Venden **la herramienta**, el cliente configura.
- Agencias: proyecto llave en mano + mantenimiento. Venden **el resultado**.
- Freelancers: bot genérico barato. Venden **precio**.
- **Nosotros hoy:** llave en mano en 5 días + IA + datos propios + derivación + reporte. Nadie más ofrece montaje en 5 días con IA en el rango de precio.

---

## 2. Distilación — qué ABSORBEMOS (10 tácticas)

1. **Ángulo #1 de venta (WhatChimp):** "sin riesgo de baneo — API oficial de Meta". Abrir TODO mensaje comercial con este claim.
2. **Funnel de Cosas Inteligentes:** diagnóstico 20 min → propuesta PDF de 2 páginas en 72h → CTA directo a WhatsApp. Nada de formularios largos.
3. **Demo viva en el WhatsApp real del prospecto** (su "llamada de prueba gratis"): el bot responde ANTES de la llamada. Ya lo tenemos funcionando.
4. **Precio de anclaje:** subir lista a $2.800.000–3.200.000; el piloto $800K pasa a ser "descuento de lanzamiento", no el producto.
5. **Probar con métricas:** reporte de 15 días con horas ahorradas + leads capturados (los locales prometen ROI, pocos lo miden).
6. **Migración gratis** desde WATI/Interakt/Zoko ("¿Ya usas una plataforma? Te migramos sin costo").
7. **FAQ anti-baneo y legitimidad Meta** como cierre de objeción (estructura de WhatChimp).
8. **SEO en español:** artículo "cuánto cuesta un chatbot de WhatsApp en Colombia" (canal #1 de Consolidación Digital).
9. **Click-to-WhatsApp ads:** las conversaciones de servicio son gratis 24h — el modelo de Meta nos favorece.
10. **Verticales:** cobrar más por nicho (restaurantes, clínicas, talleres, tiendas) — SaaS son genéricos, nosotros no.

---

## 3. Nuestro sistema HOY (conectado)

| Pieza | Estado |
|---|---|
| Pipeline WhatsApp (webhook → contacto → historial → Gemini → conversaciones → respuesta) | ✅ Activo |
| Prompt interactivo (emojis, formato WhatsApp, reglas [LEAD]/[DERIVAR]/[STOP]) | ✅ Activo |
| Captura de leads en Supabase | ✅ Activo |
| Notificación condicional Telegram ([DERIVAR] y leads nuevos cada 15 min) | ✅ Activo (workflow `Alerta Seguimiento JeanCRG`) |
| Retry automático Gemini (rate-limit free tier) | ✅ Activo |
| Token WhatsApp verde (quality GREEN) | ✅ |

**Flujo del día:** prospecto responde → bot lo atiende (2-3 frases, pregunta al final) → si pide cita/propuesta → `leads` en Supabase → **alerta Telegram a Jean en ≤15 min** → Jean contesta el WhatsApp en persona → cierre.

---

## 4. PLAN DE HOY — viernes 2026-08-14

### 09:00–09:30 — Verificar bot (prueba de 5 mensajes con tu WhatsApp)
1. `Hola` → presentación con emojis y servicios
2. `Cuánto cuesta el asistente?` → $1.8M + retainer, 2-3 frases, pregunta al final
3. `Quiero agendar una cita` → **verificar fila en Supabase `leads`** + alerta Telegram ≤15 min
4. `Esto no me convence` → alerta Telegram [DERIVAR] (solo aquí)
5. `STOP` → confirma baja

### 09:30–10:00 — Grabar demo de 2 min (Loom gratis)
Guion en `venta/demo-script.md`. **Usar TU WhatsApp real** (ya funciona). Estructura: 1) qué ves (tu negocio contestando 24/7), 2) pregunta de precio → respuesta con emojis, 3) pide cita → lead capturado, 4) cierre: "esto estuvo listo en 5 días, sin banear tu número, API oficial de Meta".

### 10:00–11:00 — Personalizar + preparar envío
- Personalizar `SYSTEM_PROMPT` del primer prospecto (o crear copia del workflow por cliente cuando sea de pago).
- Mensaje de apertura individualizado por prospecto (script abajo), máximo 3 líneas + demo de 2 min + CTA "¿te muestro cómo quedaría en TU negocio?".

### 11:00–13:00 — Enviar los 10 mensajes de apertura
- WhatsApp directo (no masivo): uno por uno, con nombre y sector del negocio.
- Prioridad: primero los 2-3 que ya hablaron contigo o referidos.

### 13:00–18:00 — Cerrar conversaciones (regla de oro)
- **Responder en <5 min** toda respuesta (el sistema te avisa de leads nuevos).
- Cuando alguien muestre interés → **demo viva inmediata**: "te envío el video de 2 min y si quieres te lo muestro en vivo en tu WhatsApp".
- Agenda diagnóstico 20 min → propuesta PDF 72h → piloto $800K descontable.
- **Meta del día:** 3 demos agendadas, 1 cierre (pago de arranque o piloto).

### 18:00 — Revisión + siguiente movimiento
- Revisar qué ángulo funcionó (anotar respuestas por prospecto en `venta/`).
- Si no hay cierre: seguimiento mañana 09:00 con los que abrieron (regla: 1 follow-up por día máximo).

---

## 5. Mensajes de apertura (copiar y personalizar)

### Versión comercio/tienda:
> Hola [NOMBRE] 👋 Soy Jean, de JeanCRG. Vi que [TIENDA] maneja pedidos y consultas por WhatsApp y quería mostrarte algo: un asistente con IA que responde a tus clientes 24/7, agenda y capta pedidos, montado en 5 días con la API oficial de Meta (cero riesgo de baneo). Te dejo una demo de 2 min: [LINK]. ¿Te muestro cómo quedaría en tu negocio?

### Versión servicios (clínica/asesoría/taller):
> Hola [NOMBRE] 👋 Soy Jean, de JeanCRG. Vi que [NEGOCIO] recibe muchas consultas por WhatsApp — ¿cuánto tiempo pierden respondiendo las mismas preguntas? Un asistente IA contesta al instante, agenda citas y deriva a tu equipo cuando hace falta. Montaje en 5 días, API oficial de Meta. ¿Te envío una demo de 2 min? [LINK]

### Apertura para los 10 prospectos (lista de PLAN-MAESTRO.md)
| # | Prospecto | Sector | Variante |
|---|---|---|---|
| 1–3 | Los que ya conocen el proyecto | — | Demo + "¿arrancamos con el piloto?" |
| 4–10 | Fríos del mapa | Según sector | Script comercio/servicios |

---

## 6. Posicionamiento de venta (respuestas a objeciones)

- **"Es caro"** → vs SaaS: "WATI/AiSensy te cobran US$20-70/mes + markup por conversación y TÚ configuras todo; nosotros te lo dejamos listo con IA y datos de tu negocio. Y tienes el piloto de 15 días por $800K, descontable."
- **"¿Me van a banear?"** → "Es la API oficial de Meta (WhatsApp Business Cloud API), la misma que usan las grandes marcas. Sin bots masivos, sin riesgos."
- **"¿Cuánto tarda?"** → "5 días, llave en mano. Las agencias locales tardan 3-6 semanas."
- **"¿Y si no funciona?"** → "Piloto de 15 días con reporte de métricas (chats atendidos, leads capturados, horas ahorradas). Si no ves valor, no continúas."

---

## 7. Métricas del día
- [ ] Bot verificado con 5 mensajes
- [ ] Demo grabada (link Loom)
- [ ] 10 mensajes enviados
- [ ] Respuestas <5 min en todos
- [ ] 3 demos agendadas / 1 cierre
- [ ] Aprendizajes registrados en `venta/`
