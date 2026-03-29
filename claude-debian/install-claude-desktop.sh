#!/usr/bin/env bash
# Cài Claude Desktop qua kho APT (cần sudo). Tham khảo: https://github.com/aaddrick/claude-desktop-debian
set -euo pipefail

curl -fsSL https://aaddrick.github.io/claude-desktop-debian/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/claude-desktop.gpg

echo "deb [signed-by=/usr/share/keyrings/claude-desktop.gpg arch=amd64,arm64] https://aaddrick.github.io/claude-desktop-debian stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop.list >/dev/null

sudo apt update
sudo apt install -y claude-desktop

echo "Xong. Chạy: claude-desktop   (hoặc: claude-desktop --doctor)"
