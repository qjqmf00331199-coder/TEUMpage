-- 단독(개별) 서비스 카탈로그. id를 슬러그로 써서 이게 곧 '정규화된 서비스 키'가 됨
create table if not exists standalone_offers (
  id text primary key,                 -- 'netflix-standard' 같은 슬러그. 이 값이 매칭 기준.
  brand text not null,                 -- 넷플릭스 - Standard
  category text not null,              -- OTT / 음악 / ...
  card_title text,
  card_body text,
  plan_type text not null default '단독',
  price_standalone integer not null,
  price_discount integer,
  apply_method text,
  requirement text,
  official_url text,
  event_enddate date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

insert into standalone_offers (id, brand, category, card_title, card_body, plan_type, price_standalone, apply_method, requirement, official_url, event_enddate) values
('netflix-standard', '넷플릭스 - Standard', 'OTT', '혜택상품 타이틀 문구', '혜택카드 보조문구', '단독', 13500, '공식 앱/웹 접속 후 본인인증', '예시: 결합 회선 1개당 1계정', 'https://www.netflix.com', '2026-12-31');
