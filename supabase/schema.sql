-- ============================================================
-- Skema sinkronisasi "Buku Kas Pribadi" untuk Supabase
-- Cara pakai:
--   1. Buka project Supabase Anda
--   2. Menu "SQL Editor" > "New query"
--   3. Tempel seluruh isi berkas ini, lalu klik "Run"
-- ============================================================

-- Tabel: satu baris per pengguna, berisi seluruh data buku kas (JSON)
create table if not exists public.bukukas_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

-- Keamanan: aktifkan Row Level Security
alter table public.bukukas_state enable row level security;

-- Setiap pengguna hanya boleh membaca/menulis barisnya sendiri
drop policy if exists "bukukas_select_own" on public.bukukas_state;
create policy "bukukas_select_own" on public.bukukas_state
  for select using (auth.uid() = user_id);

drop policy if exists "bukukas_insert_own" on public.bukukas_state;
create policy "bukukas_insert_own" on public.bukukas_state
  for insert with check (auth.uid() = user_id);

drop policy if exists "bukukas_update_own" on public.bukukas_state;
create policy "bukukas_update_own" on public.bukukas_state
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "bukukas_delete_own" on public.bukukas_state;
create policy "bukukas_delete_own" on public.bukukas_state
  for delete using (auth.uid() = user_id);

-- Realtime: supaya perubahan langsung terkirim ke perangkat lain
do $$
begin
  begin
    alter publication supabase_realtime add table public.bukukas_state;
  exception when duplicate_object then null;
  end;
end $$;

-- Opsional: perbarui kolom updated_at otomatis di server
create or replace function public.bukukas_touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists bukukas_state_touch on public.bukukas_state;
create trigger bukukas_state_touch
  before update on public.bukukas_state
  for each row execute function public.bukukas_touch_updated_at();
