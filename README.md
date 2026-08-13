# chatAI — Sistema vendible de asistentes IA para WhatsApp (JeanCRG)

> Sistema que SE VENDE: asistente IA de WhatsApp para pymes del Tolima.
> Plan maestro: `docs/PLAN-MAESTRO.md` · Ruta de costos: `docs/investigacion-ruta-gratuita.md` · Precios y hitos: `docs/entrega-checklist.md` · Despliegue gratuito: `docs/DEPLOY-GRATIS.md`.
> Estado: 13-ago-2026 — base técnica F1 + seguridad completadas; hosting demo cloud: Railway trial (30 días, sin tarjeta).

## Arquitectura (ruta gratuita, costo demo $0)

```
Cliente escribe → WhatsApp Cloud API (Meta oficial, GRATIS en ventana 24h)
  → Cloudflare Tunnel (dev local; en la nube: URL pública del servicio con TLS)
  → n8n Community self-hosted (Docker local dev / Railway demo cloud / Hetzner producción)
  → IA Gemini free tier (sin tarjeta; multi-LLM: DeepSeek/Claude cambiando la URL)
  → Supabase Free (contactos, conversaciones, leads, citas) + panel + reporte semanal
  → Respuesta al cliente
```

- **Costo marginal producción: $0-15K COP/mes por cliente** vs retainer $250K+ → margen 60-80%.
- **Regla: NUNCA pagar infraestructura antes del primer anticipo.** Migraciones a pago en
  `docs/investigacion-ruta-gratuita.md`.
- **PROHIBIDO**: rutas no oficiales de WhatsApp (WAHA, Evolution API, whatsapp-web.js, Whapi,
  Z-API) = riesgo de baneo. Solo Cloud API oficial.
- **Tenant por cliente**: cada cliente = su número/credencial en Supabase (sin esto no hay retainer
  escalable). Esquema multi-tenant en `supabase/schema.sql`.

## Estado (13-ago-2026) — base técnica F1 + seguridad completadas

- [x] Workflow n8n base (`workflows/whatsapp-assistant-base.json`): webhook Meta → Supabase →
      Gemini → respuesta, con derivación a humano por Telegram.
- [x] Workflow endurecido (13-ago): verificación de firma HMAC de Meta, validación de entrada y
      loop prevention, Gemini key por header (`x-goog-api-key`).
- [x] Decisión de hosting demo cloud (13-ago): Railway trial 30 días sin tarjeta (sin cold starts);
      fallback Render documentado. Guía completa en `docs/DEPLOY-GRATIS.md`.
- [x] Seguridad F1 (13-ago): RLS habilitado en Supabase, basic auth del editor n8n, secrets solo
      por variables de entorno.
- [x] Esquema multi-tenant (`supabase/schema.sql`): tenants, contactos, conversaciones, leads,
      citas + seed demo.
- [x] Prompt maestro v2 (`prompts/prompt-maestro-v2.md`): contrato de salida `[DERIVAR]` /
      `[LEAD ...]` + bloque por vertical + checklist por cliente.
- [x] Infraestructura local (`docker-compose.yml` + `.env.example`): n8n + Postgres + Cloudflare
      Tunnel.
- [x] Kit de venta (`venta/`): propuesta, contrato, diagnóstico 2 páginas, reporte semanal, demo
      script.
- [x] Informe de ruta gratuita (`docs/investigacion-ruta-gratuita.md`) con datos de mercado
      verificados (ago-2026).
- [ ] Pendiente: levantar demo end-to-end (13-14 ago), demo grabada 2 min, primeros 3 pilotos
      ofertados.

## Estructura del repo

```
chatAI/
├── README.md                      # este archivo
├── Dockerfile                     # image deploy en Railway/Render (dev local usa docker-compose)
├── docker-compose.yml             # n8n + postgres + cloudflared (dev local)
├── .env.example                   # variables de entorno (copiar a .env, nunca versionar)
├── docs/
│   ├── DEPLOY-GRATIS.md           # guía de despliegue gratuito: Railway + fallbacks + seguridad
│   ├── entrega-checklist.md       # hitos de cobro 50/30/20 y checklist D1-D7
│   ├── investigacion-ruta-gratuita.md  # informe con datos de mercado y costos
│   └── PLAN-MAESTRO.md            # 6 fases de construcción y venta
├── prompts/
│   ├── prompt-maestro.md          # v1 (borrador, conservado)
│   └── prompt-maestro-v2.md       # v2: contrato de salida + verticales
├── supabase/
│   └── schema.sql                 # esquema multi-tenant (aplicar en Supabase)
├── venta/
│   ├── propuesta.md               # plantilla de propuesta comercial
│   ├── contrato.md                # plantilla de contrato de servicios
│   ├── diagnostico-2paginas.md    # entregable P0 ($300K descontable)
│   ├── reporte-semanal.md         # plantilla del reporte al dueño
│   └── demo-script.md             # guion de demo 2 min (Loom/OBS)
└── workflows/
    └── whatsapp-assistant-base.json   # workflow n8n importable
```

## Cómo arrancar (3 rutas)

### Ruta 1 — Local (dev) — docker compose

1. **Variables**: `cp .env.example .env` y completar (ver comentarios del archivo:
   `openssl rand -hex 16` para POSTGRES_PASSWORD y N8N_ENCRYPTION_KEY).
2. **Levantar la pila**: `docker compose up -d` → n8n en `http://localhost:5678`.
3. **Supabase**: crear proyecto gratis, aplicar `supabase/schema.sql` en el SQL editor y copiar
   URL + Service Role Key al `.env` (la key SOLO vive en backend).
4. **Túnel**: `docker compose logs -f cloudflared` → copiar la URL pública
   (`https://xxx.trycloudflare.com`). Para producción con dominio propio, ver el comentario YAML
   en el servicio `cloudflared` del compose.
5. **Meta**: crear app en Meta for Developers → test number → webhook apuntando a
   `<URL_TUNEL>/whatsapp` con token de verificación propio.
6. **Workflow**: en n8n, importar `workflows/whatsapp-assistant-base.json`, setear las 4
   credenciales (Supabase, WhatsApp Business Cloud, Telegram, Gemini) y activarlo.
7. **Verificar**: (a) GET a `<URL_TUNEL>/whatsapp` con `hub.challenge` responde el token;
   (b) enviar un WhatsApp al test number y ver la ejecución en n8n; (c) confirmar la fila en
   Supabase (tabla `conversaciones`).

### Ruta 2 — Demo cloud 30 días — Railway (sin tarjeta)

Guía paso a paso en `docs/DEPLOY-GRATIS.md`: cuenta con GitHub → proyecto con la imagen
`n8nio/n8n` + Postgres → variables de entorno → dominio `*.up.railway.app` con TLS (sin tunnel) →
basic auth del editor → importar el workflow → credenciales → webhook de Meta (con verificación de
firma HMAC en producción) → pruebas end-to-end. Trial: $5 de crédito por 30 días sin tarjeta.

### Ruta 3 — Producción — Hetzner

Al primer anticipo: n8n en Hetzner CX22 (~€8/mes, compartido 3-5 clientes). Migración disparada
por ingresos, nunca antes (regla y mapa en `docs/investigacion-ruta-gratuita.md`).

## Seguridad (checklist)

Checklist completo con el detalle de cada medida en `docs/DEPLOY-GRATIS.md` (sección "Medidas de
seguridad"). Resumen:

1. Verificación de firma del webhook de Meta (HMAC-SHA256 con `META_APP_SECRET`, activa con
   `WEBHOOK_VERIFY_SIGNATURE=true`).
2. Validación de entrada: loop prevention (ignora el propio número), solo texto, máximo 2000
   caracteres.
3. Secretos solo en variables de entorno: `.env` excluido de git, `N8N_ENCRYPTION_KEY` obligatoria
   y respaldada.
4. Editor de n8n protegido con basic auth (`N8N_BASIC_AUTH_*`) + `N8N_SECURE_COOKIE=true` detrás
   de HTTPS.
5. Supabase: RLS habilitado, service key solo en el backend de n8n, aislamiento por `tenant_id`.
6. Gemini: API key vía header `x-goog-api-key`, nunca en la URL ni en logs.
7. HTTPS en todos los extremos (TLS de Railway/Render / cloudflared en local).
8. Mitigación de prompt injection: marcadores de salida y reglas estrictas del prompt maestro v2
   (`prompts/prompt-maestro-v2.md`).
9. Retención mínima de datos: PII solo teléfono/nombre; borrado a petición del cliente.
10. Auditoría: ejecuciones en n8n + timestamps y `metadata` en Supabase.

## DIFERENCIAL CLARO (lo que la competencia NO da — se vende con esto)

1. **Datos reales del negocio**: el asistente responde con LAS preguntas y precios reales del
   cliente, no un bot genérico.
2. **Reporte semanal de conversaciones** al dueño (qué preguntan, cuántas ventas respondió, qué se
   escapó a humano) — las agencias baratas solo "montan".
3. **Derivación inteligente a humano** con contexto (el dueño ve la conversación completa, no
   mensajes sueltos).
4. **Garantía de servicio**: ajustes incluidos el primer mes + soporte 30 días ("montaje +
   acompañamiento").
5. **Piloto de 15 días por $800K** (se descuenta) — elimina el miedo a comprar.

## Rutas de escalado (resumen)

| Hito | Migración |
|---|---|
| Primer anticipo | n8n local/Railway → Hetzner CX22 (~€8/mes, compartido 3-5 clientes) |
| 2-4 clientes | Gemini free → pago solo si el free tier no da abasto (multi-LLM: cambiar URL) |
| 5+ clientes | Supabase Free → Pro ($25/mes, proyecto multi-tenant consolidado) |
| Cliente con marca | Dominio propio + named tunnel (el retainer lo absorbe) |

Regla: cada migración se dispara por ingresos, nunca por adelantado. Detalle completo en
`docs/investigacion-ruta-gratuita.md`.

## Reglas de oro

- **Nunca construir el sistema completo sin cliente**: la demo sale en 48h; el sistema completo se
  paga con el anticipo del primer cliente.
- Hitos: 50% firma → 30% demo funcionando → 20% entrega (anticipo >= 40%).
- Retainer mensual por adelantado. 25% de impuestos reservado. 3 referidos por cierre.
- Piloto $800K o diagnóstico $300K = puertas de entrada (se descuentan).
- Cada 3-4 proyectos → productizar un módulo más (regla de patrimonio).

## Enlaces

- Plan maestro: `docs/PLAN-MAESTRO.md` (6 fases, F1 en curso)
- Informe de ruta gratuita: `docs/investigacion-ruta-gratuita.md`
- Despliegue gratuito (Railway + fallbacks): `docs/DEPLOY-GRATIS.md`
- Checklist de entrega y cobro: `docs/entrega-checklist.md`
- Prompt maestro v2: `prompts/prompt-maestro-v2.md`
- Kit de venta: `venta/`
