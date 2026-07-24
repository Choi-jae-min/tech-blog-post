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
  # Codex reads the marketplace manifest from .agents/plugins/ (--sparse), then
  # installs by stable plugin@marketplace id.
  try_host "Codex" bash -c \
    "codex plugin marketplace add ${REPO} --sparse .agents/plugins && codex plugin add tech-blog-post@tech-blog-post-marketplace"
fi

if command -v gemini >/dev/null 2>&1; then
  try_host "Gemini CLI" gemini extensions install "https://github.com/${REPO}"
fi

# Grok Build (~/.grok/skills/) and Cursor (~/.cursor/skills/) both read skills
# from a global home directory. Install there only when that host is actually
# present — its CLI is on PATH, or its config dir already exists — so we never
# create dot-dirs for hosts the user doesn't use.
clone_or_update() { # <label> <dest>
  local label="$1" dest="$2"
  if [ -d "${dest}/.git" ]; then
    if git -C "${dest}" pull --ff-only >/dev/null 2>&1; then
      log "✓ ${dest} 갱신 (${label})"; INSTALLED=$((INSTALLED + 1))
    else
      warn "✗ ${dest} 갱신 실패 — 수동으로 git pull 하세요"
    fi
  elif [ ! -e "${dest}" ]; then
    mkdir -p "$(dirname "${dest}")"
    if git clone --quiet "${REPO_URL}" "${dest}"; then
      log "✓ ${dest} clone (${label})"; INSTALLED=$((INSTALLED + 1))
    else
      warn "✗ clone 실패: ${dest}"
    fi
  fi
}

maybe_global_install() { # <label> <cli> <config-root> <dest>
  if command -v "$2" >/dev/null 2>&1 || [ -d "$3" ]; then
    clone_or_update "$1" "$4"
  fi
}

maybe_global_install "Grok Build" grok   "${HOME}/.grok"   "${HOME}/.grok/skills/tech-blog-post"
maybe_global_install "Cursor"     cursor "${HOME}/.cursor" "${HOME}/.cursor/skills/tech-blog-post"

if [ "${INSTALLED}" -eq 0 ]; then
  warn "설치된 호스트가 없습니다. 지원 호스트: Claude Code·Codex·Gemini CLI·Grok Build·Cursor (README 참조)"
  exit 1
fi
log "완료 — 새 세션에서 '이거 블로그 글로 써줘'로 사용하세요."
