# Investigación: Ruta gratuita para productos de IA automatizada (ago-2026)

> Informe técnico-comercial de JeanCRG. Fecha: 13-ago-2026.
> Propósito: justificar con datos de mercado la ruta de costo $0 para la demo y $0-15K COP/mes marginal por cliente en producción.

## Resumen ejecutivo

Se investigó y validó la ruta de implementación más barata y oficial para el núcleo del negocio: asistentes IA de WhatsApp para pymes. La ruta elegida usa exclusivamente piezas oficiales y gratuitas — WhatsApp Cloud API de Meta (conversaciones de servicio gratis, confirmado al 10-ago-2026), n8n Community Edition self-hosted, Gemini API free tier sin tarjeta, Supabase Free y Cloudflare Tunnel — lo que permite construir la demo con costo $0 absoluto y operar el primer cliente con $0 marginal de infraestructura, manteniendo margen 60-80%+ sobre un retainer de $250K COP/mes. El único gasto recurrente aparece en escala (2-4 clientes: VPS compartido ~€8/mes; 5+: Supabase Pro) y siempre DESPUÉS del primer cobro. Esta ruta es la que se documenta en `../docker-compose.yml`, `../workflows/whatsapp-assistant-base.json` y `../supabase/schema.sql`.

## Contexto del negocio JeanCRG

Marca personal de consultoría IA/software (Colombia, Tolima). Meta 2026: $323M COP a 31-dic-2026, con caja de $1.4M COP y 10 prospectos verificados esperando. Productos:

| Código | Producto | Precio |
|---|---|---|
| P0 | Diagnóstico de 2 páginas | $300K (descontable) |
| P1 | Asistente IA WhatsApp | Desde $1.8M + retainer $250K/mes (NÚCLEO) |
| P2 | Automatización n8n | Desde $1.5M |
| P3 | RAG | Desde $2.5M |
| P4 | Tienda | Desde $2.5M |
| P5 | Dev a medida | Desde $3M |
| — | Piloto 15 días | $800K (descontable del precio final) |

Reglas de oro: anticipo >= 40% con hitos 50% firma -> 30% demo funcionando -> 20% entrega; retainer por adelantado; 25% de impuestos; 3 referidos por cierre; SOLO WhatsApp Cloud API oficial (PROHIBIDO: WAHA, Evolution API, whatsapp-web.js, Whapi, Z-API — riesgo de baneo). Garantía: ajustes el primer mes + soporte 30 días. Tenant por cliente (cada cliente = su número/credencial).

Diferencial vendible: 1) datos REALES del negocio, 2) reporte semanal al dueño, 3) derivación a humano con contexto, 4) garantía/montaje+acompañamiento, 5) piloto 15 días que elimina el miedo a comprar.

## Hallazgos de mercado verificados (ago-2026)

Fuentes genéricas: Meta changelog / BSP rate cards / aifreeapi / cloudzero / docs oficiales de cada plataforma.

| Dato | Detalle | Estado |
|---|---|---|
| WhatsApp Cloud API — cobro por mensaje | Desde 1-jul-2025 Meta cobra por mensaje (no por conversación). | CONFIRMADO |
| Conversaciones de servicio gratis | Cliente inicia, se responde dentro de 24h: GRATIS. Verificado al 10-ago-2026. | CONFIRMADO |
| Posible cobro de servicio oct-2026 | Reportes no confirmados de BSP: posible cobro desde 1-oct-2026 (~$0.0008-0.003/msg). Colombia tiene tarifas utility/auth de las más baratas del mundo (~$0.0008). | REPORTADO-NO-CONFIRMADO |
| Marketing | ~$0.025 por mensaje (US). | CONFIRMADO |
| Test number (sandbox) | Gratis para desarrollo y demo. | CONFIRMADO |
| Free Entry Point 72h | Click-to-WhatsApp ads: entrada gratis 72h. | CONFIRMADO |
| Gemini API free tier | Google AI Studio, sin tarjeta. Flash/Flash-Lite gratis. Pro ya NO gratis desde abr-2026. | CONFIRMADO |
| Límites Gemini free | ~10-15 RPM, 250-1,500 RPD según modelo/proyecto. Volátiles: Google los recorta sin aviso. | CONFIRMADO (volátil) |
| Gemini pago | 2.5 Flash-Lite $0.10/$0.40 por M tokens; 2.5 Flash $0.30/$2.50 por M. | CONFIRMADO |
| n8n Community Edition | Self-hosted GRATIS: workflows/ejecuciones ilimitadas, 400+ integraciones, nodos IA. | CONFIRMADO |
| Licencia fair-code n8n | Uso interno para operar clientes = permitido. Incrustar n8n como SaaS vendido a terceros = NO (requiere Business ~$667-800/mes). n8n Cloud $24/mes (2,500 ejecuciones) = NO. | CONFIRMADO |
| Supabase Free | 500MB DB, 50K MAU, 5GB egress, 2 proyectos activos, pgvector incluido, 500K edge functions. | CONFIRMADO |
| Supabase pausa inactividad | Se pausa tras 7 días sin actividad (mitigación: cron ping). Pro $25/mes. | CONFIRMADO |
| Oracle Cloud Always Free | Reducido a 2 OCPU/12GB ARM (enforcement 18-ago-2026). Bans de cuentas gratis comunes. | CONFIRMADO (NO recomendado) |
| Hetzner CX22 | ~€8/mes, compartible entre clientes. Producción recomendada. | CONFIRMADO |
| Cloudflare Tunnel | GRATIS, URL estable (ideal webhook). ngrok free: URL rotatoria (NO sirve para webhooks). | CONFIRMADO |
| DeepSeek V4 Flash | $0.14/$0.28 por M (más barato de pago). Datos viajan a China -> solo clientes sin datos sensibles. | CONFIRMADO |
| Cobros Colombia | Nequi/transferencia 0% para arrancar. Wompi 2.65%+$700 cuando haya tienda P4. | CONFIRMADO |

## La ruta gratuita definitiva

Diagrama completo (demo -> producción):

```
                 DEMO (costo $0)                          PRODUCCIÓN (costo $0-15K COP/mes marginal)

Cliente escribe                                 Cliente escribe
      |                                                |
      v                                                v
WhatsApp Cloud API (gratis ventana 24h)         WhatsApp Cloud API (número REAL del cliente)
      |                                                |
      v                                                v
Cloudflare Tunnel (gratis, URL estable)         Cloudflare Tunnel (gratis) — o dominio propio + named tunnel
      |                                                |
      v                                                v
n8n CE self-hosted (Docker local)               n8n CE self-hosted (Hetzner CX22 ~€8/mes, compartido)
      |                                                |
      v                                                v
IA Gemini free tier (sin tarjeta)               IA Gemini free tier -> pago solo si escala (Flash-Lite $0.10/$0.40 M)
      |                                                |
      v                                                v
Supabase Free (proyecto de demo)                Supabase Free por tenant -> Pro $25/mes solo a partir de ~5 clientes
      |                                                |
      v                                                v
Panel + reporte semanal al dueño                Panel + reporte semanal al dueño (mismo esquema multi-tenant)
```

Misma arquitectura en demo y producción: lo que cambia es DÓNDE corre n8n (local -> nube) y de qué proyecto Supabase lee (demo -> producción). El workflow, el prompt y el schema SQL son idénticos, por eso se vende "montaje en 5-7 días".

## Alojamiento gratuito (verificado ago-2026)

Comparativa de hosts para la demo cloud de n8n (webhook de WhatsApp). Detalle completo y pasos en `docs/DEPLOY-GRATIS.md`.

| Proveedor | Free tier | Tarjeta | Cold starts | Base de datos | Veredicto |
|---|---|---|---|---|---|
| Railway | Trial $5 crédito / 30 días; luego Free $1/mes, Hobby $5/mes | No (trial) | No — servicios siempre calientes | Postgres integrado | PRIMARIO para demo cloud |
| Render | 512MB / 0.1 CPU, 750h/mes | No | Sí — spin-down 15 min (~1 min cold start) | Postgres free expira a los 30 días | Fallback documentado |
| Koyeb | 1 servicio 512MB | No | Sí — scale-to-zero tras 1h | Sin volúmenes; Postgres free 5h activas/mes | Descartado como hosting principal |
| Fly.io | Sin free tier para nuevos usuarios (2024) | — | — | — | Descartado |
| Oracle | Always Free reducido (2 OCPU/12GB, enforcement 18-ago-2026) | — | — | — | Descartado (recortes + bans) |

Decisión: Railway como hosting primario de la demo cloud (sin cold starts, trial sin tarjeta,
Postgres integrado, URL pública con TLS — sin tunnel); Render como fallback documentado (truco
UptimeRobot cada 10 min, pero disco efímero: SQLite de n8n se pierde en redeploy, el workflow se
restaura desde el JSON del repo); local con docker-compose para desarrollo; Hetzner CX22 (~€8/mes)
como camino de producción compartido con 2+ clientes.

Riesgos: Railway tuvo outages en may-2026; el crédito de $5 alcanza ~2-4 semanas de demo (consumo
estimado n8n 512MB + Postgres pequeño ≈ $5/mes). Regla que no cambia: NUNCA pagar infraestructura
antes del primer anticipo.

## Desglose de costos

1 USD ≈ 4,000 COP. Los totales marginales son por cliente/mes.

| Pieza | Costo demo | Costo 1er cliente | Escala 2-4 clientes | Escala 5+ clientes |
|---|---|---|---|---|
| WhatsApp Cloud API (servicio, 24h) | $0 | $0 | $0 | $0 (o $3,200-12,000 COP si aplica el cobro oct-2026, 1K msgs) |
| Test number / número real | $0 | $0 | $0 | $0 |
| n8n CE self-hosted | $0 (local) | $0 (Hetzner compartido) | $0 + fracción VPS | $0 |
| IA Gemini | $0 (free tier) | $0 (free tier) | $0-1,000 COP (pago Flash-Lite, 1K conv/mes) | $400-2,000 COP |
| Supabase | $0 (Free) | $0 (Free) | $0 (Free, 2 proyectos) | $0-100K COP (Pro $25/mes) |
| Cloudflare Tunnel | $0 | $0 | $0 | $0 |
| Infraestructura (Hetzner CX22 ~€8) | $0 | $0 | ~$9-17K COP por cliente (compartido) | ~$9-17K COP |
| Dominio propio (opcional) | $0 | $0 | ~$4K COP/mes prorrateado | ~$4K COP/mes |
| Cobros (Nequi/Wompi) | $0 (Nequi) | $0 (Nequi) | $0 | Wompi 2.65%+$700 solo en P4 |
| **Total marginal** | **$0** | **$0** | **$0-15K COP/mes** | **~$15-30K COP/mes** |

Contraste con el ingreso: P1 desde $1.8M + retainer $250K/mes. Margen operativo 60-80%+ desde el primer cliente.

## Mapa de escalado a pago

Regla absoluta: NUNCA pagar nada antes del primer cliente cobrado. Cada migración se decide por hito de ingresos, no por adelantado.

| Hito | Pieza | Cuándo y cómo migrar |
|---|---|---|
| Primer cliente (anticipo 50% de $1.8M+) | VPS Hetzner CX22 (~€8/mes) | n8n pasa de Docker local a VPS. Un solo VPS compartido aguanta 3-5 clientes. No comprar otro VPS por cliente. |
| 2-4 clientes | Gemini pago | Solo si el free tier deja de dar abasto (RPD recortado por Google). Migrar a API key de pago con límite mensual (Flash-Lite). El diseño multi-LLM permite cambiar solo la URL del nodo HTTP. |
| 5+ clientes | Supabase Pro ($25/mes) | Cuando se superen los 50K MAU o los 2 proyectos activos del Free. Migrar un proyecto multi-tenant consolidado, no uno por cliente. |
| Cualquier cliente con marca seria | Dominio propio + named tunnel | El cliente pide URL con su marca. Comprar dominio (~$12/año) y cambiar `cloudflared` de quick tunnel a named tunnel. Costo lo absorbe el retainer. |
| P4 (tienda) en firma | Wompi 2.65%+$700 | Solo cuando se vende la tienda; mientras tanto Nequi 0%. |
| Si el cobro de servicio de WhatsApp entra (oct-2026) | Tarifas utility/auth | No es decisión de migración: es el costo oficial de la plataforma. Con tarifas de Colombia (~$0.0008/msg) y 1K mensajes/mes, son $3,200 COP — irrelevante frente al retainer. Se traslada a la propuesta como "costos de plataforma". |

## Riesgos y mitigaciones

1. **Cobro de servicio WhatsApp desde 1-oct-2026 (reportado, no confirmado)**. Si aplica, las conversaciones de servicio pasarían a cobrar ~$0.0008-0.003/msg. Mitigación: (a) el costo real en Colombia es mínimo ($3-12K COP por 1K mensajes); (b) monitorear el changelog de Meta y los rate cards de BSP cada mes; (c) la propuesta comercial menciona que los costos de plataforma corren por cuenta del cliente si exceden un umbral pactado.

2. **Gemini free tier volátil (límites recortados sin aviso)**. Mitigación estructural: diseño multi-LLM. El workflow llama al modelo por URL configurable (`GEMINI_API_KEY` y el modelo son un nodo HTTP estándar); cambiar de Gemini a DeepSeek o Claude implica editar una URL, no rediseñar el flujo. DeepSeek V4 Flash ($0.14/$0.28 M) es el respaldo de pago más barato, solo para clientes sin datos sensibles.

3. **Bans de Oracle Cloud Always Free (enforcement 18-ago-2026)**. Mitigación: NO se usa Oracle para producción de clientes. La infraestructura de producción es Hetzner CX22 (~€8/mes), con política de bans mucho más predecible, y solo se contrata después del primer anticipo.

4. **Licencia fair-code de n8n** (incrustar n8n como SaaS vendido a terceros = prohibido; usar n8n internamente para operar clientes = permitido). Mitigación: el modelo de negocio es "asistente como servicio" donde n8n es herramienta interna del operador (JeanCRG). Prohibido ofrecer "n8n como producto" al cliente. Si algún día se quisiera revender n8n embebido, Business (~$667-800/mes) solo después de validar ingreso recurrente que lo justifique.

## Recomendaciones de seguridad

- **Service keys nunca en el cliente**: la SUPABASE_SERVICE_KEY vive solo en el `.env` del servidor de n8n (backend). El panel del cliente, si se construye, usa la anon key + RLS con policies por `tenant_id`.
- **RLS por tenant**: en la demo se usa service role desde n8n (simple). En producción con panel, activar Row Level Security y policies `tenant_id = auth.uid()` o el id del tenant del token.
- **`.env` fuera de git**: ya cubierto por `.gitignore`. Nunca versionar credenciales.
- **Rotación de tokens**: el WHATSAPP_ACCESS_TOKEN temporal de Meta se renueva periódicamente; usar token permanente con rotación programada para producción.
- **Data retention**: definir con el cliente cuánto se conservan conversaciones (sugerencia: 90 días) y purgar con un cron. Los datos personales de los clientes del cliente nunca se comparten entre tenants ni se usan fuera del contrato.
- **N8N_ENCRYPTION_KEY**: respaldarla; si se pierde, se pierden todas las credenciales guardadas en n8n.
- **Registro y auditoría**: `derivado_a_humano`, `metadata` jsonb y timestamps en todas las tablas permiten auditar qué hizo la IA.

## Conclusión

La ruta gratuita cumple las cuatro exigencias del negocio: (1) **$0** — demo sin inversión y primer cliente con costo marginal cero, eliminando el riesgo financiero de la caja de $1.4M COP; (2) **escalable** — cada pieza tiene una migración a pago conocida y barata, disparada por ingresos y nunca por adelantado; (3) **oficial** — solo WhatsApp Cloud API de Meta, cero riesgo de baneo; (4) **margen 60-80%+** — retainer $250K COP/mes contra $0-15K COP/mes de costo marginal. La arquitectura demo=producción convierte el "piloto 15 días" en un vendible real: lo que el cliente ve en la demo es exactamente lo que recibe.
