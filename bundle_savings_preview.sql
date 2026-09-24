-- 구독 등록 여부 상관없이, 결합상품이 실제로 얼마나 싸지는지 미리보기
create or replace view bundle_savings_preview as
select
  bo.id as bundle_id,
  bo.vendor,
  bo.product_name,
  bo.card_title,
  s.id as standalone_id,
  s.brand as standalone_brand,
  s.price_standalone,
  bo.price_bundled,
  s.price_standalone - coalesce(bo.price_bundled, 0) as savings
from bundle_offers bo
join standalone_offers s on s.id = any(bo.matched_services)
where bo.event_enddate is null or bo.event_enddate >= current_date;
