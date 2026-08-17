# SOP — ONBOARDING DE CLIENTE (WhatsApp IA JeanCRG)
**Propósito: llevar a un cliente de "interesado" a "bot en producción" en ≤5 días, sin fricción.**
**Lección 14-15-ago: el 80% de la fricción fue el número de WhatsApp del cliente (migración de la app). Este SOP la elimina.**

## FASE 0 — PRE-VENTA (antes de cobrar)
- [ ] Confirmar que el número del cliente **NO está activo en ninguna app de WhatsApp** (personal o business). Si lo está → Solución A del manual `docs/DESBLOQUEO-NUMERO.md` ANTES de firmar.
- [ ] Confirmar que el cliente tiene **tarjeta** (política 2026: sin método de pago no se envían mensajes).
- [ ] Cerrar alcance: 1 sede o multi-sede · servicios o productos · horario de atención · idioma.

## FASE 1 — SETUP META (acciones del cliente, guiadas por Jean — 60-90 min)
1. [ ] Crear/verificar cuenta Meta Business (business.facebook.com con su correo)
2. [ ] Crear WABA + agregar su número (WhatsApp Manager → Números → Agregar)
3. [ ] **Verificar el número con SMS/llamada** (PIN de 2 pasos definido y guardado)
4. [ ] Nombre visible del negocio (display name)
5. [ ] **Método de pago** (WhatsApp Manager → Configuración de pagos → tarjeta)
6. [ ] (Opcional) Verificación del negocio para límites mayores

## FASE 2 — CONEXIÓN (Jean — 30-45 min)
1. [ ] Crear **System User** + token permanente (Business Manager → System users → token con `whatsapp_business_messaging` + `whatsapp_business_management`)
2. [ ] Suscribir webhook del WABA del cliente a la URL de n8n + Verify Token
3. [ ] Crear credencial de WhatsApp en n8n (token + Phone Number ID del cliente)
4. [ ] Copiar workflow `whatsapp-assistant-v5-zen.json` → renombrar por cliente → apuntar a SU credencial
5. [ ] Copiar workflow `reporte-semanal.json` → filtrar por SU tenant → SU Telegram

## FASE 3 — ENTRENAMIENTO DEL BOT (Jean — 20-40 min) ⚠️ CRÍTICO
1. [ ] Escribir el **SYSTEM_PROMPT del cliente** (nodo "Preparar Contexto Gemini"): negocio, servicios/precios EXACTOS, horarios, FAQs, reglas de derivación, enlace de agendamiento (Calendly/WhatsApp)
2. [ ] Datos de ejemplo: 3-5 preguntas frecuentes reales con sus respuestas (few-shot)
3. [ ] Prohibir alucinaciones: solo lo que está en el prompt; fuera de eso → [DERIVAR]

## FASE 4 — PRUEBA E2E (Jean + cliente — 15 min)
1. [ ] Cliente escribe "Hola" → saludo correcto
2. [ ] Pregunta precio/servicio → respuesta con sus datos
3. [ ] Pide agendar → lead cae en su canal (Telegram/panel)
4. [ ] Frustración/pide humano → alerta al dueño
5. [ ] STOP → baja respetuosa
6. [ ] Reporte semanal enviado al dueño

## FASE 5 — ENTREGA (cliente)
1. [ ] Demo de 5 min mostrando el bot en SU WhatsApp
2. [ ] Reporte de métricas de la semana 1
3. [ ] Factura + contrato firmado (venta/contrato.md)
4. [ ] Cobro 50/30/20 con anticipo ≥40%

## Checklist rápido de Jean por cliente
| Ítem | ¿Dónde? |
|---|---|
| Token permanente | Business Manager → System Users |
| Webhook suscrito | POST /{WABA}/subscribed_apps o consola |
| Credencial n8n | n8n → Credentials → WhatsApp (token + phone number ID) |
| Workflow copiado | n8n → Workflows → Duplicate → editar credencial + prompt |
| Prompt del cliente | Nodo "Preparar Contexto Gemini" |
| Reporte | Workflow reporte-semanal (tenant + Telegram del cliente) |
| Plantillas Meta (v2) | WhatsApp Manager → Plantillas (bienvenida, recordatorio) |
