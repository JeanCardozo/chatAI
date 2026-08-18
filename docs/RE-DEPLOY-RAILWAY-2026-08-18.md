# RE-DEPLOY COMPLETO DESDE CERO — RAILWAY (18-ago-2026)

> Instrucciones definitivas para montar **n8n + bot WhatsApp + panel premium** en tu cuenta
> Railway NUEVA (trial 30 días), desde vacío hasta prospectos contactados.
> Hora de inicio: **martes 18-ago-2026 ~16:00 (-05 Colombia)** · Tiempo total: **60–90 min**.

---

## 🧱 ARQUITECTURA (qué vamos a montar)

```
                    ┌─────────────────────────────────────────┐
  Cliente WhatsApp →│ n8n (Railway, Docker)                   │
  (311 893 1609)    │  · Webhook /webhook/whatsapp  ← Meta    │
                    │  · Workflow BOT (mimo-v2.5 IA)          │
                    │  · Workflow REPORTE semanal             │
                    │  · Workflow PANEL (chat/listar/         │
                    │    mensajes/responder)  ← tú (navegador)│
                    └──────┬──────────────┬───────────────────┘
                           │              │
                     Supabase         Telegram
                  (contactos,     (alertas 🚨 DERIVAR,
                   conversaciones,  📅 LEAD, etc.)
                   leads, prospectos)
```

| Componente | Tecnología | Dónde vive | Estado |
|---|---|---|---|
| Orquestador (n8n) | Docker `n8nio/n8n:2.34.5` | Railway (nuevo) | 🔴 re-montar |
| Base interna de n8n | SQLite (viene en el contenedor) | Railway volumen | 🔴 re-montar |
| Base de negocio | **Supabase** (ya existe) | `jipzgsspwnntbnzjniwu` | ✅ intacta |
| Número/WABA | Meta Cloud API | Meta (NO cambia) | ✅ intacto |
| IA | OpenCode GO `mimo-v2.5` | API externa | ✅ intacta |
| Alertas | Telegram | API externa | ✅ intacta |

---

## PARTE A — DECISIÓN DE BASE DE DATOS (2 min)

**Recomendado para el trial: SQLite** (base interna que viene DENTRO del contenedor n8n).
- ✅ Cero servicios extra, cero configuración, igual que la instancia anterior.
- ⚠️ Vive en el disco efímero de Railway: si borras el servicio, pierdes workflows/credenciales
  (por eso EXPORTAMOS todo al repo — ya está).
- Migrar a Postgres después es sencillo (ver Apéndice B).

> La base de datos **de negocio** (contactos, conversaciones, prospectos) ya está en Supabase
> y NO se toca. Lo que montamos hoy es solo la base INTERNA de n8n (workflows + credenciales).

---

## PARTE B — DESPLEGAR N8N EN RAILWAY (15 min)

### Paso 1. Cuenta Railway nueva
1. Entra a [railway.app](https://railway.app) con la cuenta que creaste (la del nuevo trial).
2. Confirma el plan: **Hobby / trial 30 días** (sin tarjeta si es el trial nuevo).

### Paso 2. Crear el proyecto con la imagen Docker
**Opción A — Template (recomendada, 2 clics):**
1. **New Project → Deploy from template** → busca **n8n** → **Deploy**.
2. Railway crea el servicio con la imagen `n8nio/n8n` (última estable) y el puerto correcto.

**Opción B — Docker image manual (control total):**
1. **New Project → Deploy from image** (o Empty → New Service → Docker Image).
2. **Image**: `n8nio/n8n:2.34.5`  ← **pínchala** (es la versión EXACTA que generó nuestros workflows; evita sorpresas de importación).
3. **Port**: `5678` (n8n escucha ahí por defecto).

### Paso 3. Variables de entorno (el paso MÁS crítico)
En el servicio → **Variables → New Variable**. Copia EXACTAMENTE:

```bash
# n8n
N8N_ENCRYPTION_KEY=e810b20a87a69254a8138e7978dcabdd
N8N_BLOCK_ENV_ACCESS_IN_NODE=false
GENERIC_TIMEZONE=America/Bogota
N8N_SECURE_COOKIE=false
PORT=5678

# Meta (firma del webhook)
META_APP_SECRET=72c2a7dbb9a37b213ed916342b0b226d
WEBHOOK_VERIFY_SIGNATURE=false

# IA (OpenCode GO / mimo-v2.5)
OPENCODE_API_KEY=sk-Eks6X1tmNzGBr77pBWcSkvyDOdTlNDxGFQtM5mCXuK28qbtXV6JuH8ULMgU5aQVw

# Supabase (datos de negocio)
SUPABASE_URL=https://jipzgsspwnntbnzjniwu.supabase.co
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImppcHpnc3Nwd25udGJuempuaXd1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NjY1MzQ1NSwiZXhwIjoyMTAyMjI5NDU1fQ.yRVakE1dbtMuT_9SiXtdHZ-PZOl8kFyWWDm5GWyunaI
TENANT_ID=d2f0d3a0-0000-4000-8000-000000000001

# WhatsApp (número real)
WHATSAPP_BUSINESS_PHONE=573118931609

# Telegram (alertas de derivación)
TELEGRAM_BOT_TOKEN=8807842110:AAGgU6QDADaN-Lvt_hqZV_orFIhG0dwrT1E
```

⚠️ **ADVERTENCIAS**:
- `N8N_ENCRYPTION_KEY` es la clave que cifra las credenciales de n8n. **Grábala** (ya está en tu `.env`). Si cambia, las credenciales guardadas quedan ilegibles.
- `N8N_BLOCK_ENV_ACCESS_IN_NODE=false` es OBLIGATORIA: los nodos del workflow leen `$env.*`.
- **NO** copies `WHATSAPP_ACCESS_TOKEN` a las variables: el token va DENTRO de la credencial WhatsApp de n8n (Paso 6), porque aquí usarás el token PERMANENTE del System User.
- **NO** actives `N8N_BASIC_AUTH_*` (la instancia nueva usa su propia cuenta admin; el basic auth solo complica).

### Paso 4. Dominio público
1. **Settings → Networking → Generate Domain**.
2. Copia la URL: será algo como `https://n8n-XXXX.up.railway.app` → **anótala** (la usarás 10 veces).

### Paso 5. Cuenta admin de n8n
1. Abre la URL → n8n te pide crear la cuenta.
2. Email: `jean.cardozo.ramirez.23@gmail.com` · Password: **el que quieras** (guárdalo en tu gestor).

---

## PARTE B-2 — BASE DE DATOS INTERNA PERSISTENTE (PostgreSQL en Railway) ← OBLIGATORIA

> **Por qué es OBLIGATORIA**: n8n guarda su base interna (workflows, credenciales, tu cuenta
> admin) en SQLite dentro del disco EFÍMERO del contenedor. Railway BORRA ese disco en cada
> reinicio (cambio de variables, redeploy, inactividad) → pierdes la cuenta y te "saca" del
> login. La solución es mover esa base interna a PostgreSQL de Railway: persiste siempre.

### Paso B2.1 — Crear el servicio PostgreSQL
1. En Railway, **mismo proyecto** donde está n8n → **New → Database → Add PostgreSQL** (o botón **+ → Database**).
2. **Region**: elige la MISMA del servicio n8n (ej. us-east-1) para usar la red interna.
3. Espera a que el servicio quede **verde** (1–2 min).

### Paso B2.2 — Copiar la cadena de conexión INTERNA
1. Clic en el servicio PostgreSQL → **Variables**.
2. Copia el valor de **`DATABASE_URL`** que diga **`.railway.internal`** (¡NO la pública `.up.railway.app`!).
   Formato: `postgresql://postgres:PASSWORD@HOST:5432/railway`

### Paso B2.3 — Conectar n8n a esa base (variables en el servicio n8n)
En el servicio **n8n** → **Variables** → agrega (con los valores sacados de la URL interna):

```bash
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=<host del DATABASE_URL interno, ej. xxxx.railway.internal>
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=railway
DB_POSTGRESDB_USER=postgres
DB_POSTGRESDB_PASSWORD=<password de la URL interna>
```

5. Railway **reinicia n8n automáticamente** al guardar (1–2 min). A partir de aquí **nada se pierde al recargar o reiniciar** ✅.
6. Verifica: vuelve a cargar la URL → **n8n te pide crear la cuenta admin** (porque la base nueva está vacía) → créala UNA vez → recarga varias veces → **ya no te saca**.
7. Con la cuenta admin creada y persistente → sigue con PARTE C (credenciales) → D (importar) → E (probar y re-apuntar Meta).

> 💡 Alternativa (solo si NO quieres Postgres): adjuntar un **Volume** al servicio n8n
> montado en `/home/node/.n8n` (Settings → Volumes). En el trial de Railway los volúmenes
> pueden no estar disponibles; PostgreSQL es la vía recomendada y estándar.

## PARTE C — CREDENCIALES EN N8N (5 min)

**Antes de importar workflows** (n8n conecta las credenciales **por nombre**):

### Credencial 1: Supabase
1. n8n → **Credentials → Add credential** → tipo **Supabase**.
2. **Name**: `Supabase account`
3. Campos:
   - **Host**: `db.jipzgsspwnntbnzjniwu.supabase.co`
   - **Database**: `postgres`
   - **User**: `postgres`
   - **Password**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImppcHpnc3Nwd25udGJuempuaXd1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NjY1MzQ1NSwiZXhwIjoyMTAyMjI5NDU1fQ.yRVakE1dbtMuT_9SiXtdHZ-PZOl8kFyWWDm5GWyunaI` ← la **Service Role Key** (NO la anon).
4. **Save**.

### Credencial 2: WhatsApp
1. **Credentials → Add credential** → tipo **WhatsApp**.
2. **Name**: `WhatsApp account`
3. Campos:
   - **Access Token**: `EAA...` ← tu **token PERMANENTE del System User** (Business Settings → System Users). Si aún no lo tienes a la mano: copia el temporal de Meta for Developers AHORA y lo reemplazas mañana (el bot dejará de responder en ~24h hasta cambiarlo — por eso el permanente es prioridad).
   - **Phone Number ID**: `1309447485585504`
   - **API Version**: `v21.0`
4. **Save** y haz clic en **Test** → debe decir conectado.

---

## PARTE D — IMPORTAR LOS 6 WORKFLOWS (10 min)

Los archivos ya están en el repo listos para importar:
```
/home/jeancardozo/Documentos/MarcaPersonal/chatAI/workflows/
├── whatsapp-assistant-v5-zen.json      ← BOT (ya corregido: número real + credenciales)
├── reporte-semanal.json                ← Reporte Telegram
└── panel/
    ├── panel-chat.json                 ← Panel premium (nueva UI)
    ├── panel-chats.json                ← Lista chats
    ├── panel-mensajes.json             ← Mensajes de un chat
    └── panel-responder.json            ← Responder como humano
```

1. n8n → **Workflows → Add workflow** (o usa el menú ⋯ → **Import from File**).
2. Importa los 6 archivos, uno por uno.
3. Por CADA workflow importado:
   - Ábrelo → **Active toggle ON** (arriba a la derecha).
   - Confirma que los nodos de Supabase/WhatsApp muestren la credencial conectada (si alguno la pide, selecciona la del Paso C).

Los 6 webhooks que quedan activos:
| Endpoint | Uso |
|---|---|
| `POST …/webhook/whatsapp` | Recibe mensajes de Meta |
| `GET …/webhook/panel-chat?secret=jeancrg2026panel` | Panel (tu bandeja) |
| `GET …/webhook/panel-chats?secret=…` | API lista de chats |
| `GET …/webhook/panel-mensajes?secret=…&contacto=…` | API mensajes |
| `POST …/webhook/panel-responder` | API enviar como humano |
| `POST …/webhook/reporte-semanal` | Reporte semanal (cron interno, no lo llames a mano) |

---

## PARTE E — PROBAR (10 min)

### E1. Los endpoints (desde tu terminal)
```bash
URL="https://<TU-NUEVA-URL>.up.railway.app"   # reemplaza

curl "$URL/webhook/panel-chat?secret=jeancrg2026panel" | head -c 60   # → <!DOCTYPE html>
curl "$URL/webhook/panel-chats?secret=jeancrg2026panel"                # → {"chats":[...]}
curl "$URL/webhook/panel-mensajes?secret=jeancrg2026panel&contacto=ce945dfe-e6ad-484e-86da-79a099f3457f"
```

### E2. Re-apuntar el webhook de Meta (5 min) ← SIN ESTO EL BOT NO RECIBE NADA
1. [developers.facebook.com/apps/2474899282989774/whatsapp-business/wa-settings](https://developers.facebook.com/apps/2474899282989774/whatsapp-business/wa-settings)
2. **Configuration**:
   - **Callback URL**: `https://<TU-NUEVA-URL>.up.railway.app/webhook/whatsapp`
   - **Verify token**: `jeancrg2026`
   - Botón **Verify and save** → debe decir *"Webhook successfully verified"*.
3. Abajo, **Webhook fields**: marca `messages` (y opcional `message_deliveries`, `message_reads`) → **Subscribe**.
4. Si pide re-suscribir los WABAs: Graph API Explorer con el token System User → ejecuta:
   - `POST /1938299874223709/subscribed_apps`
   - `POST /1389146220090009/subscribed_apps`

### E3. Prueba de extremo a extremo
1. Desde tu WhatsApp personal escribe **"Hola"** al **311 893 1609**.
2. 5–10 s → llega la respuesta del bot (saludo).
3. Abre el panel → ves el chat → responde manualmente → llega a tu teléfono y se ve **dorado TÚ**.
4. Pídele algo que derive a humano → llega **🚨 DERIVAR** a tu Telegram.
5. Revisa Supabase: filas nuevas en `conversaciones`.

---

## PARTE F — ACTUALIZAR TU `.env` LOCAL (2 min)

```bash
cd /home/jeancardozo/Documentos/MarcaPersonal/chatAI
nano .env   # o tu editor
```
Cambia:
```
N8N_URL=https://<TU-NUEVA-URL>.up.railway.app
WHATSAPP_ACCESS_TOKEN=<token permanente EAA>
```

---

## PARTE G — PENDIENTES QUE COMPLETAN EL SISTEMA

### G1. Tabla `prospectos` (para el follow-up de 5 toques)
En [Supabase → SQL Editor](https://supabase.com/dashboard/project/jipzgsspwnntbnzjniwu/sql) ejecuta:

```sql
create table if not exists public.prospectos (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null default 'd2f0d3a0-0000-4000-8000-000000000001'::uuid,
  nombre text not null,
  negocio text,
  telefono text not null unique,
  estado text not null default 'nuevo',       -- nuevo|contactado|interesado|demo|cliente|no_interesado
  toque int not null default 0,               -- 0..5 toques
  fecha_ultimo_toque timestamptz,
  notas text,
  created_at timestamptz not null default now()
);
alter table public.prospectos enable row level security;
create policy "service role full" on public.prospectos for all using (true) with check (true);
```

### G2. Plantillas Meta (mensajes iniciados por el negocio)
Necesarias para el follow-up automático (día 2, 5, 9…): en
[Manager → WhatsApp → Plantillas](https://business.facebook.com/wa/manage/message-templates/)
crear: `bienvenida`, `seguimiento_1`, `seguimiento_2`, `demo_confirmada` (español, categoría Marketing/Utility, aprobación ~minutos). El número ya está VERIFICADO → las plantillas no requieren revisión previa.

---

## PARTE H — CONTACTAR PROSPECTOS YA MISMO (30–45 min)

### H1. A los 11 NUEVOS (toque 1) — desde tu WhatsApp personal
Mensaje base (personaliza el nombre y el negocio):
> ¡Hola [nombre]! 👋 Soy Jean, de JeanCRG. Vi que [negocio] trabaja por WhatsApp y quería mostrarle algo: un asistente con IA que responde solo, agenda citas y captura clientes las 24 horas. ¿Le interesa una demo de 5 minutos? Sin compromiso.

| # | Prospecto | Teléfono |
|---|---|---|
| 1 | Animalía | 317 276 6086 |
| 2 | Servicios Vet Tolima | 310 320 3337 |
| 3 | Sierra | 316 442 1364 |
| 4 | Zooshop | 313 888 7108 |
| 5 | CAPA | 315 267 2829 |
| 6 | Murdock | 301 757 3610 |
| 7 | Carisma | 313 390 5782 |
| 8 | Focuz | 311 849 0945 |
| 9 | ToolStore | 323 478 8088 |
| 10 | Ferreyepes | 312 438 1518 |
| 11 | SportFitness | 314 637 0443 |

### H2. Toque 2 (los que no respondieron)
> ¡Hola [nombre]! Le escribí hace unos días sobre el asistente IA para WhatsApp de JeanCRG. ¿Sigue interesado en ver una demo de 5 minutos?

- Chapi · LD_STOROS · STOP24 (si no respondieron al toque 2, no insistir; STOP24 espera la demo grabada)
- **Don Pedro** → usa el número corregido **301 524 4793** (¡el 317 2419273 era de MOBO!)
- **Ferretería Al Día (Ronald)** → "¡Hola Ronald! Le escribía por lo del asistente para WhatsApp. ¿Cuántos pedidos recibe al día por ese medio? Le tengo una propuesta con diagnóstico gratis."

### H3. Regla de oro
Cuando respondan → respóndeles TÚ una vez para abrir la ventana 24h → de ahí en adelante el **bot los atiende solo** (y te alerta si necesitan humano). Con el panel nuevo, puedes responder desde el navegador sin tocar el celular.

---

## ✅ CHECKLIST FINAL
- [ ] Paso 1: cuenta Railway nueva
- [ ] Paso 2: servicio n8n (template o imagen `n8nio/n8n:2.34.5`, puerto 5678)
- [ ] Paso B2: PostgreSQL en Railway + n8n conectado (DB_TYPE=postgresdb) — **sin esto te saca del login**
- [ ] Paso 3: 13 variables de entorno exactas
- [ ] Paso 4: dominio generado + anotado
- [ ] Paso 5: cuenta admin n8n creada
- [ ] Paso 6: credenciales `Supabase account` + `WhatsApp account` (token permanente) — Test OK
- [ ] Paso 7: 6 workflows importados y ACTIVOS
- [ ] Paso 8E1: curl de panel OK
- [ ] Paso 8E2: webhook Meta verificado ("Webhook successfully verified")
- [ ] Paso 8E3: E2E (Hola → bot → panel → responder → Telegram)
- [ ] Paso 9: .env actualizado
- [ ] Paso G1: SQL `prospectos` ejecutado
- [ ] Paso H: prospectos contactados

---

## 🛠️ SOLUCIÓN DE PROBLEMAS

| Problema | Causa | Solución |
|---|---|---|
| Meta: "Webhook verification failed" | Workflow `/webhook/whatsapp` inactivo o URL mal | Activa el workflow del bot; verifica URL exacta `…/webhook/whatsapp`; verify token `jeancrg2026` |
| Bot no responde aunque Meta verifica | Callback OK pero campo `messages` sin Subscribe | Configuration → Webhook fields → Subscribe messages |
| El panel dice "Sin acceso" | Secret mal en la URL | `?secret=jeancrg2026panel` |
| Credencial WhatsApp falla Test | Token temporal expirado | Pega el token PERMANENTE del System User |
| Nodo Supabase falla | Password ≠ Service Role Key | La credencial usa SUPABASE_SERVICE_KEY como password |
| Error 131047 en envíos | Ventana 24h cerrada (simulación/lead viejo) | El contacto debe escribirte primero; es normal en pruebas |
| Workflow importado no guarda credenciales | Se importó sin credencial creada antes | Crea las 2 credenciales PRIMERO (Paso C) y re-importa |
| ¿Subir versión de n8n? | — | Quédate en 2.34.5 (idéntica a la que generó los JSON). Actualiza después si todo funciona |

---

## APÉNDICE A — DÓNDE ESTÁ CADA COSA (referencia rápida)
- **Meta app**: developers.facebook.com/apps/2474899282989774 · verify `jeancrg2026` · secret `72c2a7dbb9a37b213ed916342b0b226d`
- **WABA NativaSoft**: `1938299874223709` · número `573118931609` · phone ID `1309447485585504`
- **WABA test**: `1389146220090009` · phone ID test `1277072472156993`
- **Supabase**: `jipzgsspwnntbnzjniwu` · tenant `d2f0d3a0-0000-4000-8000-000000000001`
- **Panel**: `…/webhook/panel-chat?secret=jeancrg2026panel`
- **Telegram**: token `8807842110:…` · chat `7309831214`

## APÉNDICE B — MIGRAR A POSTGRES MÁS TARDE (opcional)
1. Railway → **New → Database → PostgreSQL** (usa la instancia del trial si alcanza).
2. Copia la connection string interna (Internal URL).
3. En el servicio n8n agrega variables:
   ```
   DB_TYPE=postgresdb
   DB_POSTGRESDB_HOST=<host interno>
   DB_POSTGRESDB_PORT=5432
   DB_POSTGRESDB_DATABASE=railway
   DB_POSTGRESDB_USER=<user>
   DB_POSTGRESDB_PASSWORD=<password>
   ```
4. Redeploy. (Los workflows viven en el repo, así que no pierdes nada.)