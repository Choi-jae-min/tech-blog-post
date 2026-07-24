#!/usr/bin/env bash
# tech-blog-post one-command installer
#   curl -fsSL https://raw.githubusercontent.com/Choi-jae-min/tech-blog-post/main/install.sh | bash
#
# Detects installed host CLIs (claude / codex / gemini) and installs the
# plugin/extension for each. Grok Build reads skills globally from
# ~/.grok/skills/, so this also clones/updates that path. Cursor is
# project-scoped only (no global skills dir) — see README for how to add
# this skill to a specific project. Per-host failures are non-fatal.
set -u

REPO="Choi-jae-min/tech-blog-post"
REPO_URL="https://github.com/${REPO}.git"
INSTALLED=0

log()  { printf '\033[1;32m[tech-blog-post]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[tech-blog-post]\033[0m %s\n' "$*" >&2; }

try_host() { # <name> <command...>
  local name="$1"; shift
  if "$@"; then
    log "✓ ${name} 설치 완료"
    INSTALLED=$((INSTALLED + 1))
  else
    warn "✗ ${name} 설치 실패 — 수동 설치는 README 참조"
  fi
}

if command -v claude >/dev/null 2>&1; then
  try_host "Claude Code" bash -c \
    "claude plugin marketplace add ${REPO} && claude plugin install tech-blog-post@tech-blog-post-marketplace"
fi

if command -v codex >/dev/null 2>&1; then
  try_host "Codex" bash -c \
    "codex plugin marketplace add ${REPO} && codex plugin add tech-blog-post"
fi

if command -v gemini >/dev/null 2>&1; then
  try_host "Gemini CLI" gemini extensions install "https://github.com/${REPO}"
fi

# Grok Build reads skills globally from ~/.grok/skills/ — clone/update there.
SKILL_DIR="${HOME}/.grok/skills/tech-blog-post"
if [ -d "${SKILL_DIR}/.git" ]; then
  if git -C "${SKILL_DIR}" pull --ff-only >/dev/null 2>&1; then
    log "✓ ~/.grok/skills/tech-blog-post 갱신 (Grok Build)"
    INSTALLED=$((INSTALLED + 1))
  else
    warn "✗ ~/.grok/skills/tech-blog-post 갱신 실패 — 수동으로 git pull 하세요"
  fi
elif [ ! -e "${SKILL_DIR}" ]; then
  mkdir -p "${HOME}/.grok/skills"
  if git clone --quiet "${REPO_URL}" "${SKILL_DIR}"; then
    log "✓ ~/.grok/skills/tech-blog-post clone (Grok Build)"
    INSTALLED=$((INSTALLED + 1))
  else
    warn "✗ clone 실패: ${SKILL_DIR}"
  fi
fi

warn "Cursor는 프로젝트 단위로만 스킬을 읽습니다 — 전역 설치가 안 됩니다. 이 스킬을 쓸"
warn "프로젝트에서 'git clone ${REPO_URL} .cursor/skills/tech-blog-post' 를 실행하세요"
warn "(README 참조. .claude/skills, .codex/skills, .agents/skills 아래도 Cursor가 같이 읽습니다)."

if [ "${INSTALLED}" -eq 0 ]; then
  warn "설치된 호스트가 없습니다. 지원 호스트: Claude Code·Codex·Gemini CLI·Grok Build·Cursor (README 참조)"
  exit 1
fi
log "완료 — 새 세션에서 '이거 블로그 글로 써줘'로 사용하세요."
