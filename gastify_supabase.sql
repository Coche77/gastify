-- Ejecutar en Supabase > SQL Editor, dentro de TU proyecto.
-- Solo cada usuario autenticado puede acceder a su propia información.
create table if not exists public.gastify_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  content jsonb not null default '{"config":null,"gastos":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.gastify_data enable row level security;
revoke all on public.gastify_data from anon;
grant select, insert, update, delete on public.gastify_data to authenticated;

drop policy if exists "gastify_own_select" on public.gastify_data;
drop policy if exists "gastify_own_insert" on public.gastify_data;
drop policy if exists "gastify_own_update" on public.gastify_data;
drop policy if exists "gastify_own_delete" on public.gastify_data;
create policy "gastify_own_select" on public.gastify_data for select to authenticated using ((select auth.uid()) = user_id);
create policy "gastify_own_insert" on public.gastify_data for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "gastify_own_update" on public.gastify_data for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "gastify_own_delete" on public.gastify_data for delete to authenticated using ((select auth.uid()) = user_id);
