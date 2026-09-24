-- 실제 Supabase 스키마(services/bundles/bundle_items/subscriptions) 기준으로 다시 짠 버전.
-- 이전에 만든 standalone_offers/bundle_offers는 실제 DB에 없는 가상 테이블이었음 — 이 파일로 교체.
--
-- 현재 실측: bundles=0, bundle_items=0, services=0 → 카탈로그가 비어있어 이 뷰는 지금 아무 것도 안 나옴.
-- 결합상품 데이터를 services/bundles/bundle_items에 채워야 실제로 동작함.
create or replace view benefit_matches as
select
  s.account_id,
  b.id as bundle_id,
  b.name as bundle_name,
  array_agg(sv.name order by sv.name) as current_services,
  sum(s.amount) as current_total,
  b.amount as bundle_amount,
  sum(s.amount) - b.amount as potential_savings
from subscriptions s
join services sv on sv.id = s.service_id
join bundle_items bi on bi.service_id = s.service_id
join bundles b on b.id = bi.bundle_id
where s.subscription_type = 'single'   -- 관측된 유일한 값. 결합용 값이 'bundle'인지 팀 확인 필요 (CHECK 제약이 없어 강제 안 됨)
  and s.bundle_id is null              -- 이미 그 번들에 속한 구독이면 재추천 제외
group by s.account_id, b.id, b.name, b.amount;

-- 선행 조건 (지금 전부 비어있어서 매칭이 안 되는 이유):
-- 1. services에 실제 서비스 로우가 있어야 함 (0건)
-- 2. bundles + bundle_items에 결합상품과 그 안에 포함된 서비스가 연결돼 있어야 함 (0건)
-- 3. subscriptions.service_id가 채워져야 함 (현재 19건 전부 null) → 구독 등록 화면에서 서비스 선택 시 service_id를 실제로 저장하는 코드가 붙어있는지 확인 필요
