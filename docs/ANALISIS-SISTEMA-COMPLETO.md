# ANÁLISIS COMPLETO DEL SISTEMA vs COMPETENCIA — JeanCRG (2026-08-14)
**Verdad verificada sobre el sistema actual, la competencia y qué falta para clientes reales.**

## 1. ARQUITECTURA ACTUAL (verificada — 20 nodos)
```
Webhook Meta → IF Verificación → Responder Challenge (GET)
            → Verificar Firma (HMAC) → IF OK → Normalizar Mensaje
            → Upsert Contacto → Obtener Historial (últimos 6) + Guardar Mensaje
            → Preparar Contexto (SYSTEM_PROMPT por cliente) → DeepSeek V4-Flash (OpenCode GO)
            → Extraer Respuesta (intención determinista) → Guardar Respuesta IA
            → Preparar Lead → Guardar Lead (no bloquea duplicados)
            → Preparar Notificación → Alerta Telegram [DERIVAR]
            → Enviar WhatsApp
```
**Escenarios cubiertos (probados hoy):** saludo 1 sola vez · precios · agendar (Calendly + lead) · frustración/humano (alerta determinista) · STOP · imagen/audio · fuera de alcance · lead duplicado no bloquea · historial limitado anti-contaminación · retry IA 3× · firma HMAC · reporte semanal.

## 2. MATRIZ vs COMPETENCIA (precios verificados jul-ago 2026)

| Capacidad | **JeanCRG** | Trement ($19-80K/mes) | Ventiva ($600K+$390K/mes) | WATI/Respond ($15-49/mes) | TikTokers |
|---|---|---|---|---|---|
| IA conversacional con datos del negocio | ✅ custom | ✅ genérica | ✅ | ⚠️ básica | ⚠️ |
| Leads estructurados + alerta inmediata | ✅ Supabase+Telegram | ✅ panel | ✅ | ✅ | ❌ |
| Derivación humana automática | ✅ determinista | ⚠️ | ✅ | ⚠️ | ❌ |
| Reporte semanal automático | ✅ | ✅ | ✅ | ✅ | ❌ |
| Multi-negocio (tenant) | ✅ diseño listo | ✅ | ✅ | ✅ | ❌ |
| Costo software (IA) | ✅ $0 (suscripción GO) | ✅ | ✅ | ✅ | — |
| Catálogo/productos en chat | ⏳ v2 | ✅ | ✅ | ✅ | ❌ |
| Plantillas fuera de 24h | ⏳ | ✅ | ✅ | ✅ | ❌ |
| Self-serve | ❌ servicio | ✅ | ❌ | ✅ | ✅ |
| Precio de entrada | **$490K** (propuesto) / $1.8M | $19-80K/mes | $600K+$390K/mes | $15-49/mes | $50-100K |

**Veredicto:** en la capa servicio estamos AL NIVEL de Ventiva (y más baratos a 12 meses). Nos faltan 3 features de plataforma (catálogo, plantillas, self-serve) que NO bloquean el primer cliente — son v2.

## 3. QUÉ FALTA PARA CLIENTE #1 (en orden — NO negociable)

1. **🔴 System User + token permanente** (los user tokens mueren en horas — hoy murió 2 veces) → 10 min, te guío
2. **🔴 Método de pago en el WABA del cliente** (política 2026: sin tarjeta NO se envían mensajes — ni de servicio) → acción del cliente
3. **🔴 Número verificado** (3118931609: liberar de la app Nativasoft → verificar SMS)
4. 🟠 **SOP de onboarding por cliente** (documentar: número/migración/verificación/tarjeta — la saga de hoy NO puede repetirse por cliente)
5. 🟠 **Prompt por cliente** (20-40 min: menú/precios/FAQs/horarios del negocio — SIN esto el bot responde genérico)
6. 🟠 **2-3 plantillas Meta** (seguimiento fuera de 24h)
7. 🟡 Contrato + cobro 50/30/20 (existe en venta/contrato.md) · factura electrónica cuando formalices

## 4. ¿EL BOT CONCRETA VENTAS? — LA VERDAD

**No vende solo, y está bien:** califica, agenda (Calendly + lead), deriva a humano y responde 24/7. El cierre es tuyo (llamada → propuesta → anticipo). Es exactamente lo que la política de Meta exige (disclosure + handoff humano) y lo que el mercado compra. **Un bot que "cierra solo" sin humano = riesgo de baneo y clientes enojados.**

## 5. ¿CUBRE A CLIENTES DE DIFERENTE TIPO Y ESCALA?

| Tipo de cliente | Cobertura | Acción necesaria |
|---|---|---|
| Pyme local (1 sede) | ✅ | Prompt con sus datos + número + tarjeta |
| Multi-sede (Don Pedro, LD_STOROS) | ✅ | Prompt multi-sede + Calendly + derivación |
| Servicios/citas (clínicas, gimnasios) | ✅ | Prompt + Calendly (su enlace) + leads |
| Comercio/e-commerce | ⚠️ | Sin catálogo en chat aún → texto con precios (v2: catálogo) |
| Volumen alto (500+ msgs/día) | ✅ | Límite 250/día inicial → verificación del negocio para escalar |
| 10+ clientes | ⚠️ | 1 workflow por cliente (30-45 min) → luego router multi-tenant |

## 6. VERDADES ABSOLUTAS (las que importan)

1. **Tu sistema técnico está listo para vender** — el cuello de botella NO es el bot, es el ONBOARDING Meta de cada cliente (número, tarjeta, verificación): documéntalo como SOP antes del cliente #1.
2. **El token temporal es tu mayor riesgo operativo** — System User ANTES de cualquier cliente.
3. **Los 8 silenciosos de hoy no son "no"** — son toque 1 de 5. La cadencia de seguimiento decide tu éxito, no el primer mensaje.
4. **La plantilla del bot es un esqueleto robusto** — el músculo (datos del negocio del cliente) se entrena por cliente en 20-40 min. Nunca entregues un cliente sin su prompt personalizado.
5. **El mercado paga por resultado, no por tecnología** — vende diagnóstico+ROI (modelo Ventiva), reportes y "contesta 24/7", no "n8n + DeepSeek".
6. **La oferta de entrada barata ($490K/$290K) es la llave del volumen** — sin ella compites solo en la capa premium.
