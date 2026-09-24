# 틈(TEUM) 온보딩 페이지

> **구독도 일정도, 빈틈없이.**
> 스파르타 PM 7기 3조 최종 프로젝트 — 구독 관리 앱 **틈**의 온보딩(사용법 체험) 웹페이지.

- 배포: https://teumpaga.vercel.app (Vercel 프로젝트 `teumpaga`)
- 실제 앱(CTA 목적지): https://myteum.vercel.app/
- 본체: **`index.html` 한 파일** (CSS·JS 전부 인라인, 빌드 없음) + `assets/`

---

## 1. 무엇을 위한 페이지인가

처음 온 사람이 **폰 목업 속 실제 틈 화면을 직접 눌러보며 30초 만에 사용법을 익히게** 하는 페이지.

| 이것이다 | 이것이 아니다 |
| --- | --- |
| 학습·체험용 온보딩 | 가입 전환용 랜딩 페이지 |
| 프론트만 있는 인터랙티브 데모 | 실제 등록 폼 (백엔드·전송·저장 없음, 토스트만 뜸) |
| 학원(스파르타) 프로젝트 | 실서비스 — **실제 쿠폰·리워드·경품 약속 금지**, 참여 유도는 페이지 안에서만 |

---

## 2. 페이지 구성 (위→아래)

| 섹션 | id/class | 내용 |
| --- | --- | --- |
| 첫 화면 | `section.stage#top` | 좌: 제목 "처음이라면, 폰 화면을 눌러보세요." + 4단계 가이드 버튼 / 중: **폰 목업(390×844 비율, 화면에 맞게 스케일)** / 우: 마스코트 "아래에 더 있어요" 표지판. 우상단 `30초 체험하기 n/4` CTA(4단계 다 보면 `틈 바로 시작하기 →`로 바뀜), 다크모드 토글 |
| 계산기 | `section.calc#calc` | 쓰는 구독 서비스를 눌러 결합상품 대비 절약액 계산 |
| 문제 제기 | `section.why` | 통계 카드 4장(48% / 15% / 82% / 54.2%) + 출처 |
| AI 점검 원리 | `section.match` | 1 구독 등록 → 2 AI 점검 → 3 아낄 금액 확인 + 예시(네이버플러스+스포티파이) |
| 마무리 | `section.end` | 마스코트 + 슬로건 + `틈 바로 시작하기 →` |
| 이탈 확인 | `dialog#ask` | 체험 덜 본 채 끝 CTA 누르면 한 번만 "30초만 보고 가실래요?" 바텀시트(드래그로 닫기) |

### 폰 목업 안 (Figma `01_Home` 재현, px ÷ 2.3077)
- 홈: 프로모 배너, 주간 캘린더(2026년 8월), **이번 달 구독비 71,700원**, 새는 구독 경고(주황), MY 결제일(Netflix/ChatGPT), 하단 탭바
- **코치 투어 4단계** (`STEPS` 배열): 이번 달 구독비 → MY 결제일 → + 버튼 → AI 혜택 점검. 폰이 화면에 60% 보이면 0.7초 뒤 자동 시작
- `+` FAB → 스피드다이얼(구독/일상, 캡처·음성·직접 입력 흐름)
- `구독비 점검받기` / 혜택 탭 → AI 혜택 점검 화면(`openBn`)
- 새로고침 시 진행 상황 초기화(의도적, 저장 안 함). 테마 선택만 `localStorage["teum-theme"]`에 저장

---

## 3. 디자인 시스템

- **폰트**: 본문 `Dunggeunmiso`(학교안심 둥근미소, KERIS, `assets/fonts/*.woff2` 자체 호스팅) → 폴백 Apple SD Gothic Neo / Malgun Gothic. Noto Sans KR(Google Fonts)도 로드
- **톤**: 토스 계열의 밝은 블루 + 흰 카드, 새는 돈만 주황으로 강조
- **마스코트**: "틈끼" (`assets/figma/teumkki/*.webp` — ask, ai, card, cry, heart, ok, shock, sleepy, sub, sign-more 등 표정별)
- **배경**: `assets/figma/web-bg.jpg` (Figma `SP-ServPG`)

### 색 토큰 (`:root`)
| 토큰 | 값 | 용도 |
| --- | --- | --- |
| `--primary` | `#3182f6` | 버튼·강조 |
| `--blue` / `--blue-deep` | `#2576f2` / `#245fd5` | 폰 UI 블루 / hover |
| `--ink` / `--muted` | `#14171c` / `#667085` | 본문 / 보조 글자 |
| `--leak` / `--leak-bg` | `#ff7700` / `#faecd5` | "새는 구독" 경고 |
| `--p-*` | 라이트/다크 전환되는 페이지 토큰 | 배경·카드·선·그림자 |

### 다크 모드 (유지 필수)
- OS 설정 따라감(`prefers-color-scheme`) + 토글로 강제(`html[data-theme=dark|light]`)
- 다크 값: `--p-bg:#0b101a`, `--p-card:#131a27`, `--p-ink:#eef2f8`, `--p-line:#243148`
- 전환은 View Transition 크로스페이드

### 모션
- 이징 토큰: `--ease-out`, `--ease-in-out`, `--ease-drawer`, `--spring`(linear())
- 스크롤 등장 애니메이션(IntersectionObserver, `.rv` → `.in`)
- `prefers-reduced-motion` 존중 — 이동 대신 페이드

### 반응형 브레이크포인트
`1180px` · `900px` · `760px`(이하: 폰 목업 전체폭) · `520px` · `420px` · 높이 `500px`/`360px`

---

## 4. 작업 규칙 (다른 노트북에서 이어서 할 때)

1. **1920×1080 데스크톱 기준으로 먼저 확인**, 그다음 반응형(모바일)·다크모드 확인
2. 다크 모드 깨뜨리지 말 것 — 새 색은 `--p-*` 토큰으로 라이트/다크 둘 다 정의
3. 실제 보상·쿠폰 약속 문구 금지 (학원 프로젝트)
4. 큰 수정 전 백업은 `_old/index.backup-<이름>.html`로 (배포 제외 폴더)
5. 답변·주석·문구는 한국어

### 로컬 실행
빌드 없음. 정적 서버만 있으면 됨 (`.claude/launch.json`의 `static-preview`와 동일):

```bash
npx -y serve -l 5173 .
```

→ http://localhost:5173

### 배포
Vercel. `.vercelignore`가 문서·데이터·백업·에이전트 설정을 배포에서 제외함.
새 노트북에서는 `npx vercel link`로 `teumpaga` 프로젝트에 다시 연결 (`.vercel/`, `.env.local`은 git에 없음).

---

## 5. 폴더 안내

| 경로 | 내용 |
| --- | --- |
| `index.html` | **현재 온보딩 페이지 (본체)** |
| `assets/figma/` | Figma에서 뽑은 홈 UI 조각(`home/`), 흐름 화면(`flow/`), 마스코트(`teumkki/`), 배경 |
| `assets/services/` | 구독 서비스 로고 98개 (계산기·목록용) |
| `assets/fonts/` | 둥근미소 폰트 |
| `assets/og-preview.jpg` | 링크 공유 미리보기 이미지 (1200×634) |
| `SPEC_00~03_*.md` | 초기 명세서 (9월 8일). ⚠️ **초기 버전(스크롤형) 기준이라 현재 `index.html`과 다른 부분 있음** — 문구·규칙 참고용, 실제 동작은 `index.html`이 정답 |
| `teum_landing_copy*.md`, `teum_icp_keywords.json` | 카피·타깃 키워드 기획 자료 |
| `*.sql`, `*.csv` | 혜택·결합상품 데이터 설계(Supabase용 초안) |
| `teum_deck.html`, `teum_home.html` | 발표 덱 / 홈 화면 시안 |
| `email/` | 비밀번호 재설정 이메일 템플릿 (개발자 전달용) |
| `_old/` | 구버전 온보딩·단계별 백업 |
| `.claude/`, `.agents/` | Claude Code 프로젝트 설정·디자인/애니메이션 스킬 |
