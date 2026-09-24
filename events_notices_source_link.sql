-- events/notices가 구독·혜택 어디서 파생됐는지 추적 불가능한 문제 보완.
-- 지금은 title/body 문자열만 있어서, 구독 금액이 바뀌면 이미 만들어둔 event/notice 행은 안 바뀜(데이터 드리프트).
alter table events  add column if not exists subscription_id text references subscriptions(id) on delete cascade;
alter table notices add column if not exists subscription_id text references subscriptions(id) on delete cascade;
alter table notices add column if not exists benefit_id      text references benefits(id) on delete cascade;

-- null 허용이라 기존 행엔 영향 없음. 새로 만드는 결제일 이벤트/알림부터 이 컬럼 채우면
-- "이 구독 금액 바뀌었을 때 관련 이벤트/알림도 같이 갱신" 로직을 짤 수 있음.
