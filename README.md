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

## 만들어지는 것

`posts/{영문-slug}.html` 파일 하나가 기본 산출물입니다 — 티스토리 등 블로그의 **HTML 편집
모드**에 그대로 붙여넣는 용도로, 모든 스타일이 인라인으로 박혀 있습니다. 마크다운 플랫폼이
필요하면 같은 내용을 `posts/{영문-slug}.md`로도 만듭니다.

글 유형에 따라 본문 구조가 다릅니다.

| 유형 | 구조 |
|---|---|
| 트러블슈팅 | 문제 상황 → 원인 → 해결 방법 → 검증 → 정리 |
| 개념정리 | 개념이란? → 언제 쓰나 → 사용법 → 주의할 점 → 정리 |

제목·태그·카테고리·메타 설명(150자 이내)·핵심 키워드 배치까지 SEO를 고려해 같이 만듭니다.
`runway-api` 플러그인이 설치돼 있고 API 키가 설정돼 있으면, 핵심 개념을 표현하는 이미지를
1장 생성해 `posts/images/{slug}-concept.png`로 같이 넣습니다 (없으면 조용히 건너뜁니다).

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

**Claude Code (git clone)**

```bash
git clone https://github.com/Choi-jae-min/-tech-blog-post.git \
  ~/.claude/skills/tech-blog-post
```

**Claude Code (플러그인 마켓플레이스, 권장)**

```
/plugin marketplace add Choi-jae-min/-tech-blog-post
/plugin install tech-blog-post@tech-blog-post-marketplace
```

이 방식으로 설치하면 문장을 다듬어주는 `elements-of-style`(`writing-clearly-and-concisely`
스킬)이 의존성으로 자동 설치됩니다 — 따로 설치할 필요가 없습니다.

**Claude.ai / 데스크톱 앱**

설정 → Capabilities → Skills에서 이 폴더를 업로드합니다.

## 함께 쓰는 스킬/플러그인

| 플러그인 | 역할 | 필요 조건 |
|---|---|---|
| [`elements-of-style`](https://github.com/obra/elements-of-style) | 5단계 조립 전에 문장을 다듬음 (Strunk의 *The Elements of Style* 원칙) | 없음 — tech-blog-post 설치 시 자동으로 같이 설치됨 |
| `runway-api` | 4-1단계에서 본문 핵심 개념을 표현하는 이미지를 생성 | 선택 사항. 별도 설치(`/plugin install runway-api@claude-plugins-official`) + 각자 자기 [Runway API 키](https://dev.runwayml.com/settings/api-keys)를 환경변수 `RUNWAYML_API_SECRET`로 설정. 키가 없으면 이미지 없이 진행됨 |

`runway-api`는 유료 API라 강제 의존성으로 넣지 않았습니다 — 설치와 결제는 각자의 몫이고,
안 깔려 있거나 키가 없으면 스킬은 이미지 단계를 조용히 건너뜁니다.

## 커스터마이징

`SKILL.md` 하나만 고치면 됩니다.

- 특정 블로그 플랫폼에 맞추려면 "3단계: SEO 요소 정하기"의 태그/메타 설명 규칙
- HTML 인라인 스타일(폰트·색상·여백)을 바꾸려면 "6단계: HTML로 저장"
- 개념 이미지 생성 여부·프롬프트 원칙을 바꾸려면 "4-1단계: 개념 이미지 생성"
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
