# Despliegue gratuito: Railway (demo 30 días) + fallbacks

> Guía de despliegue en la nube para la demo del asistente IA de WhatsApp (P1).
> Fecha: 13-ago-2026. Precios y límites verificados en ago-2026 (ver `investigacion-ruta-gratuita.md`).

## Decisión resumida

Railway es el hosting primario de la demo cloud porque sus servicios NO tienen cold starts: el
webhook de WhatsApp debe responder en segundos, y un spin-down de 15 minutos rompería la atención
al cliente. El trial otorga $5 de crédito por 30 días SIN tarjeta, suficiente para ~2-4 semanas de
demo (consumo estimado: n8n 512MB + Postgres pequeño ≈ $5/mes juntos, el trial lo cubre). Después
del trial, el plan Free ($1/mes) o Hobby ($5/mes) mantienen la demo viva hasta el primer cliente.

| Proveedor | Free tier | Tarjeta | Cold starts | Base de datos | Veredicto |
|---|---|---|---|---|---|
| Railway | Trial $5 crédito / 30 días; luego Free $1/mes, Hobby $5/mes | No (trial) | No — servicios siempre calientes | Postgres integrado | PRIMARIO para la demo cloud |
| Render | 512MB / 0.1 CPU, 750h/mes | No | Sí — spin-down tras 15 min sin tráfico (~1 min cold start) | Postgres free expira a los 30 días | Fallback documentado |
| Koyeb | 1 servicio 512MB | No | Sí — scale-to-zero tras 1h | Sin volúmenes; Postgres free solo 5h activas/mes | Descartado como hosting principal |
| Fly.io | Sin free tier para usuarios nuevos (2024) | — | — | — | Descartado |
| Oracle | Always Free reducido (2 OCPU/12GB, enforcement 18-ago-2026) | — | — | — | Descartado (recortes ago-2026 + bans) |

Riesgo conocido: Railway tuvo outages en may-2026. Mitigación: el workflow se restaura en cualquier
momento desde `workflows/whatsapp-assistant-base.json` y Render queda documentado como fallback.

## Paso a paso: Railway

### 1. Cuenta

- Crear cuenta con GitHub en https://railway.app (el trial NO pide tarjeta).
- El trial otorga $5 de crédito por 30 días. El plan Free ($1/mes) o Hobby ($5/mes) se activan
  cuando se agote el crédito y solo si la demo sigue viva.

### 2. Proyecto y servicios

- "New Project" → "Deploy image" → imagen `n8nio/n8n` (el `Dockerfile` del repo es la referencia
  del image deploy; el `HEALTHCHECK` usa `/healthz`).
- "New" → "Database" → "PostgreSQL". Es la base de datos INTERNA de n8n (credenciales, ejecuciones).
  Los datos de negocio (contactos, conversaciones, leads, citas) SIEMPRE viven en Supabase Free.

### 3. Variables de entorno (servicio n8n)

Copiar las de `.env.example` y completar. OBLIGATORIAS:

- `DB_TYPE=postgresdb` + `DB_POSTGRESDB_HOST/PORT/DATABASE/USER/PASSWORD` → apuntando al Postgres
  de Railway.
- `N8N_ENCRYPTION_KEY` → `openssl rand -hex 16` y RESPALDARLA: si se pierde, se pierden todas las
  credenciales guardadas en n8n.
- `N8N_BLOCK_ENV_ACCESS_IN_NODE=false` → necesario para que los nodos lean `$env`.
- `GEMINI_API_KEY`, `SYSTEM_PROMPT`, `TENANT_ID`, `SUPABASE_URL`, `SUPABASE_SERVICE_KEY`.
- `WEBHOOK_PATH=whatsapp`, `WHATSAPP_BUSINESS_PHONE` (solo dígitos, con código país).
- Seguridad del editor: `N8N_BASIC_AUTH_ACTIVE=true`, `N8N_BASIC_AUTH_USER`,
  `N8N_BASIC_AUTH_PASSWORD` (generar con `openssl rand -base64 18`) y `N8N_SECURE_COOKIE=true`.
- En producción: `WEBHOOK_VERIFY_SIGNATURE=true` + `META_APP_SECRET` (ver checklist de seguridad).

### 4. Dominio público

- Asignar el dominio autogenerado `*.up.railway.app` al servicio n8n. Railway entrega HTTPS (TLS)
  automático, por lo que en la nube NO se usa tunnel (cloudflared queda solo para dev local).

### 5. Editor de n8n

- Abrir el editor con el dominio público y las credenciales de basic auth. En el trial el editor
  queda expuesto a internet: el basic auth es obligatorio (punto 4 del checklist de seguridad).

### 6. Workflow y credenciales

- Importar `workflows/whatsapp-assistant-base.json` y activarlo.
- Crear credenciales en n8n: Supabase (URL + service role key), WhatsApp Business Cloud (access
  token + phone number id), Telegram (bot token). La clave de Gemini NO se guarda en n8n: la lee el
  nodo desde la variable `GEMINI_API_KEY` (header `x-goog-api-key`).

### 7. Webhook de Meta

- En Meta for Developers: URL del webhook = `https://<TU-SERVICIO>.up.railway.app/whatsapp` con un
  token de verificación propio (el nodo "Responder Challenge" devuelve `hub.challenge`).
- Activar la verificación de firma: `WEBHOOK_VERIFY_SIGNATURE=true` y `META_APP_SECRET` = App
  Secret de la app de Meta. El nodo "Verificar Firma Meta" valida `X-Hub-Signature-256` (HMAC-SHA256)
  y la rama "Responder Rechazo" responde 401 ante firmas inválidas.

### 8. Pruebas end-to-end

- (a) GET a `<URL>/whatsapp?hub.mode=subscribe&hub.challenge=<TOKEN>` responde el challenge.
- (b) Enviar un WhatsApp al número de prueba y ver la ejecución en n8n.
- (c) Confirmar la fila en Supabase (tabla `conversaciones`).
- (d) Enviar un POST con firma inválida y verificar la respuesta 401.

## Fallback: Render

- Crear cuenta sin tarjeta; servicio web con la imagen `n8nio/n8n` (plan Free: 512MB, 0.1 CPU,
  750 horas/mes).
- ADVERTENCIA 1: tras 15 minutos sin tráfico el servicio hace spin-down (~1 min de cold start); el
  webhook de WhatsApp no tolera esa latencia.
- Truco del ping: UptimeRobot (gratis) consultando el healthcheck cada 10 minutos mantiene el
  servicio despierto (~720h/mes, cabe en las 750h del plan).
- ADVERTENCIA 2: el disco es EFÍMERO (sin volúmenes gratis). La base interna de n8n (SQLite) se
  pierde en cada redeploy: restaurar el workflow desde `workflows/whatsapp-assistant-base.json` y
  recrear credenciales. Por eso Render es solo fallback documentado, no hosting primario.
- El Postgres free de Render expira a los 30 días: para lo crítico usar Postgres de Railway o los
  datos de negocio en Supabase Free (con ping anti-pausa).

## Alternativa local (dev)

`docker compose up -d` levanta n8n + Postgres + cloudflared; la URL del túnel se obtiene con
`docker compose logs -f cloudflared`. Guía completa en `README.md` (Ruta 1).

## Medidas de seguridad

Checklist implementado. Cada punto indica dónde está implementado.

1. **Verificación de firma del webhook de Meta** (HMAC-SHA256 con `META_APP_SECRET`, activa con
   `WEBHOOK_VERIFY_SIGNATURE=true`; en dev queda desactivada). → Nodos "Verificar Firma Meta",
   "IF Firma OK" y "Responder Rechazo" (401) en `workflows/whatsapp-assistant-base.json`.
2. **Loop prevention + validación de entrada**: se ignoran los mensajes del propio negocio
   (`WHATSAPP_BUSINESS_PHONE`), solo se procesa texto, máximo 2000 caracteres. → Nodo
   "Normalizar Mensaje".
3. **Secretos SOLO en variables de entorno**: nunca en el repo ni en el JSON del workflow; `.env`
   está excluido en `.gitignore`; `N8N_ENCRYPTION_KEY` obligatoria y respaldada. → `.env.example`,
   `docker-compose.yml`.
4. **Editor n8n con basic auth** (`N8N_BASIC_AUTH_ACTIVE/USER/PASSWORD`) y `N8N_SECURE_COOKIE=true`
   detrás de HTTPS. → `.env.example`; obligatorio en Railway/Render (URL pública).
5. **Supabase: RLS habilitado** en las 5 tablas; la service key solo la usa el backend de n8n
   (atraviesa RLS automáticamente); aislamiento por `tenant_id` para el futuro panel. →
   `supabase/schema.sql` (bloque RLS).
6. **Gemini key vía header** (`x-goog-api-key`), nunca en la URL ni en logs. → Nodo
   "Gemini Responder".
7. **HTTPS en todos los extremos**: TLS automático de Railway/Render; cloudflared en local. →
   `docker-compose.yml`, Railway settings.
8. **Mitigación de prompt injection**: marcadores de salida `[DERIVAR]` / `[LEAD ...]` y reglas
   estrictas PROHIBIDO. → `prompts/prompt-maestro-v2.md`.
9. **Retención mínima de datos**: PII solo teléfono/nombre; política de borrado a petición del
   cliente. → `supabase/schema.sql`.
10. **Auditoría**: ejecuciones visibles en n8n + timestamps y `metadata` jsonb en Supabase. →
    `supabase/schema.sql`.

## Migración a pago

Regla absoluta: NUNCA pagar infraestructura antes del primer anticipo. Cada migración se dispara
por hitos de ingresos, nunca por adelantado (ver `investigacion-ruta-gratuita.md`).

| Hito | Migración | Costo |
|---|---|---|
| Trial agotado, demo viva, sin cliente aún | Railway Free ($1/mes) o Hobby ($5/mes) | ~$4.000-20.000 COP/mes |
| Primer cliente (anticipo 50%) | Railway Hobby o Hetzner CX22 (~€8/mes) | ~$20.000 COP/mes o ~€8/mes |
| 2+ clientes | Hetzner CX22 compartido (un VPS para 3-5 clientes) | ~$9-17K COP/mes por cliente |
| 5+ clientes o 50K MAU | Supabase Pro (proyecto multi-tenant consolidado) | $25/mes ≈ $100.000 COP/mes |

## Costos estimados en COP (1 USD ≈ 4.000 COP)

| Concepto | USD | COP |
|---|---|---|
| Trial Railway (30 días) | $5 de crédito | ≈ $20.000 |
| Railway Free | $1/mes | ≈ $4.000/mes |
| Railway Hobby (n8n 512MB + Postgres pequeño, est.) | $5/mes | ≈ $20.000/mes |
| Render Free (fallback) | $0 | $0 |
| Supabase Free | $0 | $0 |
| Supabase Pro | $25/mes | ≈ $100.000/mes |
| Hetzner CX22 (producción compartida) | ~€8/mes | ~$9-17K COP/mes por cliente |
