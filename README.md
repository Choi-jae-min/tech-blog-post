# tech-blog-post

작업 중 쌓인 기술적 경험을 SEO 최적화된 블로그 글 초안으로 만들어주는 Claude Skill.

같은 문제를 겪은 사람이 검색해서 들어와 끝까지 읽고 해결할 수 있는 글, 그리고 검색엔진이
그 문제의 답으로 인식할 수 있는 구조. 이 둘을 같이 챙기기 위한 스킬입니다.

## 수집하는 것

주제/키워드 기준으로 모읍니다 — 하루 단위가 아니라 주제 단위입니다.

- Claude와 나눈 대화 (막혔던 지점, 여러 안을 놓고 고민한 흔적)
- 관련 git 커밋과 변경 내용 (단일 세션이면 최근 것, 누적 주제면 확정한 기간 전체)
- 관련 문서
- 타겟 키워드로 지금 상위 노출되어 있는 글들 (다뤄야 할 항목을 빠뜨리지 않고, 차별화 지점을 잡기 위해)
- `posts/index.json`에 쌓인 이 블로그의 기존 글 (중복 주제 체크 + 내부 링크 후보)

## 만들어지는 것

`posts/{영문-slug}.html` 파일 하나가 기본 산출물입니다 — 티스토리 등 블로그의 **HTML 편집
모드**에 그대로 붙여넣는 용도로, 모든 스타일이 인라인으로 박혀 있습니다. 마크다운 플랫폼이
필요하면 같은 내용을 `posts/{영문-slug}.md`로도 만듭니다.

글 유형에 따라 본문 구조가 다릅니다.

| 유형 | 구조 |
|---|---|
| 트러블슈팅 | 문제 상황 → 원인 → 해결 방법 → 검증 → 정리 |
| 개념정리 | 개념이란? → 언제 쓰나 → 사용법 → 주의할 점 → 정리 |
| 비교분석 | A/B란? → 실제로 비교해보니 → 언제 뭘 쓰나 → 정리 |
| 튜토리얼 | 무엇을 만드나 → 사전 준비 → Step 1~N → 실행 확인 → 정리 |

제목·태그·카테고리·메타 설명(150자 이내)·핵심 키워드 배치까지 SEO를 고려해 같이 만들고,
저장 직전에 제목 길이·메타 설명 글자수·키워드 등장 횟수·이미지 alt·헤딩 위계를 실제로
세어서 검증합니다(5-1단계).

핵심 개념을 표현하는 이미지도 1장 생성해 `posts/images/{slug}-concept.png`로 같이 넣습니다
(`runway-api`가 `elements-of-style`처럼 의존성으로 자동 설치됩니다). API 키가 없으면 지금
설정할지, 이번엔 이미지 없이 계속할지 한 번 물어봅니다.
자연스러운 질문이 2~3개 이상 나오면 FAQ 섹션도 넣고, 그 내용으로 `posts/{slug}.schema.json`에
schema.org `FAQPage` 구조화 데이터를 별도 파일로 만듭니다(블로그 에디터가 `<script>`를 걸러내서
본문에는 못 넣습니다 — 스킨 편집 등 페이지 전역 HTML을 지원하는 블로그에서만 활용 가능).
코드블록은 키워드·문자열·주석·숫자 정도를 인라인 `<span>` 색상으로 선택적으로 강조합니다.

글을 저장할 때마다 `posts/index.json`에 제목·태그·메타 설명을 기록합니다. 다음 글을 쓸 때
이 파일로 비슷한 주제가 이미 있는지 확인하고(중복/카니발라이제이션 방지), 태그가 겹치는
기존 글을 찾아 "마무리" 문단에 내부 링크로 자동 추천합니다.

## 사용법

```
이거 블로그 글로 써줘
이 주제로 블로그에 올릴 글 정리해줘
지난 2주간 삽질한 거 블로그 포스트로 만들어줘
SEO 최적화해서 써줘
```

주제가 하나의 세션/작업 안에서 끝나는지, 여러 날에 걸친 작업을 모아야 하는지 애매하면
스킬이 먼저 물어봅니다.

## 설치

Claude Code · Codex · Cursor · Gemini CLI · Grok Build를 지원합니다. 한 번에 설치하려면:

```bash
curl -fsSL https://raw.githubusercontent.com/Choi-jae-min/tech-blog-post/main/install.sh | bash
```

호스트별 CLI(`claude`/`codex`/`gemini`)가 감지되면 그 CLI로 설치합니다. Grok Build와 Cursor는
전역 스킬 폴더(`~/.grok/skills/`, `~/.cursor/skills/`)를 읽으므로, 해당 CLI가 있거나 그 설정
폴더(`~/.grok`·`~/.cursor`)가 이미 있으면 그 경로에 clone합니다 — 안 쓰는 호스트의 홈에는
폴더를 만들지 않습니다.

수동으로 설치하려면 호스트별로:

**Claude Code (git clone)**

```bash
git clone https://github.com/Choi-jae-min/tech-blog-post.git \
  ~/.claude/skills/tech-blog-post
```

**Claude Code (플러그인 마켓플레이스, 권장)**

```
/plugin marketplace add Choi-jae-min/tech-blog-post
/plugin install tech-blog-post@tech-blog-post-marketplace
```

이 방식으로 설치하면 문장을 다듬어주는 `elements-of-style`(`writing-clearly-and-concisely`
스킬)이 의존성으로 자동 설치됩니다 — 따로 설치할 필요가 없습니다. Codex·Cursor·Gemini
CLI·Grok Build에는 이 의존성 자동 설치가 없으므로, 그 스킬이 없으면 문장 다듬기 단계를
조용히 건너뛰고 나머지 단계만으로 글을 완결합니다.

**Codex**

```
codex plugin marketplace add Choi-jae-min/tech-blog-post --sparse .agents/plugins
codex plugin add tech-blog-post@tech-blog-post-marketplace
```

Codex는 Claude Code와 규격이 달라서, 마켓플레이스 매니페스트를 `.agents/plugins/marketplace.json`에서
읽고 플러그인은 `plugins/tech-blog-post/` 아래(`.codex-plugin/plugin.json` + `skills/`)에서 찾습니다.
저장소에 그 구조를 따로 두었습니다.

**Gemini CLI**

```bash
gemini extensions install https://github.com/Choi-jae-min/tech-blog-post
```

**Grok Build**

```bash
git clone https://github.com/Choi-jae-min/tech-blog-post.git ~/.grok/skills/tech-blog-post
```

**Cursor**

전역(모든 프로젝트에서 사용):

```bash
git clone https://github.com/Choi-jae-min/tech-blog-post.git ~/.cursor/skills/tech-blog-post
```

특정 프로젝트에만:

```bash
git clone https://github.com/Choi-jae-min/tech-blog-post.git .cursor/skills/tech-blog-post
```

Cursor는 전역 `~/.cursor/skills/`·`~/.agents/skills/`와 프로젝트 `.cursor/skills/`·`.agents/skills/`를
스킬 경로로 읽습니다(폴더 이름이 스킬 이름이 됩니다). 이 저장소를 그 경로에 두면 바로 인식됩니다.

**Claude.ai / 데스크톱 앱**

설정 → Capabilities → Skills에서 이 폴더를 업로드합니다.

## 여러 호스트 지원 구조

`SKILL.md`가 유일한 권위적 문서입니다. 호스트마다 스킬을 찾는 경로가 달라서, 저장소
루트의 `SKILL.md`를 가리키는 심볼릭 링크를 각 경로에 둡니다 — 내용은 하나뿐이고
링크만 여러 개입니다.

| 경로 | 대상 |
|---|---|
| `SKILL.md` | 실제 파일 (권위 원본) |
| `.claude/skills/tech-blog-post/SKILL.md` | → `SKILL.md` (Grok Build도 `.claude/`를 zero-config로 읽음) |
| `.codex/skills/tech-blog-post/SKILL.md` | → `SKILL.md` (Codex 프로젝트 로컬 스킬 경로) |
| `.cursor/skills/tech-blog-post/SKILL.md` | → `SKILL.md` |
| `.grok/skills/tech-blog-post/SKILL.md` | → `SKILL.md` |
| `plugins/tech-blog-post/skills/tech-blog-post/SKILL.md` | → `SKILL.md` (Codex 마켓플레이스 설치 경로) |

Codex 마켓플레이스로 설치할 때는 `.agents/plugins/marketplace.json`이 `plugins/tech-blog-post/`를
플러그인 루트로 가리키고, 그 안의 `.codex-plugin/plugin.json`이 `skills` 필드로 위 심볼릭 링크를
스킬로 노출합니다.

`AGENTS.md`는 Codex·Cursor·Gemini CLI·Grok Build가 세션 시작 시 읽는 공유 컨텍스트
파일로, 위 경로 안내와 호스트별로 없을 수 있는 의존 스킬(`elements-of-style`,
`runway-api`) 처리 방침만 담습니다 — 워크플로 자체는 여전히 `SKILL.md`가 권위 문서입니다.
Gemini CLI는 `gemini-extension.json`의 `contextFileName`으로 이 파일을 로드합니다.

심볼릭 링크라 Windows에서 이 저장소를 그대로 체크아웃하면(개발자 모드나 관리자 권한 없이는)
링크가 대상 경로가 적힌 일반 텍스트 파일로 받아들여집니다 — 로컬에서 실제로 폴더처럼
동작하게 하려면 Windows 설정에서 개발자 모드를 켜고 다시 체크아웃해야 합니다. macOS·Linux나
개발자 모드가 켜진 Windows에서 clone하면 정상적인 심볼릭 링크로 받아집니다.

## 함께 쓰는 스킬/플러그인

| 플러그인 | 역할 | 필요 조건 |
|---|---|---|
| [`elements-of-style`](https://github.com/obra/elements-of-style) | 5단계 조립 전에 문장을 다듬음 (Strunk의 *The Elements of Style* 원칙) | 없음 — tech-blog-post 설치 시 자동으로 같이 설치됨 |
| [`runway-api`](https://github.com/anthropics/claude-plugins-public/tree/main/external_plugins/runway) | 4-1단계에서 본문 핵심 개념을 표현하는 이미지를 생성 | 없음 — tech-blog-post 설치 시 자동으로 같이 설치됨. 실제 이미지 생성엔 각자 자기 [Runway API 키](https://dev.runwayml.com/settings/api-keys)를 환경변수 `RUNWAYML_API_SECRET`로 설정해야 함 (유료) |

두 의존성 모두 `plugin.json`에 선언돼 있어 설치 자체는 자동입니다. `elements-of-style`은
무료라 바로 쓰이고, `runway-api`는 설치는 무료지만 실제 호출은 각자의 Runway 계정과 크레딧이
필요합니다 — 키가 없으면 이번 글에 이미지를 넣을지, 없이 진행할지 한 번 물어봅니다.

## 커스터마이징

`SKILL.md` 하나만 고치면 됩니다.

- 특정 블로그 플랫폼에 맞추려면 "3단계: SEO 요소 정하기"의 태그/메타 설명 규칙
- HTML 인라인 스타일(폰트·색상·여백)을 바꾸려면 "6단계: HTML로 저장"
- 개념 이미지 생성 여부·프롬프트 원칙을 바꾸려면 "4-1단계: 개념 이미지 생성"
- 중복 체크 기준(태그 vs 제목 등)을 바꾸려면 "0-1단계: 기존 글 확인"
- 글 유형을 추가/변경하려면 "2단계: 글 유형 정하기"의 표와 "4단계"의 유형별 템플릿
- 내부 링크 추천 개수·기준을 바꾸려면 "5단계: 전체 글 조립"의 "마무리" 부분
- SEO 체크리스트 기준(제목 글자수, 키워드 횟수 등)을 바꾸려면 "5-1단계: 발행 전 SEO 체크리스트"
- FAQ 섹션·구조화 데이터 조건을 바꾸려면 "4-2단계: 자주 묻는 질문"
- 코드블록 강조 색상·대상 토큰을 바꾸려면 "6단계"의 "코드블록 문법 강조" 항목
- 저장 경로를 바꾸려면 "5단계: 전체 글 조립"의 `posts/{영문-slug}`
- 본문 구조를 바꾸려면 "4단계: 유형별로 본문 작성"의 템플릿
- 발동 조건을 바꾸려면 맨 위 `description`

`SKILL.md`나 의존성(`.claude-plugin/plugin.json`)을 고쳤으면 `.claude-plugin/plugin.json`과
`marketplace.json`의 `version`도 같이 올려야 합니다 — Claude Code의 `plugin update`는 버전
문자열만 보고 최신 여부를 판단하기 때문에, 내용만 바꾸고 버전을 그대로 두면 이미 설치한
사람들에게 갱신이 반영되지 않습니다.

### 이 저장소를 직접 고칠 때

**개발 중 (push 없이 바로 확인)**

파일을 고칠 때마다 push → 재설치를 반복하지 않으려면, 이 폴더에서 세션 한정으로 바로
로드합니다. 커밋도 재설치도 필요 없이, 파일을 고친 그대로 다음 실행에 반영됩니다.

```bash
claude --plugin-dir .
```

단, 이건 이 세션에서만 유효합니다. 마켓플레이스로 설치했을 때도 잘 되는지 확인하려면
아래 방법을 거쳐야 합니다.

**배포 확인 (실제 설치 경로대로)**

1. 내용을 고쳤으면 버전부터 올립니다 — `.claude-plugin/plugin.json`과
   `.claude-plugin/marketplace.json`의 `version`. `plugin update`는 이 문자열만 비교하기
   때문에, 숫자를 그대로 두면 내용이 바뀌어도 "이미 최신"이라고 오판합니다.
2. 커밋하고 push합니다.
3. 마켓플레이스를 갱신하고, `update` 대신 강제로 지웠다 다시 깝니다 — 버전 비교 로직을
   아예 타지 않으므로 버전 올리는 걸 깜빡했을 때도 안전합니다.

   ```bash
   claude plugin marketplace update tech-blog-post-marketplace
   claude plugin uninstall tech-blog-post@tech-blog-post-marketplace
   claude plugin install tech-blog-post@tech-blog-post-marketplace
   ```

4. 위 세 줄을 매번 손으로 치기 귀찮으면, `git push` 대신 쓸 로컬 전용 alias로 묶어둡니다
   (이 저장소의 `.git/config`에만 적용되고, 다른 사람에게 배포되진 않습니다).

   ```bash
   git config --local alias.publish '!f() { git push "$@" && claude plugin marketplace update tech-blog-post-marketplace && claude plugin uninstall tech-blog-post@tech-blog-post-marketplace && claude plugin install tech-blog-post@tech-blog-post-marketplace; }; f'

   # 이후로는 git push 대신
   git publish origin main
   ```

   `git push` 자체를 이 alias로 덮어쓰지 마세요 — alias 안에서 다시 `git push`를 호출하면
   같은 alias가 또 걸려 무한 재귀에 빠집니다. 반드시 `publish`처럼 다른 이름을 씁니다.

5. 변경 사항은 **다음 Claude Code 세션부터** 반영됩니다. 이미 켜져 있는 세션은 시작 시점에
   로드해둔 스킬 정의를 그대로 쓰기 때문에, 강제 재설치까지 마쳐도 재시작 전까지는 예전
   내용이 나옵니다.

## License

MIT
