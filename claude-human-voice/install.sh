#!/usr/bin/env bash
# Cài skill human-voice cho Claude Code (cấp người dùng) bằng symlink.
# Dùng: ./install.sh            -> ~/.claude/skills/human-voice
#       ./install.sh --copy     -> chép file thay vì symlink
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/human-voice"
DEST="${HOME}/.claude/skills/human-voice"

mkdir -p "$(dirname "$DEST")"
if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  echo "Đã có $DEST, bỏ qua. Xóa nó trước nếu muốn cài lại." >&2
  exit 1
fi

if [ "${1:-}" = "--copy" ]; then
  cp -r "$SRC" "$DEST"
else
  ln -s "$SRC" "$DEST"
fi
echo "Đã cài: $DEST"
echo "Mở phiên Claude Code mới rồi gõ /human-voice"
