-- =====================================================================
-- chatAI (JeanCRG) — Multi-tenant schema for Supabase (Postgres)
-- Product: P1 WhatsApp AI Assistant (core). Reused by P2-P5.
-- Apply this file in the Supabase SQL editor (Free plan is enough).
--
-- Security note:
-- In the demo, n8n writes with the SERVICE ROLE key (server-side only).
-- For a client-facing panel, enable Row Level Security and add policies
-- scoped by tenant_id (e.g. using a JWT claim or a per-tenant token).
-- Never expose the service role key to the frontend.
-- =====================================================================

-- ---------------------------------------------------------------------
-- tenants: one row per client business. Every other table is scoped here.
-- ---------------------------------------------------------------------
create table if not exists tenants (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  vertical text,
  horario_atencion text,
  reglas_negocio jsonb default '{}'::jsonb,
  activo boolean default true,
  created_at timestamptz default now()
);

-- ---------------------------------------------------------------------
-- contactos: every WhatsApp number that ever talks to the assistant.
-- ---------------------------------------------------------------------
create table if not exists contactos (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  telefono text not null,
  nombre text,
  created_at timestamptz default now(),
  unique (tenant_id, telefono)
);

-- ---------------------------------------------------------------------
-- conversaciones: full message log per contact (user, assistant, human).
-- ---------------------------------------------------------------------
create table if not exists conversaciones (
  id bigserial primary key,
  tenant_id uuid not null references tenants(id) on delete cascade,
  contacto_id uuid not null references contactos(id) on delete cascade,
  role text not null check (role in ('user', 'assistant', 'human')),
  content text,
  metadata jsonb default '{}'::jsonb,
  derivado_a_humano boolean default false,
  created_at timestamptz default now()
);

create index if not exists idx_conversaciones_contacto_created
  on conversaciones (contacto_id, created_at desc);
create index if not exists idx_conversaciones_tenant_created
  on conversaciones (tenant_id, created_at desc);

-- ---------------------------------------------------------------------
-- leads: captured prospects (want to quote, book, or buy).
-- ---------------------------------------------------------------------
create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  contacto_id uuid not null references contactos(id) on delete cascade,
  nombre text,
  telefono text,
  interes text,
  estado text default 'nuevo' check (estado in ('nuevo', 'contactado', 'convertido', 'perdido')),
  source text default 'whatsapp',
  created_at timestamptz default now(),
  unique (tenant_id, contacto_id)
);

-- ---------------------------------------------------------------------
-- citas: appointments booked by the assistant or by a human.
-- ---------------------------------------------------------------------
create table if not exists citas (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  contacto_id uuid not null references contactos(id) on delete cascade,
  fecha_hora timestamptz,
  motivo text,
  estado text default 'pendiente' check (estado in ('pendiente', 'confirmada', 'completada', 'cancelada')),
  creada_por text default 'ia',
  created_at timestamptz default now()
);

-- =====================================================================
-- Seed demo (optional): sample tenant for local testing.
-- The TENANT_ID in .env.example must match this id so the workflow
-- writes to the right tenant out of the box.
-- =====================================================================
insert into tenants (id, nombre, vertical, horario_atencion, reglas_negocio)
values (
  'd2f0d3a0-0000-4000-8000-000000000001',
  'Comercio Demo Tolima',
  'comercio/retail',
  'Lun a Sab 8:00-20:00',
  '{"preguntas_frecuentes": ["precios", "horarios", "domicilios"], "nota": "Rellenar con FAQs reales del cliente"}'
)
on conflict (id) do nothing;

-- =====================================================================
-- Row Level Security (RLS)
-- The SERVICE ROLE key used by n8n bypasses RLS automatically, so the
-- assistant workflow keeps working unchanged. Enabling RLS with no
-- policies blocks everything for the anon key (secure by default).
-- The commented policies below are for the FUTURE client-facing panel,
-- which will use the anon key and a JWT carrying a tenant_id claim.
-- =====================================================================
alter table tenants enable row level security;
alter table contactos enable row level security;
alter table conversaciones enable row level security;
alter table leads enable row level security;
alter table citas enable row level security;

-- Example (COMMENTED OUT): per-tenant policy for a tenant-scoped table.
-- Apply the same pattern to conversaciones, leads and citas.
-- create policy "tenant_isolation_contactos" on contactos
--   for all
--   using (tenant_id = (auth.jwt() ->> 'tenant_id')::uuid)
--   with check (tenant_id = (auth.jwt() ->> 'tenant_id')::uuid);

-- tenants is the tenant itself: scope by the id claim instead.
-- create policy "tenant_isolation_tenants" on tenants
--   for select
--   using (id = (auth.jwt() ->> 'tenant_id')::uuid);
