#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OS_NAME="$(uname -s)"

errors=0
warnings=0

pass() {
  echo "PASS: $1"
}

warn() {
  echo "WARN: $1"
  warnings=$((warnings + 1))
}

fail() {
  echo "FAIL: $1"
  errors=$((errors + 1))
}

require_file() {
  local path="$1"

  if [[ -f "$REPO_ROOT/$path" ]]; then
    pass "found file $path"
  else
    fail "missing file $path"
  fi
}

require_symlink_target() {
  local path="$1"
  local expected="$2"
  local target

  if [[ ! -L "$REPO_ROOT/$path" ]]; then
    fail "$path is not a symlink"
    return
  fi

  target="$(readlink "$REPO_ROOT/$path")"
  if [[ "$target" == "$expected" ]]; then
    pass "$path -> $expected"
  else
    fail "$path points to $target, expected $expected"
  fi
}

require_text() {
  local path="$1"
  local pattern="$2"
  local description="$3"

  if command -v rg >/dev/null 2>&1; then
    if rg -q --fixed-strings -- "$pattern" "$REPO_ROOT/$path"; then
      pass "$description"
    else
      fail "$description"
    fi
    return
  fi

  if grep -F -q -- "$pattern" "$REPO_ROOT/$path"; then
    pass "$description"
  else
    fail "$description"
  fi
}

run_shellcheck() {
  local -a files=(
    "install/bootstrap.sh"
    "install/validate.sh"
    "shell/bash_profile"
    "shell/env.sh"
    "shell/prompt.sh"
    "shell/history.sh"
    "scripts/legacy/ubuntu-unity-disable-scopes.sh"
  )

  if ! command -v shellcheck >/dev/null 2>&1; then
    warn "shellcheck is not installed; skipping shell script linting"
    return
  fi

  if shellcheck -x -e SC1090,SC1091 "${files[@]/#/$REPO_ROOT/}"; then
    pass "shellcheck passed for tracked shell scripts"
  else
    fail "shellcheck reported issues in tracked shell scripts"
  fi
}

echo "Validating repo at $REPO_ROOT"
echo "Detected OS: $OS_NAME"

require_file "README.md"
require_file "install/bootstrap.sh"
require_file "shell/bash_profile"
require_file "shell/env.sh"
require_file "shell/prompt.sh"
require_file "shell/history.sh"
require_file "git/gitconfig"
require_file "vim/vimrc"
require_file "psql/psqlrc"
require_file "psql/queries/activity.sql"
require_file "psql/queries/storage.sql"
require_file "psql/queries/indexes.sql"
require_file "docs/useful_cmd.md"
require_file "scripts/legacy/ubuntu-unity-disable-scopes.sh"
require_file "vim/legacy/ycm_extra_conf.py"

require_symlink_target "bash_profile" "shell/bash_profile"
require_symlink_target "gitconfig" "git/gitconfig"
require_symlink_target "vimrc" "vim/vimrc"
require_symlink_target "psqlrc" "psql/psqlrc"
require_symlink_target "gtk.css" "gui/gtk.css"
require_symlink_target "disable_all_scopes_enable_listed.sh" "scripts/legacy/ubuntu-unity-disable-scopes.sh"
require_symlink_target "useful_cmd.txt" "docs/useful_cmd.md"
require_symlink_target "ycm_extra_conf.py" "vim/legacy/ycm_extra_conf.py"

require_text "shell/bash_profile" "source \"\${SHELL_CONFIG_DIR}/env.sh\"" "shell entrypoint sources env.sh"
require_text "shell/bash_profile" "source \"\${SHELL_CONFIG_DIR}/prompt.sh\"" "shell entrypoint sources prompt.sh"
require_text "shell/bash_profile" "source \"\${SHELL_CONFIG_DIR}/history.sh\"" "shell entrypoint sources history.sh"
require_text "shell/bash_profile" "source ~/.bash_profile.local" "shell local override hook exists"

require_text "git/gitconfig" "path = ~/.gitconfig.local" "git local override hook exists"
require_text "vim/vimrc" "source ~/.vimrc.local" "vim local override hook exists"
require_text "psql/psqlrc" "\\i ~/.psqlrc.local" "psql local override hook exists"

require_text "psql/psqlrc" "\\ir queries/activity.sql" "psql loads activity queries"
require_text "psql/psqlrc" "\\ir queries/storage.sql" "psql loads storage queries"
require_text "psql/psqlrc" "\\ir queries/indexes.sql" "psql loads index queries"

require_text "install/bootstrap.sh" "--examples" "bootstrap supports local example installation"
require_text "install/bootstrap.sh" "skip: gtk config is Linux-specific" "bootstrap has platform-specific gtk guard"

run_shellcheck

if [[ "$OS_NAME" == "Linux" ]]; then
  pass "GTK config is eligible on Linux hosts"
else
  warn "GTK config is Linux-specific and will be skipped by bootstrap on $OS_NAME"
fi

warn "vim/legacy/ycm_extra_conf.py remains legacy optional tooling and is not validated for runtime dependencies"

echo
echo "Summary: $errors failure(s), $warnings warning(s)"

if [[ "$errors" -ne 0 ]]; then
  exit 1
fi
