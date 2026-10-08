#!/usr/bin/env bash
# Mở tmux session teams-agent chạy run-loop.sh (bỏ qua nếu đã có).
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux has-session -t teams-agent 2>/dev/null && exit 0
tmux new-session -d -s teams-agent "bash $DIR/run-loop.sh"
