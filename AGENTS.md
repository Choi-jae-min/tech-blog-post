# AGENTS.md — tech-blog-post

> 공유 에이전트 가이드. Claude Code·Codex·Cursor·Gemini CLI·Grok Build(x.ai)가 이 파일을
> 컨텍스트로 로드한다. 워크플로의 권위적 문서는 `SKILL.md`다 — 이 파일은 그것을 각 호스트가
> 언제, 어떻게 찾아 따라야 하는지 안내하는 역할만 한다.

## 역할

이 저장소는 "작업 중 쌓인 기술적 경험을 SEO 최적화된 블로그 글 초안으로 만드는" 스킬 하나를
제공한다. 사용자가 "이거 블로그 글로 써줘", "이 주제로 포스팅해줘", "SEO 최적화해서 써줘",
"지난 [기간] 동안 한 거 글로 만들어줘" 같은 요청을 하면 `SKILL.md`의 단계(0단계 주제/범위
확정부터 6단계 HTML 저장까지)를 그대로 따른다.

## SKILL.md를 찾는 위치

호스트마다 스킬 디렉토리 탐색 규칙이 달라서 실제 파일 위치가 다르게 보일 수 있다. 아래 중
먼저 발견되는 것을 권위적 문서로 쓴다 — 내용은 전부 같다(심볼릭 링크).

- 저장소 루트 `SKILL.md` (git clone으로 직접 설치했을 때)
- `.codex/skills/tech-blog-post/SKILL.md` (Codex 프로젝트 로컬)
- `plugins/tech-blog-post/skills/tech-blog-post/SKILL.md` (Codex 마켓플레이스 설치)
- `.cursor/skills/tech-blog-post/SKILL.md` (Cursor — `.cursor/skills/`·`.agents/skills/`를 전역·프로젝트 양쪽에서 읽음)
- `.grok/skills/tech-blog-post/SKILL.md` (Grok Build — `.grok/skills/` 및 `~/.grok/skills/`)
- `.claude/skills/tech-blog-post/SKILL.md` (Claude Code 프로젝트 로컬 설치. Grok Build도 `.claude/`를 zero-config로 읽음)

## 호스트별 의존 스킬 (없으면 조용히 건너뛴다)

`SKILL.md`의 두 단계는 다른 Claude Code 플러그인에 의존한다. 그 플러그인이 없는 호스트에서는
해당 단계를 건너뛰고 나머지 단계만으로 글을 완결한다 — 사용자에게 설치를 재촉하지 않는다.

- **5단계(문장 다듬기)**: `elements-of-style`의 `writing-clearly-and-concisely` 스킬. Claude
  Code에서 이 플러그인을 설치했을 때만 쓸 수 있다. 없으면 이 단계 없이 직접 문장을 간결하게
  다듬는다.
- **4-1단계(개념 이미지 생성, 선택)**: `runway-api`의 `rw-generate-image` 스킬 + 환경변수
  `RUNWAYML_API_SECRET`. 플러그인 자체가 없으면 조용히 건너뛴다. 플러그인은 있는데 키만
  없으면 이번 실행에서 한 번만 물어본다(자세한 문구는 `SKILL.md` 4-1단계 참고).

## 출력 위치

산출물은 호스트와 무관하게 항상 사용자가 작업 중인 프로젝트의 `posts/{slug}.html`(필요하면
`posts/{slug}.md`도)이다 — 이 저장소(스킬 정의 자체)가 아니라 **사용자가 지금 열어둔
프로젝트**에 쓴다.

## 설치

호스트별 설치 방법은 `README.md`의 "설치" 절을 따른다. 한 번에 설치하려면 `install.sh`를 쓴다.
