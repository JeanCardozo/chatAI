# SYSTEM USER + GESTIÓN DEL NÚMERO COMPARTIDO (2026-08-15)

## 1. TOKEN PERMANENTE — System User (10 min, acción del dueño del Business Manager)
El token actual (de la consola) **muere en horas** — cada vez que pasa, el bot deja de enviar. El System User genera un token **que no expira**.

Pasos (en business.facebook.com con tu sesión):
1. **Configuración del negocio** (engranaje abajo a la izquierda)
2. **Usuarios → Usuarios del sistema** → **Agregar**
3. Nombre: `chatAI bot` · Rol: **Empleado** (o Admin si no hay otros) · Crear
4. En el usuario creado → **Agregar recursos**: la app **"chatAI demo"** (2474899282989774)
5. En el mismo usuario → **Generar nuevo token** → seleccionar la app "chatAI demo"
6. Permisos: **whatsapp_business_messaging** + **whatsapp_business_management**
7. **Generar** → copiar el token (empieza con EAAG...) → **pégalo en n8n (credencial WhatsApp account) y en .env (WHATSAPP_ACCESS_TOKEN)** — y me avisas para validarlo

> El token del System User puede configurarse SIN expiración. Guarda una copia segura (es tu llave maestra).

## 2. EL NÚMERO ES COMPARTIDO (NativaSoft + JeanCRG) — cómo gestionarlo

**Regla de oro: UN número = UNA marca en WhatsApp.** El 3118931609 muestra el perfil "NativaSoft" — así lo ven los clientes. No se pueden tener dos marcas (Nativasoft + JeanCRG) sobre el mismo número.

**Modelo limpio:**
- **3118931609 → NativaSoft** (la empresa con tus socios): queda en la API como está
- **JeanCRG (tu marca personal) → su propio número** cuando lo necesites: se agrega con el mismo procedimiento (o se usa el número de cada CLIENTE para su bot). El sistema es multi-tenant: un número/credencial/prompt por marca o cliente.

**¿Cómo respondo PERSONALMENTE sin la app?**
- **SÍ puedes responder del mismo número**: WhatsApp Manager → **Bandeja de entrada** (web) — ves cada conversación y respondes a mano desde el mismo 3118931609 cuando quieras (handoff humano).
- El bot responde automáticamente a todo. Cuando un cliente pide humano o se frustra → el bot te **alerta a Telegram** → tú entras a la Bandeja de entrada y respondes tú.
- **Control bot vs humano:** todo lo del bot queda en Supabase (tabla conversaciones, con `derivado_a_humano`). Tus respuestas manuales quedan en la Bandeja de entrada de Meta. Para control "perfecto": el v2 añadirá un flag por contacto ("modo humano") que pausa al bot en ese chat; hoy conviven (bot responde, tú puedes intervenir encima).

## 3. V2 — MEJORAS de gestión (anotadas)
- Flag "modo humano" por contacto (pausa el bot en ese chat)
- Panel simple (leer conversaciones + leads desde Supabase)
- Bandeja unificada (Meta Business Suite Inbox) como app de trabajo
