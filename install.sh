#!/usr/bin/env bash
# Symlink each tracked dotfile from this repo into $HOME.
# Re-runnable: existing real files are moved aside to $HOME/.dotfiles-backup-<timestamp>/
# before being replaced with a symlink. Existing correct symlinks are left alone.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Every path here is relative to both $DOTFILES_DIR and $HOME.
# Add a line when you start tracking a new file.
FILES=(
  .zshrc
  .zprofile
  .gitconfig
  .config/git/ignore
  .config/ghostty/config
  .config/ghostty/shaders/pipboy-crt.glsl
  .claude/settings.json
)

link_one() {
  local rel="$1"
  local src="$DOTFILES_DIR/$rel"
  local dst="$HOME/$rel"

  if [[ ! -e "$src" ]]; then
    echo "skip: $rel (missing in repo)"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    if [[ "$(readlink "$dst")" == "$src" ]]; then
      echo "ok:   $rel"
      return
    fi
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    mv "$dst" "$BACKUP_DIR/$rel"
    echo "backup: $rel -> $BACKUP_DIR/$rel"
  fi

  ln -s "$src" "$dst"
  echo "link: $rel"
}

for f in "${FILES[@]}"; do
  link_one "$f"
done

if [[ -d "$BACKUP_DIR" ]]; then
  echo
  echo "Original files were backed up under: $BACKUP_DIR"
fi
