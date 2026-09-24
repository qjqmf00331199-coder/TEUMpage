-- Supabase(Postgres) 혜택(benefits) 테이블
create table if not exists benefits (
  id uuid primary key default gen_random_uuid(),
  brand text not null,
  category text not null check (category in ('통신사 결합', '커머스 멤버십', '카드 혜택')),
  card_title text not null,
  card_body text,
  plan_type text not null check (plan_type in ('단독', '결합')),
  price_standalone integer,
  price_bundled integer,
  apply_method text,
  notice text,
  official_url text,
  expires_at date,
  matched_services text[] not null default '{}', -- 이 혜택으로 대체/절약되는 서비스명 (subscriptions.service_name과 매칭)
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists benefits_category_idx on benefits (category);
create index if not exists benefits_expires_at_idx on benefits (expires_at);
create index if not exists benefits_matched_services_idx on benefits using gin (matched_services);

-- updated_at 자동 갱신
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists benefits_set_updated_at on benefits;
create trigger benefits_set_updated_at
before update on benefits
for each row execute function set_updated_at();

-- RLS: 읽기는 전체 공개, 쓰기는 서비스 롤만 (어드민 페이지/서버에서만 insert/update)
alter table benefits enable row level security;

create policy "benefits_select_public" on benefits
  for select using (true);
