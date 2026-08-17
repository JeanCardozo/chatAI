# HOJA DE RUTA — VENTAS + MARKETING + SISTEMA (desde 2026-08-15)
**Meta: 1er cliente en 7 días · 3-5 clientes en 30 días · volumen con contenido + ads.**

## 1. CONTACTOS (diario, bloque 09:00-12:30 intocable)
- [ ] 10 mensajes/día (prospectos del 04-PROSPECTOS.md + nuevos por vertical)
- [ ] Cadencia 5 toques: día 2-5-9-15-30 (variantes emocionales del 04-PROSPECTOS)
- [ ] Responder CUALQUIER respuesta en <15 min (regla de oro del mercado)
- [ ] Quien responda → Llamada (4 preguntas: dolor/costo/decisor/plazo) → demo → propuesta ≤48h → anticipo 50%
- [ ] 3 referidos por cierre

## 2. TIKTOK + YOUTUBE (donde te mueves)
**Perfil TikTok (bio-embudo):** "Saco negocios del modo manual. IA para WhatsApp que responde, agenda y vende. ↓ Escríbenos, respondemos al instante" + wa.me/573118931609
**Perfil YouTube:** mismos pilares; videos largos = tutoriales (30-60s shorts + 1 tutorial/semana)
**5 pilares de contenido:**
1. Anti-baneo ("así te blindas con la API oficial")
2. Precios abiertos ("¿Cuánto cuesta un asistente IA? De $80K a $2.8M")
3. Resultado real (demo del bot + lead en Telegram)
4. El reporte semanal (diferencial — nadie lo muestra)
5. Educación 30s ("así se hace un bot que no banea")
**Cadencia:** 1 video/día (mínimo 5/semana) · identidad fija "JeanCRG | IA para negocios" · hook en los primeros 2 segundos · CTA wa.me en cada video.

## 3. CAMBIOS DEL SISTEMA (en orden de impacto)
1. **Nombre del producto** (propuesta: NOVA) — nombre en el saludo del bot, reporte y materiales
2. **Verificar el número 3118931609** (API: register + request_code + verify_code) → bot responde como NativaSoft
3. **Método de pago** en el WABA (tarjeta) — política 2026: sin tarjeta no se envían mensajes
4. **System User + token permanente** (token actual muere en horas)
5. **Plantillas Meta** (bienvenida, recordatorio) para seguimiento fuera de 24h
6. **Follow-up automatizado** 5 toques en n8n (cuando el número real esté activo)
7. **Oferta exprés** ($490K setup + $290K/mes) — capa de volumen
8. **Reporte por cliente** (copiar workflow + tenant + Telegram del cliente)
9. **Landing mínima** (opcional): "Tu negocio responde solo en 5 días" + botón wa.me
10. **SOP de onboarding** aplicado a cada cliente (docs/SOP-ONBOARDING-CLIENTE.md)

## 4. ESTADO TÉCNICO (verificado 15-ago)
- ✅ Bot pipeline 20 nodos · ✅ modelo **mimo-v2.5** (OpenCode GO, verificado E2E) · ✅ leads + alertas + reporte
- ⏳ Número 3118931609: en WABA NativaSoft (asset 2287975608619879, phone number ID 1233977583130635), estado "Sin conexión" → falta register+verificación
- ❌ Token API expirado → regenerar (consola → Generar token → WABA NativaSoft) → yo hago register+SMS+verify por API
