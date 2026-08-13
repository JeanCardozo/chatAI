# Guía de cuentas gratuitas — chatAI (JeanCRG)

> 4 cuentas, todas gratuitas, sin tarjeta de crédito. Orden recomendado:
> 1. Meta for Developers (la más compleja, ~30 min) → 2. Gemini (~5 min) → 3. Supabase (~10 min) → 4. Railway (~5 min).
> Después de crear cada cuenta, configura las variables en `.env` (local) o en Railway (cloud).

---

## 1. Meta for Developers — WhatsApp Cloud API (test number)

Objetivo: obtener `WHATSAPP_ACCESS_TOKEN`, `WHATSAPP_PHONE_NUMBER_ID`, `WHATSAPP_BUSINESS_ACCOUNT_ID` y `META_APP_SECRET` para la demo con número de prueba.

1. Ve a https://developers.facebook.com y crea/ingresa con tu cuenta de Facebook personal (la que uses para tu marca).
2. Regístrate como desarrollador (botón "Get Started" / "Empezar" → acepta términos → verifica tu cuenta).
3. Crea una app: "My Apps" → "Create App" → caso de uso: **Business** → nombre sugerido: `JeanCRG ChatAI Demo` → crea.
4. En el dashboard de la app, agrega el producto **WhatsApp** (Add Product → WhatsApp).
5. Quedarás en "API Setup". Ahí está el **Test number** (número de prueba gratuito de Meta, con prefijo +1 555...):
   - Anota `Phone number ID` → `WHATSAPP_PHONE_NUMBER_ID`
   - **Temporary access token**: dale a "Generate token" → cópialo → `WHATSAPP_ACCESS_TOKEN` (dura ~24h; para la demo alcanza; en producción se genera token permanente con System User)
   - Anota `WhatsApp Business Account ID` → `WHATSAPP_BUSINESS_ACCOUNT_ID`
   - La app **nunca** usa el número real del negocio en la demo: el test number envía/recibe contra tu WhatsApp personal (agregado como destinatario).
6. **Agrega tu WhatsApp personal** a la lista de destinatarios: en "To" → selecciona el número del test → verás un campo para agregar tu número real (si no aparece, ve a App Settings → WhatsApp → "Manage phone numbers" o usa la consola de prueba del test number: "Add recipient").
7. **Webhook (verificación):** en "Webhook" de la app → "Configure webhook" → llena:
   - Callback URL: la URL pública del webhook (la de Railway/cloudflared local) + `/webhook/whatsapp`
   - Verify token: inventa uno y anótalo (`WEBHOOK_VERIFY_TOKEN`) — n8n lo responde automáticamente
   - **Importante:** esto se configura DESPUÉS de tener n8n corriendo (Paso 3). Solo deja la app creada por ahora.
8. **App Secret:** App Settings → Basic → "App secret" → mostrarlo y copiarlo → `META_APP_SECRET` (para verificación de firma en producción).

> ⚠️ Nota: la verificación del webhook con el test number es inmediata (sin aprobación de Meta). Los templates no se necesitan: dentro de la ventana de 24h las respuestas son mensajes libres y GRATIS.

---

## 2. Gemini API Key (IA gratuita)

Objetivo: `GEMINI_API_KEY` — gratis, sin tarjeta, límites free tier (Flash/Flash-Lite).

1. Ve a https://aistudio.google.com y entra con tu cuenta de Google.
2. Menú izquierdo → "Get API key" / "Obtener clave de API" → "Create API key".
3. Copia la clave → `GEMINI_API_KEY`. Guárdala (solo se muestra una vez completa).
4. Opcional: en https://ai.google.dev/pricing confirma el modelo `gemini-2.5-flash` y sus límites free tier actuales (los recortan sin aviso; el workflow está diseñado para cambiar de modelo en 1 lugar).

---

## 3. Supabase (base de datos + panel)

Objetivo: `SUPABASE_URL` y `SUPABASE_SERVICE_KEY` — plan Free, sin tarjeta.

1. Ve a https://supabase.com → "Start your project" → entra con **GitHub** (recomendado).
2. Crea un proyecto: org (ej. `JeanCRG`), nombre `chatai-demo`, región `South America (São Paulo)` (la más cercana a Colombia), contraseña de base fuerte (guárdala — `openssl rand -base64 24`).
3. Espera a que se provisione (~2 min).
4. En Settings → API: copia:
   - `Project URL` → `SUPABASE_URL`
   - `service_role` (secret) key → `SUPABASE_SERVICE_KEY` — ⚠️ SECRETA: solo para el backend n8n, nunca la expongas en el frontend
5. En **SQL Editor**: pega el contenido de `supabase/schema.sql` → Run → verás las 5 tablas (tenants, contactos, conversaciones, leads, citas) + RLS habilitado + seed demo.
6. Anti-pausa: el plan free pausa el proyecto tras 7 días sin actividad → al final del Paso 3 configuramos un cron ping (Supabase Edge Function o UptimeRobot) para que nunca se pause.

---

## 4. Railway (hosting de n8n, demo 30 días)

Objetivo: subir n8n + Postgres gratis durante el trial ($5 crédito / 30 días, sin tarjeta).

1. Ve a https://railway.com → "Login" → entra con GitHub.
2. New Project → "Deploy from Dockerfile" / "Deploy a Docker Image" (elige imagen: `n8nio/n8n`) o **"Deploy from repo"** apuntando a este repo (detecta el Dockerfile).
3. Crea un servicio **PostgreSQL** (New → Database → PostgreSQL). Railway le da su propia URL interna.
4. En Variables del servicio n8n, agrega TODAS las del `.env.example` (N8N_ENCRYPTION_KEY obligatoria: `openssl rand -hex 16`; GENERIC_TIMEZONE=America/Bogota; DB_TYPE=postgresdb con los datos del Postgres de Railway; GEMINI_API_KEY, SUPABASE_URL, SUPABASE_SERVICE_KEY, WHATSAPP_*, META_APP_SECRET, N8N_BASIC_AUTH_*).
5. Railway genera una URL pública tipo `https://<proyecto>.up.railway.app` con TLS → esa es la **Callback URL** para el webhook de Meta (Paso 3).
6. Cuando el trial termine: el proyecto pasa a Free plan ($1/mes de crédito) o se pausa; al tener el primer cliente se sube a Hobby ($5/mes, incluye $5 de uso).

---

## Checklist final (después del Paso 3)

- [ ] n8n corriendo con el workflow importado y activo
- [ ] Credenciales en n8n: Supabase API, WhatsApp Business Cloud, Telegram
- [ ] Webhook verificado en Meta (callback URL + verify token)
- [ ] Mensaje de prueba end-to-end con tu WhatsApp
- [ ] Variables de seguridad activas (firma webhook, basic auth)
- [ ] Reporte semanal y panel listos
