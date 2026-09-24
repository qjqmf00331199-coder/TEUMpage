-- 결합 상품 카탈로그
create table if not exists bundle_offers (
  id uuid primary key default gen_random_uuid(),
  product_name text not null,                 -- 'SKT & Netflix 결합상품'
  vendor text not null,                        -- SKT / KT / LG U+ / 쿠팡 / Naver
  matched_services text[] not null default '{}', -- standalone_offers.id 배열! 표시용 브랜드명 넣지 말 것 (오타·표기흔들림 방지)
  category text not null check (category in ('통신사 결합', '커머스 멤버십', '카드 혜택')),
  icon text,
  card_title text,
  card_body text,
  plan_type text not null default '결합',
  price_bundled integer,          -- 결합 최종가
  price_vendor integer,           -- 결합상품 자체(통신 요금제/멤버십) 가격
  price_matched_services integer, -- 매칭 서비스 정가 표시용
  price_discount integer,         -- 할인액
  notice text,
  official_url text,
  event_enddate date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists bundle_offers_matched_services_idx on bundle_offers using gin (matched_services);

-- 예시 데이터: matched_services는 반드시 standalone_offers.id 값으로 (아래는 넷플릭스만 카탈로그에 있는 상태 가정)
insert into bundle_offers (product_name, vendor, matched_services, category, icon, card_title, card_body, price_discount, official_url) values
('SKT & Netflix 결합상품', 'SKT', '{netflix-standard}', '통신사 결합', '🎬', '결합하면 넷플릭스 공짜', 'SKT 우주패스 결합 혜택', 13500, null);
-- KT/LG U+/쿠팡/Naver 행은 해당 서비스가 standalone_offers에 등록된 뒤 같은 방식으로 추가
-- KT는 티빙·지니·밀리 "하나 골라" 이므로 matched_services에 3개 슬러그 다 넣기: '{tving-basic,genie-music,millie-library}'
