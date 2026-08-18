# RE-DEPLOY COMPLETO — RAILWAY NUEVO (18-ago-2026)

> **Contexto**: expiró el trial de Railway anterior. Nueva cuenta = nueva URL de n8n = hay que
> recrear instancia, credenciales, workflows y re-apuntar el webhook de Meta.
> Lo que NO cambia: Supabase, el WABA/Número (viven en Meta), el System User token, los workflows del repo.

**Hora de inicio del plan: martes 18-ago-2026 15:52 (-05 Colombia).**
Tiempo estimado total: **45–75 min**.

---

## PASO 0 — Lo que necesitas tener a la mano (5 min)
| # | Dato | Dónde está |
|---|------|-----------|
| 0.1 | **URL nueva de n8n** (te la da Railway al desplegar) | Railway dashboard |
| 0.2 | **Token permanente** del System User (EAA...) | Business Settings → System Users (lo creaste ayer) |
| 0.3 | Acceso a n8n nuevo (email + password que pongas) | Railway |
| 0.4 | `.env` local del repo (tiene SUPABASE_URL, SUPABASE_SERVICE_KEY, META_APP_SECRET, etc.) | `/home/jeancardozo/Documentos/MarcaPersonal/chatAI/.env` |
| 0.5 | Los 6 workflows listos en el repo ✅ | `workflows/whatsapp-assistant-v5-zen.json`, `workflows/reporte-semanal.json`, `workflows/panel/*.json` |

---

## PASO 1 — Desplegar n8n en el Railway nuevo (10 min)
1. Railway → **New Project** → **Deploy from template** → busca **n8n** → Deploy.
2. Espera a que el deploy termine (Build + Deploy verdes).
3. **Settings → Networking → Generate Domain** → copia la URL (ej. `https://n8n-xxxx.up.railway.app`).
4. **Variables de entorno** (Settings → Variables → New Variable). Copia EXACTAS desde tu `.env` local:

| Variable | Valor (de `.env`) |
|---|---|
| `N8N_BLOCK_ENV_ACCESS_IN_NODE` | `false` |
| `GENERIC_TIMEZONE` | `America/Bogota` |
| `N8N_SECURE_COOKIE` | `false` |
| `META_APP_SECRET` | valor de `.env` |
| `OPENCODE_API_KEY` | valor de `.env` |
| `SUPABASE_URL` | valor de `.env` |
| `SUPABASE_SERVICE_KEY` | valor de `.env` |
| `TELEGRAM_BOT_TOKEN` | valor de `.env` |
| `TENANT_ID` | `d2f0d3a0-0000-4000-8000-000000000001` |
| `WHATSAPP_BUSINESS_PHONE` | `573118931609` |
| `WEBHOOK_VERIFY_SIGNATURE` | `false` |

> ⚠️ `N8N_BLOCK_ENV_ACCESS_IN_NODE=false` es **obligatorio**: los nodos del workflow leen `$env.*`.

5. Abre la URL → crea tu cuenta admin de n8n (email + password) → entra.

---

## PASO 2 — Crear las 2 credenciales ANTES de importar (5 min)
> Los workflows importan **por NOMBRE**; usa estos nombres EXACTOS.

1. n8n → **Credentials** → **Add credential**:
   - **Credential 1**: tipo **Supabase** → nombre `Supabase account`
     - Host: `db.jipzgsspwnntbnzjniwu.supabase.co` · Database: `postgres` · User: `postgres` · Password: **Service Role Key** (de `.env` SUPABASE_SERVICE_KEY, NO la anon).
   - **Credential 2**: tipo **WhatsApp** → nombre `WhatsApp account`
     - Access Token: **token permanente EAA** (System User, paso 0.2) · Phone Number ID: `1309447485585504` · API Version: `v21.0`

---

## PASO 3 — Importar los 6 workflows (10 min)
n8n → **Workflows → Add workflow → ⋯ (menú) → Import from File**, uno por uno:

| Archivo | Nombre al importar | Activar? |
|---|---|---|
| `workflows/whatsapp-assistant-v5-zen.json` | WhatsApp Assistant Base - P1 | ✅ activar |
| `workflows/reporte-semanal.json` | Reporte Semanal | ✅ activar |
| `workflows/panel/panel-chat.json` | Panel Chat | ✅ activar |
| `workflows/panel/panel-chats.json` | Panel Listar Chats | ✅ activar |
| `workflows/panel/panel-mensajes.json` | Panel Mensajes | ✅ activar |
| `workflows/panel/panel-responder.json` | Panel Responder Manual | ✅ activar |

Después de importar CADA UNO:
1. Ábrelo → verifica que los nodos muestren las credenciales conectadas (si algún nodo pide credencial, selecciona la creada en Paso 2 — el v5 ya viene con referencias, solo confirma).
2. **Active toggle ON** (arriba a la derecha) en los 6.
3. En **Panel Responder Manual**: revisa el nodo *Enviar WhatsApp* → `Phone Number ID` debe ser `1309447485585504` y el credential WhatsApp account. ✅ (viene así).
4. Webhooks visibles (Workflows → abrir → abajo "Production URL"):
   - `POST …/webhook/whatsapp`
   - `GET …/webhook/panel-chat?secret=jeancrg2026panel`
   - `GET …/webhook/panel-chats`
   - `GET …/webhook/panel-mensajes`
   - `POST …/webhook/panel-responder`

---

## PASO 4 — Probar los endpoints (5 min)
Desde tu máquina (terminal) sustituyendo `<NUEVA-URL>`:
```bash
curl "<NUEVA-URL>/webhook/panel-chat?secret=jeancrg2026panel" | head -c 80   # → <!DOCTYPE html>
curl "<NUEVA-URL>/webhook/panel-chats?secret=jeancrg2026panel"                # → {"chats":[...]}
curl "<NUEVA-URL>/webhook/panel-mensajes?secret=jeancrg2026panel&contacto=ce945dfe-e6ad-484e-86da-79a099f3457f"
```

---

## PASO 5 — Re-apuntar el webhook de Meta (5 min)
> Meta sigue enviando a la URL VIEJA hasta que hagas esto.
1. [developers.facebook.com/apps/2474899282989774/whatsapp-business/wa-settings](https://developers.facebook.com/apps/2474899282989774/whatsapp-business/wa-settings)
2. **Configuration → Callback URL** = `<NUEVA-URL>/webhook/whatsapp` · **Verify token** = `jeancrg2026` → **Verify and save**.
3. Si pide campos: suscribe `messages` (y `message_deliveries`, `message_reads`).
4. **Verifica**: App → WhatsApp → Configuration → abajo "Webhook fields" → `messages` debe estar **subscribed** (si se reseteó, clic **Subscribe**).
5. OPCIONAL (solo si el webhook dejó de responder): en Graph API Explorer (token System User) ejecutar:
   - `POST /1938299874223709/subscribed_apps`
   - `POST /1389146220090009/subscribed_apps`

---

## PASO 6 — Prueba de extremo a extremo (10 min)
1. Desde tu WhatsApp personal escribe **"Hola"** al **311 893 1609**.
2. Espera 5–10 s → debe llegar la respuesta del bot con saludo.
3. Abre el panel nuevo: `<NUEVA-URL>/webhook/panel-chat?secret=jeancrg2026panel` → el chat aparece.
4. Envía una respuesta manual desde el panel → debe llegar a tu teléfono y verse en dorado "TÚ".
5. Pídele al bot algo que derive a humano → debe llegar el 🚨 a tu Telegram.
6. Revisa Supabase: tabla `conversaciones` tiene los registros nuevos.

---

## PASO 7 — Actualizar tu `.env` local (2 min)
```bash
cd /home/jeancardozo/Documentos/MarcaPersonal/chatAI
# editar .env:
#   N8N_URL=<NUEVA-URL>
#   WHATSAPP_ACCESS_TOKEN=<token permanente EAA>
```

---

## PASO 8 — ¡A prospectar! (resto del día)
Los mensajes están listos (ver abajo). No dependen de n8n: se envían desde tu WhatsApp personal.
- Toque 1 a los 11 NUEVOS (lista con mensaje).
- Toque 2 a los originales sin respuesta + Don Pedro (número corregido) + Ferretería (respondió Ronald).
- Cuando respondan → ábreles la ventana 24h → el bot los atiende SOLO.

---

## Datos de referencia (no los pierdas)
- **Número**: `+57 311 8931609` · **WABA NativaSoft**: `1938299874223709` · **Phone ID**: `1309447485585504`
- **WABA test**: `1389146220090009` · **Test phone ID**: `1277072472156993`
- **App Meta**: `2474899282989774` · **Business**: `1910243769625661` · **Verify token**: `jeancrg2026`
- **Panel secret**: `jeancrg2026panel` · **Telegram chat**: `7309831214`
- **Supabase**: `jipzgsspwnntbnzjniwu` · **Tenant**: `d2f0d3a0-0000-4000-8000-000000000001`
- **Bot**: modelo `mimo-v2.5` (OpenCode GO) · prompt embebido en el nodo "Preparar Contexto Gemini"

## Checklist final
- [ ] Paso 1: instancia + variables ✅
- [ ] Paso 2: 2 credenciales (Supabase account, WhatsApp account)
- [ ] Paso 3: 6 workflows importados y ACTIVOS
- [ ] Paso 4: endpoints responden
- [ ] Paso 5: webhook Meta re-apuntado (Verify OK)
- [ ] Paso 6: E2E (Hola → bot → panel → responder → Telegram)
- [ ] Paso 7: .env actualizado
- [ ] Paso 8: prospectos contactados