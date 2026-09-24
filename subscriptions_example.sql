-- 구독 등록 테이블 예시 (실제 subscriptions 테이블에 plan_type 없다길래 추가 형태로 시안 짬)
-- 팀 논의용: "개별로 등록" vs "이미 결합으로 등록"을 구분하는 컬럼이 핵심

create table if not exists subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  service_id text not null references standalone_offers(id), -- 자유텍스트 금지, 슬러그로 고정 (오타 매칭 실패 방지)
  plan_type text not null check (plan_type in ('개별', '결합')),
  bundle_provider text,                    -- plan_type='결합'일 때만: SKT/KT/LG U+/쿠팡/NAVER 등, 어디 결합으로 묶었는지
  price integer,
  created_at timestamptz not null default now(),

  constraint bundle_provider_required check (
    (plan_type = '결합' and bundle_provider is not null)
    or (plan_type = '개별' and bundle_provider is null)
  )
);

-- 예시 데이터: standalone_offers에 넷플릭스만 있다고 가정 (KT/LG U+ 대상 서비스는 카탈로그 채운 뒤 같은 방식)
insert into subscriptions (user_id, service_id, plan_type, bundle_provider, price) values
  ('11111111-1111-1111-1111-111111111111', 'netflix-standard', '개별', null, 13500);  -- 결합 가능(SKT) → benefit_matches에 떠야 함
-- ('...', 'disney-plus-standard', '개별', null, 9900),   -- disney-plus-standard를 standalone_offers에 추가하면 활성화
-- ('...', 'tving-basic',          '결합', 'KT',  0);     -- 이미 결합이면 plan_type='결합'이라 매칭 대상에서 자동 제외
