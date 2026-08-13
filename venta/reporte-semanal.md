# Reporte semanal — [NOMBRE CLIENTE]

**Semana:** [FECHA INICIO] a [FECHA FIN]
**Generado por:** JeanCRG
**Fecha de emisión:** [FECHA]

---

## 1. Resumen de la semana

| Métrica | Valor | vs semana anterior |
|---|---|---|
| Conversaciones atendidas | [N] | [↑/↓ N] |
| % respondidas por la IA | [N%] | [N pp] |
| Leads capturados | [N] | [↑/↓ N] |
| Derivaciones a humano | [N] | [↑/↓ N] |
| Citas agendadas | [N] | [↑/↓ N] |
| Ventas estimadas por el asistente | [MONTO] COP | [↑/↓ MONTO] |

**Lectura de una línea:** [FRASE, ej.: el asistente atendió el 92% de las consultas sin intervención
y capturó 7 leads nuevos; las ventas estimadas subieron 15% vs la semana anterior].

## 2. Qué preguntaron sus clientes (top temas)

1. [TEMA, ej.: precios de [PRODUCTO]] — [N] consultas
2. [TEMA, ej.: horarios y dirección] — [N] consultas
3. [TEMA, ej.: disponibilidad de [PRODUCTO/SERVICIO]] — [N] consultas
4. [TEMA, ej.: domicilios y tiempos de entrega] — [N] consultas
5. [TEMA, ej.: citas/agendamiento] — [N] consultas

**Dato útil:** [OBSERVACIÓN, ej.: la pregunta por [PRODUCTO] subió fuerte — hay demanda que no se
está aprovechando en el mostrador].

## 3. Qué se escapó a humano

- [N] conversaciones pasaron a humano ([(%)] del total).
- Motivos principales: [MOTIVOS, ej.: precios especiales (3), quejas (2), consultas fuera de
  catálogo (2)].
- Tiempo promedio de respuesta humana: [N] minutos.
- **Acción sugerida:** [ACCIÓN, ej.: si las consultas por precios especiales son recurrentes,
  agregar una política de descuento al asistente para responder la primera fase].

## 4. Recomendaciones de la semana

1. [RECOMENDACIÓN, ej.: actualizar el catálogo: [PRODUCTO] ya no está disponible y el asistente lo
   sigue ofreciendo].
2. [RECOMENDACIÓN, ej.: responder los leads capturados en menos de 24h — el 80% de las ventas de
   esta semana se cerraron con el primer contacto rápido].
3. [RECOMENDACIÓN, ej.: revisar la franja horaria 8-10pm: es cuando más consultas entran sin
   atención humana; evaluar ampliar horario o derivación nocturna].
4. [RECOMENDACIÓN OPCIONAL].

## 5. Métricas simples (para usted)

- **Velocidad:** la IA responde en segundos; el humano, en promedio [N] minutos.
- **Cobertura:** [N%] de los mensajes recibidos fueron respondidos automáticamente.
- **Leads:** cada lead capturado vale en promedio [MONTO] COP en ventas estimadas (mes anterior:
  [MONTO]).
- **Fugas:** [N] mensajes quedaron sin respuesta clara (agendar humano o ajustar el asistente).

---

## Apéndice — Consultas SQL de ejemplo (Supabase)

Los números de este reporte se generan con consultas sobre las tablas `conversaciones`, `leads` y
`citas` del esquema multi-tenant. Ejemplos (reemplazar `:TENANT_ID` y las fechas):

```sql
-- Resumen: conversaciones de la semana por tenant
select count(*) as conversaciones,
       count(*) filter (where role = 'user') as mensajes_usuario,
       count(*) filter (where role = 'assistant') as respuestas_ia,
       count(*) filter (where role = 'human') as mensajes_humano
from conversaciones
where tenant_id = :TENANT_ID
  and created_at >= date_trunc('week', now()) - interval '1 week';

-- % respondidas por IA: share de role assistant sobre total de turnos
select round(100.0 * count(*) filter (where role = 'assistant')
       / nullif(count(*) filter (where role in ('user','assistant')), 0), 1) as pct_ia
from conversaciones
where tenant_id = :TENANT_ID
  and created_at >= date_trunc('week', now()) - interval '1 week';

-- Leads capturados en la semana
select count(*) as leads, coalesce(sum(interes is not null), 0) as con_interes
from leads
where tenant_id = :TENANT_ID
  and created_at >= date_trunc('week', now()) - interval '1 week';

-- Derivaciones a humano (conversaciones marcadas)
select count(*) as derivadas
from conversaciones
where tenant_id = :TENANT_ID
  and derivado_a_humano = true
  and created_at >= date_trunc('week', now()) - interval '1 week';

-- Citas agendadas en la semana
select count(*) as citas, count(*) filter (where estado = 'confirmada') as confirmadas
from citas
where tenant_id = :TENANT_ID
  and created_at >= date_trunc('week', now()) - interval '1 week';

-- Top temas: palabras/patrones frecuentes en mensajes de usuario
select content
from conversaciones
where tenant_id = :TENANT_ID
  and role = 'user'
  and created_at >= date_trunc('week', now()) - interval '1 week'
order by created_at desc
limit 50; -- analizar manualmente o con un segundo paso de conteo
```
