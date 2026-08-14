# GUÍA TÉCNICA — Producción (número real, catálogo y escenarios)
**Fecha:** 2026-08-14 · **Base:** documentación oficial Meta (actualizada may-2026) + estado real de la cuenta · **Sistema:** n8n (Railway) + Cloud API + Gemini + Supabase

---

## 1. Conceptos base (explicados fácil)

| Concepto | Qué es | Tu caso |
|---|---|---|
| **WABA** (WhatsApp Business Account) | La "casa" donde viven tus números de negocio. El webhook cuelga de aquí | `1389146220090009` (app "JeanCRG ChatAI Demo") |
| **Número de negocio** | El número que verán TUS clientes. Puedes tener varios por WABA (2 al inicio; 20 con negocio verificado) | Hoy: `+1 555-202-2828` (prueba) → meta: `3118931609` |
| **Número de prueba** | Sandbox de Meta. Solo desarrollo — **nunca** clientes reales | `+1 555-202-2828` |
| **Token de acceso** | La llave para enviar/recibir. Los tokens de usuario **vence a los ~60 días** | El actual vence → **token permanente con System User** (paso #1 de producción) |
| **Webhook** | La "puerta" por donde Meta te avisa de cada mensaje. Es del WABA: **NO cambia al cambiar de número** | `https://n8n-production-21f0f.up.railway.app/webhook/whatsapp` |
| **Ventana de 24 h** | Desde que el cliente te escribe tienes 24 h de respuesta **GRATIS**. Fuera de la ventana SOLO puedes enviar **plantillas aprobadas** | El bot contesta dentro de la ventana ✓ |
| **Tipos de conversación y precios (Colombia, facturable en COP)** | **Servicio** (dentro de 24 h): **GRATIS** · **Utilidad** (confirmaciones/OTP): ~US$0.005 · **Marketing** (promo con plantilla): ~US$0.011–0.0125 · **Autenticación** (OTP): ~US$0.006 (ajustes oct-2025 y ene-2026) | Tarifas exactas: CSV "COP rates" en developers.facebook.com/docs/whatsapp/pricing |
| **Límite de envío** | Inicial: **250 conversaciones/día** (escala solo con uso y calidad buena) | Suficiente para arrancar |
| **Quality rating** | Semáforo de salud del número (GREEN/AMBER/RED) | Hoy **GREEN** — no hagas spam |
| **Opt-in / opt-out** | El cliente debe aceptar recibir mensajes; **STOP/BAJA** para salir (obligatorio y ya lo respeta el bot) | ✓ |
| **Catálogo** | Vive en **Meta Commerce Manager** (NO en n8n). Se vincula al negocio y se muestran productos en el chat vía API | Tu catálogo de 3118931609 **no se pierde** al mover el número |

---

## 2. Configurar el número real `3118931609` (paso a paso)

> ⚠️ **AVISO CLAVE:** el 3118931609 se usa hoy en la app WhatsApp Business (con catálogo). Al moverlo a la API, **la app deja de recibir WhatsApp en ese número** (los mensajes llegan por API). **El catálogo NO se pierde**: sigue en tu negocio de Meta y podrás enviar productos desde el chat por API.

### En WhatsApp Manager (UI oficial — ~20 min):
1. Entra a **business.facebook.com/wa/manage/home** → **Account tools** (ícono de herramientas) → **Phone numbers** → **Add phone number**
2. Ingresa `3118931609` (con +57)
3. Meta detecta que el número está en uso en la app → confirma **"usar este número en la API"** (se desvincula de la app)
4. Define el **PIN de 2 pasos** (guárdalo en el .env — se pide para cambios/borrados)
5. **Verificación:** Meta envía código por **SMS o llamada** → ingrésalo (status pasa a `VERIFIED`). Nota: el número debe poder recibir SMS/llamadas internacionales de Meta
6. **Display name** = nombre comercial (ej. "JeanCRG Colombia") — puede requerir revisión
7. El número queda **conectado** con límite inicial 250 conversaciones/día

### Verificación del negocio (obligatoria para escalar):
8. Business Manager → **Security Center** → **Business verification**: NIT/RUT + documento del representante
9. Desbloquea: 20 números por WABA, mayor límite de mensajes, y opcionalmente **OBA (check azul)**

### En n8n (5 min):
10. En WhatsApp Manager, abre el 3118931609 → copia su **Phone Number ID** (el ID numérico, no el número)
11. n8n → Credentials → **WhatsApp account** → actualiza **Phone Number ID** (from) con el nuevo ID — **el token sigue igual**
12. Guarda → el bot ahora responde **COMO 3118931609**
13. **Prueba:** escríbele desde tu WhatsApp personal → debe responder como el negocio
14. **El webhook no se toca** (es del WABA)

### Catálogo en el chat:
15. WhatsApp Manager → **Catalog**: verifica que tu catálogo esté conectado al negocio
16. **(v2)** Enviar mensajes de producto por API (`type: product` con `catalog_id`) — se agrega al flujo cuando haya clientes de pago; mientras tanto el bot responde precios en texto

---

## 3. Escenarios contemplados (como las empresas grandes)

| Escenario | Cómo lo maneja el sistema | Estado |
|---|---|---|
| Cliente escribe por primera vez | Webhook → upsert contacto → bot responde 2-3 frases con pregunta | ✅ |
| Pregunta de precios/servicios | Respuesta con datos del negocio (SYSTEM_PROMPT) | ✅ |
| Quiere agendar/cotizar | Lead en Supabase → alerta Telegram (reactivar cuando haya volumen) | ✅ |
| Frustración / pide humano | `[DERIVAR]` → alerta Telegram | ✅ |
| **STOP / BAJA** | Confirmación de baja, no insiste | ✅ |
| Escribe fuera de horario | El bot responde 24/7 | ✅ |
| Error temporal de Gemini (rate-limit) | Retry automático ×3 | ✅ |
| **24 h vencidas** (cliente no responde) | Solo con **plantilla aprobada** (bienvenida/reconfirmación) | ⏳ Crear 2-3 plantillas |
| Consulta de producto/catálogo | Precios en texto (v1) → mensajes de producto por API (v2) | ⏳ v2 |
| **Varios clientes (escalar)** | 1 WABA+número por cliente (cuenta Meta propia) o hasta 2 números/WABA; SYSTEM_PROMPT + tenant por cliente en Supabase | ⏳ Diseño listo |
| **Token vence** | Token permanente con **System User** | ⏳ HACER HOY |
| Baneo/spam | API oficial + opt-in + nada de masivos + quality GREEN | ✅ |

---

## 4. Checklist de producción (pendientes, en orden de prioridad)

1. [ ] **System User** en Business Manager + **token permanente** → actualizar `.env` y credencial n8n (nunca más token vencido)
2. [ ] Registrar + verificar `3118931609` (sección 2)
3. [ ] Verificación del negocio (NIT + documento representante)
4. [ ] Display name aprobado
5. [ ] Crear 2-3 **plantillas** (bienvenida, recordatorio) — aprobación rápida
6. [ ] Actualizar credencial n8n con el **Phone Number ID** del número real
7. [ ] Actualizar `.env` local (token permanente, phone number id, PIN)
8. [ ] Prueba E2E con el número real (5 mensajes guionados)
9. [ ] Verificar catálogo vinculado al WABA
10. [ ] Reactivar flujo de alertas de leads cuando entre el primer lead real
11. [ ] (v2) Mensajes de producto + reporte semanal automático a Telegram
