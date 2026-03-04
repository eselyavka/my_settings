#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OS_NAME="$(uname -s)"

usage() {
  cat <<'EOF'
Usage: install/bootstrap.sh [options]

Options:
  --shell         Install shell config
  --git           Install git config
  --vim           Install vim config
  --psql          Install psql config
  --gtk           Install gtk config
  --examples      Copy local override example files into $HOME
  --all           Install portable configs plus platform-specific ones
  --dry-run       Print actions without changing files
  --force         Replace existing files or symlinks
  -h, --help      Show this help

Default behavior is the same as --all.
Portable configs: shell, git, vim, psql
Linux-only configs: gtk
EOF
}

dry_run=0
force=0
install_examples=0
has_selection=0
declare -a selections=()

default_selections() {
  selections=(shell git vim psql)

  if [[ "$OS_NAME" == "Linux" ]]; then
    selections+=(gtk)
  fi
}

install_link() {
  local source_rel="$1"
  local target="$2"
  local source="$REPO_ROOT/$source_rel"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" || -e "$target" ]]; then
    if [[ "$force" -eq 0 ]]; then
      echo "skip: $target already exists"
      return 0
    fi

    if [[ "$dry_run" -eq 1 ]]; then
      echo "rm $target"
    else
      rm -rf "$target"
    fi
  fi

  if [[ "$dry_run" -eq 1 ]]; then
    echo "ln -s $source $target"
  else
    ln -s "$source" "$target"
    echo "linked: $target -> $source"
  fi
}

install_copy() {
  local source_rel="$1"
  local target="$2"
  local source="$REPO_ROOT/$source_rel"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" || -e "$target" ]]; then
    if [[ "$force" -eq 0 ]]; then
      echo "skip: $target already exists"
      return 0
    fi

    if [[ "$dry_run" -eq 1 ]]; then
      echo "rm $target"
    else
      rm -rf "$target"
    fi
  fi

  if [[ "$dry_run" -eq 1 ]]; then
    echo "cp $source $target"
  else
    cp "$source" "$target"
    echo "copied: $target <- $source"
  fi
}

install_shell() {
  install_link "shell/bash_profile" "$HOME/.bash_profile"
}

install_git() {
  install_link "git/gitconfig" "$HOME/.gitconfig"
}

install_vim() {
  install_link "vim/vimrc" "$HOME/.vimrc"
}

install_psql() {
  install_link "psql/psqlrc" "$HOME/.psqlrc"
}

install_gtk() {
  if [[ "$OS_NAME" != "Linux" ]]; then
    echo "skip: gtk config is Linux-specific (detected $OS_NAME)"
    return 0
  fi

  install_link "gui/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
}

install_local_examples() {
  install_copy "shell/bash_profile.local.example" "$HOME/.bash_profile.local"
  install_copy "git/gitconfig.local.example" "$HOME/.gitconfig.local"
  install_copy "vim/vimrc.local.example" "$HOME/.vimrc.local"
  install_copy "psql/psqlrc.local.example" "$HOME/.psqlrc.local"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --shell|--git|--vim|--psql|--gtk)
      selections+=("${1#--}")
      has_selection=1
      shift
      ;;
    --all)
      default_selections
      has_selection=1
      shift
      ;;
    --examples)
      install_examples=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --force)
      force=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "$has_selection" -eq 0 && "$install_examples" -eq 0 ]]; then
  default_selections
fi

if [[ "$has_selection" -eq 1 ]]; then
  for selection in "${selections[@]}"; do
    "install_$selection"
  done
fi

if [[ "$install_examples" -eq 1 ]]; then
  install_local_examples
fi
