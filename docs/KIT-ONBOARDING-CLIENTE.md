# KIT DE ONBOARDING DE CLIENTE — JEANCRG (montaje rápido)
**Objetivo: cliente operando en 2-4 horas (si su lado está listo) o máximo 2-3 días.**
**Filosofía: nosotros hacemos TODO lo técnico; el cliente solo hace 3 acciones de Meta.**

## LO QUE NECESITAS DEL CLIENTE (3 cosas — mándaselo como checklist)
1. **Un número de WhatsApp LIBRE** (que NO esté activo en ninguna app de WhatsApp — si lo está, lo desvincula primero: `docs/DESBLOQUEO-NUMERO.md` Solución A)
2. **Una tarjeta** (política 2026: sin método de pago no se envían mensajes)
3. **30 minutos** para: crear cuenta Meta Business (si no tiene) + verificar el número con el SMS

> Email de la empresa + acceso al correo para el PIN de 2 pasos.

## DIVISIÓN DE TRABAJO (para que no haya fricción)

### 🟢 EL CLIENTE (30-60 min, guiado por ti en paralelo)
1. Crear/verificar su **Meta Business** (business.facebook.com con su correo) — o confirmar que ya tiene
2. **WhatsApp Manager → Agregar número** → verificar con SMS (PIN de 2 pasos guardado)
3. **Agregar método de pago** (tarjeta)
4. Pasar el **Phone Number ID** a ti (o el nombre del negocio)

### 🔵 TÚ (30-45 min — todo por API/n8n, sin tocar su cuenta)
1. **System User** del cliente (o usar su token temporal) + **token** con permisos WhatsApp
2. **Suscribir webhook** del WABA del cliente a tu n8n (POST /{WABA}/subscribed_apps)
3. **Crear credencial WhatsApp** en n8n (su token + phone number ID)
4. **Copiar el workflow** `whatsapp-assistant-v5-zen.json` → renombrar por cliente → apuntar a SU credencial
5. **Escribir el SYSTEM_PROMPT del cliente** (nodo Preparar Contexto): negocio, servicios/precios, horarios, FAQs, reglas — 20-40 min (LA clave: sin esto el bot es genérico)
6. **Copiar el workflow de reporte** → tenant del cliente + su Telegram
7. **Prueba E2E** (5 mensajes guionados)

## ALERTAS DE PEDIDOS / PAGOS (ya implementado en el bot)
El bot detecta la intención por palabras clave y te alerta a Telegram:
- 🚨 DERIVAR (frustración/humano) · 📅 LEAD (cita/cotización) · 🛒 PEDIDO (pedido/domicilio/talla) · 💰 PAGO (pago/nequi/tarjeta)
- Cada cliente recibe su alerta en SU Telegram (se configura en el workflow copiado)

## PLANTILLA DE MENSAJE AL CLIENTE (para el arranque)
> "Para dejar tu asistente funcionando en tiempo récord solo necesito de ti 3 cosas:
> 1) Un número de WhatsApp libre (que no uses en ninguna app), 2) una tarjeta para el método de pago de Meta (obligatorio por política 2026), y 3) 30 minutos esta semana para crear la cuenta de negocio y verificar el número con un SMS.
> Yo me encargo de TODO lo demás (configuración, el bot con los datos de tu negocio, las alertas y el reporte semanal)."

## TIEMPOS REALES
| Situación del cliente | Tiempo total |
|---|---|
| Ya tiene Meta Business + número libre + tarjeta | **2-4 horas** |
| Necesita crear Meta Business (documentos) | 1 día |
| Número atado a una app (hay que liberarlo) | 2-3 días (el paso que más tarda) |
