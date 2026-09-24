-- PRD 7-4: "AI가 이미지에서 추출한 구독 정보는 사용자 확인 전까지 임시값으로 처리한다"
-- 실제 ocr_uploads 테이블엔 item_count(개수)만 있고, 추출된 값 자체를 담을 곳이 없음 → 이 테이블이 그 빈 곳.
create table if not exists ocr_upload_items (
  id text primary key default ('ocri_' || substr(md5(random()::text), 1, 10)), -- 기존 테이블들 id 스타일(acc_, ocr_ 접두사)에 맞춤
  upload_id text not null references ocr_uploads(id) on delete cascade,
  account_id text not null references accounts(id),

  -- AI가 뽑은 원본 후보값 (사용자가 확인/수정하기 전 상태)
  extracted_name text,
  extracted_amount numeric,
  extracted_cycle text,
  extracted_next_pay date,
  confidence numeric,          -- 0~1, AI 추출 신뢰도 (낮으면 UI에서 '확인 필요' 표시용)

  -- 사용자가 수정한 최종값 (수정 안 했으면 extracted_* 그대로 복사해서 씀)
  final_name text,
  final_amount numeric,
  final_cycle text,
  final_next_pay date,

  status text not null default 'pending' check (status in ('pending', 'confirmed', 'rejected')),
  subscription_id text references subscriptions(id), -- confirmed 되는 순간 실제 생성된 subscriptions row와 연결

  created_at timestamptz not null default now(),
  confirmed_at timestamptz
);

create index if not exists ocr_upload_items_upload_id_idx on ocr_upload_items (upload_id);
create index if not exists ocr_upload_items_status_idx on ocr_upload_items (status);

-- 사용 흐름:
-- 1. 이미지 업로드 → ocr_uploads 1행 생성 + AI 파싱 결과를 ocr_upload_items에 status='pending'으로 N행 insert
-- 2. 사용자가 확인 화면에서 수정 → final_* 컬럼 update (subscriptions에는 아직 안 들어감)
-- 3. 사용자가 최종 확인 버튼 클릭 → 그때 subscriptions insert하고, 이 행 status='confirmed' + subscription_id 채움
-- 4. 사용자가 등록 안 함 선택 → status='rejected'로만 남기고 subscriptions에는 아무것도 안 생김
-- 이렇게 하면 "사용자가 최종 확인하기 전에는 구독 정보를 확정하거나 목록에 반영하지 않는다" 정책이 DB 레벨에서도 보장됨
