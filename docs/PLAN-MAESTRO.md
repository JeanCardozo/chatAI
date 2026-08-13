# Plan Maestro JeanCRG — Plantillas de productos (v2, 13-ago-2026)

> Plan de construcción y venta de la línea de productos de IA automatizada (P0-P5).
> Objetivo de negocio: $323M COP a 31-dic-2026. Caja actual: $1.4M COP. 10 prospectos verificados esperando.
> Regla rectora: NUNCA pagar infraestructura antes del primer anticipo. Demo $0, producción $0-15K COP/mes marginal.

## Resumen de fases

| Fase | Nombre | Fechas | Objetivo | Estado |
|---|---|---|---|---|
| F1 | Núcleo vendible P1 | 12-14 ago | Base técnica del asistente IA listo para demo y venta | BASE TÉCNICA + SEGURIDAD COMPLETADAS (13-ago-2026): workflow endurecido con firma Meta, decisión de hosting Railway, guía de deploy docs/DEPLOY-GRATIS.md, RLS en Supabase |
| F2 | Kit de cierre | 14-16 ago | Material de venta y contratos para convertir los 10 prospectos | Pendiente |
| F3 | Verticalización | 17-23 ago | Prompt y demo por vertical (comercio, salud, restaurantes, etc.) | Pendiente |
| F4 | Multiplicación P2-P5 | 24 ago-6 sep | Automatización n8n, RAG, tienda, dev a medida como plantillas | Pendiente |
| F5 | Productización multi-tenant | 7-20 sep | Panel multi-cliente, onboarding, retainer escalable | Pendiente |
| F6 | Patrimonio | 21 sep+ | Ancla: checkpoint $80M acumulado al 30-sep | Pendiente |

## F1 — Núcleo vendible P1 (12-14 ago) — BASE TÉCNICA + SEGURIDAD COMPLETADAS (13-ago)

Objetivo: tener el sistema completo del asistente IA de WhatsApp funcionando como plantilla: un solo workflow, un solo prompt, un esquema multi-tenant, y la demo grabada para vender.

Entregables:
- [x] Repo git chatAI inicializado con `.gitignore` (13-ago)
- [x] Workflow n8n base `workflows/whatsapp-assistant-base.json` (13-ago)
- [x] Esquema multi-tenant `supabase/schema.sql` (13-ago)
- [x] Prompt maestro v2 con contrato de salida y verticales `prompts/prompt-maestro-v2.md` (13-ago)
- [x] Infraestructura local `docker-compose.yml` + `.env.example` (13-ago)
- [x] Informe de ruta gratuita `docs/investigacion-ruta-gratuita.md` (13-ago)
- [x] Plan maestro v2 `docs/PLAN-MAESTRO.md` (13-ago)
- [x] Guía de despliegue gratuito `docs/DEPLOY-GRATIS.md` + `Dockerfile` (13-ago)
- [x] Seguridad F1: firma webhook Meta, basic auth n8n, RLS Supabase, secrets por env (13-ago)
- [ ] Kit de venta `venta/` (propuesta, contrato, diagnóstico, reporte semanal, demo script) (14-ago)
- [ ] README actualizado con arranque de demo (13-ago)
- [ ] Levantar demo local: docker compose up + .env + importar workflow + verificar webhook (13-14 ago)
- [ ] Credenciales n8n seteadas: Supabase, WhatsApp, Telegram, Gemini (13-14 ago)
- [ ] Prueba end-to-end: 10 preguntas reales (14-ago)
- [ ] Demo grabada 2 min con Loom/OBS (14-ago)
- [ ] 3 pilotos 15 días ofertados (14-ago)

Checklist de tareas:
- [x] Seguridad: firma webhook, basic auth n8n, RLS Supabase, secrets por env (DONE 13-ago)
- [ ] Crear proyecto Supabase (gratis) y aplicar `supabase/schema.sql`
- [ ] Crear app en Meta for Developers + test number + webhook apuntando al tunnel
- [ ] Configurar `cloudflared` quick tunnel para el webhook
- [ ] Importar workflow en n8n y conectar las 4 credenciales
- [ ] Pedir a cada prospecto sus 10 FAQs reales (semilla del prompt)

## F2 — Kit de cierre (14-16 ago)

Objetivo: que un prospecto pase de "me interesa" a "firmó y pagó anticipo" en menos de 72h, con materiales que el dueño pueda leer solo.

Entregables:
- [ ] Propuesta comercial plantilla `venta/propuesta.md` completa por prospecto
- [ ] Contrato de servicios `venta/contrato.md` revisado (50/30/20 + retainer adelantado)
- [ ] Diagnóstico P0 de 2 páginas ofertado a los 10 prospectos ($300K descontable)
- [ ] Secuencia de seguimiento: toque 2 (variante emocional) + llamada + demo con SUS preguntas (<=48h) + propuesta (<=48h) + cierre anticipo 50%
- [ ] 3 referidos pedidos por cierre (regla del sistema de ventas)

Checklist de tareas:
- [ ] Llenar propuesta con datos reales de los 3 prospectos prioritarios
- [ ] Fijar horarios de demo con los 10 prospectos verificados
- [ ] Definir los [CORCHETES] de contrato y propuesta con el cliente antes de enviar

## F3 — Verticalización (17-23 ago)

Objetivo: tener la versión especializada del prompt y de la demo por vertical, para que la demo hable el idioma del negocio del prospecto desde el segundo 1.

Entregables:
- [ ] Bloque VERTICAL del prompt pulido por vertical (comercio/retail, salud/odontología, restaurantes, servicios técnicos, gimnasios/fitness, ferretería/construcción)
- [ ] 6 demos de 2 min (una por vertical) o 1 demo genérica con 2 ejemplos por vertical
- [ ] FAQ banco por vertical (10 preguntas reales tipo DENTOMAN/LD_STOROS)
- [ ] Reglas de cumplimiento por vertical (salud: jamás diagnosticar; restaurantes: pedidos y domicilio; etc.)

Checklist de tareas:
- [ ] Elegir vertical con más prospectos del listado actual y priorizarla
- [ ] Conseguir 1 caso real por vertical para el banco de FAQs

## F4 — Multiplicación P2-P5 (24 ago-6 sep)

Objetivo: convertir el resto de la línea de productos en plantillas reutilizables con la misma disciplina de F1 (workflow + prompt + schema + kit).

Entregables:
- [ ] P2 Automatización n8n (desde $1.5M): plantilla de flujos de negocio (notificaciones, formularios, CRMs)
- [ ] P3 RAG (desde $2.5M): esquema pgvector en Supabase + workflow de embeddings + chunking
- [ ] P4 Tienda (desde $2.5M): catálogo en Supabase + cobro Wompi 2.65%+$700 + flujo de pedido
- [ ] P5 Dev a medida (desde $3M): cotización estándar + alcance por fases
- [ ] Casos de upsell documentados: cada cliente P1 es candidato a P2-P4

Checklist de tareas:
- [ ] Definir qué módulos de P2-P5 comparten el esquema de F1 (contactos, conversaciones, leads)
- [ ] Estimar tiempos de entrega por plantilla (demo 48h, entrega 5-7 días)

## F5 — Productización multi-tenant (7-20 sep)

Objetivo: operar varios clientes con el mismo sistema, con panel propio y sin trabajo manual por cliente.

Entregables:
- [ ] Panel del cliente (vista por tenant: conversaciones, leads, citas) con RLS por tenant_id
- [ ] Reporte semanal automatizado por tenant (tablas de Supabase -> PDF/WhatsApp al dueño)
- [ ] Onboarding estandarizado: checklist D1-D7 de `docs/entrega-checklist.md`
- [ ] Retainer escalable: migración de Gemini free -> pago, Supabase Free -> Pro (reglas de `docs/investigacion-ruta-gratuita.md`)
- [ ] Cron ping anti-pausa de Supabase Free (7 días sin actividad)

Checklist de tareas:
- [ ] Definir precio del panel/reporting si se cobra aparte del retainer
- [ ] Automatizar el primer reporte semanal real

## F6 — Patrimonio (21 sep+)

Objetivo: convertir ingresos operativos en activos: plantillas, contenido, comunidad y recurrencia.

- [ ] Checkpoint $80M COP acumulado al 30-sep (ancla del plan)
- [ ] Curso/guía vendible de "asistente IA para pymes" (patrimonio intelectual)
- [ ] Contenido semanal de marca personal (demostraciones, casos, resultados)
- [ ] Programa de referidos sistematizado (3 por cierre)
- [ ] Revisión trimestral: productizar un módulo más cada 3-4 proyectos (regla de patrimonio)

## Reglas de oro (aplican a todas las fases)

- Anticipo >= 40%. Hitos: 50% firma -> 30% demo funcionando -> 20% entrega.
- Retainer mensual por adelantado.
- 25% de impuestos reservado de cada ingreso.
- 3 referidos pedidos en cada cierre.
- SOLO WhatsApp Cloud API oficial (PROHIBIDO: WAHA, Evolution API, whatsapp-web.js, Whapi, Z-API).
- Garantía: ajustes el primer mes + soporte 30 días.
- Tenant por cliente: cada cliente = su número/credencial. Sin esto no hay retainer escalable.
- Piloto 15 días $800K y diagnóstico $300K son descontables del precio final.
- NUNCA pagar infraestructura antes del primer anticipo.

## Gaps cerrados en v2 vs v1

- v1: sin repo git -> v2: repo inicializado con `.gitignore` (se excluyen `.env`, credenciales).
- v1: sin workflow -> v2: `workflows/whatsapp-assistant-base.json` (webhook Meta -> Supabase -> Gemini -> WhatsApp, con derivación a humano por Telegram).
- v1: sin esquema -> v2: `supabase/schema.sql` multi-tenant (tenants, contactos, conversaciones, leads, citas) con RLS por tenant documentada.
- v1: prompt sin contrato de salida -> v2: `prompts/prompt-maestro-v2.md` con marcadores `[DERIVAR]` y `[LEAD ...]` legibles por máquina.
- v1: sin kit de venta -> v2: `venta/` con propuesta, contrato, diagnóstico, reporte semanal y demo script (F2).
- v1: decisiones de costo sin datos -> v2: `docs/investigacion-ruta-gratuita.md` con datos de mercado verificados (ago-2026) y mapa de escalado a pago.
