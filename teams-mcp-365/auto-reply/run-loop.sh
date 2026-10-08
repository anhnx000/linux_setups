#!/usr/bin/env bash
# Vòng lặp: mỗi INTERVAL giây gọi Claude xử lý mention mới ở một nhóm Teams được phép tự trả lời.
# Mỗi lượt là một phiên `claude -p` mới nên không phình context.
# Cấu hình: ~/.config/teams-auto-reply/env (mẫu ở auto-reply.env.example).
set -u
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
CONFIG=${TEAMS_AUTO_REPLY_ENV:-$HOME/.config/teams-auto-reply/env}
# shellcheck source=/dev/null
[ -r "$CONFIG" ] && . "$CONFIG"
: "${WORKDIR:?thiếu WORKDIR trong $CONFIG}" "${CHAT_ID:?thiếu CHAT_ID}" "${CHAT_NAME:?thiếu CHAT_NAME}" "${OWNER_NAME:?thiếu OWNER_NAME}"
MODEL=${MODEL:-claude-sonnet-5-5}
INTERVAL=${INTERVAL:-300}
USAGE_LIMIT=${USAGE_LIMIT:-90}
cd "$WORKDIR" || exit 1
STATE=$HOME/.local/state/teams-auto-reply
mkdir -p "$STATE"
CURSOR_FILE=$STATE/cursor
LOG=$STATE/run.log
[ -s "$CURSOR_FILE" ] || date -u '+%Y-%m-%d %H:%M:%S' > "$CURSOR_FILE"

# Quy tắc văn phong của skill human-voice (linux_setups/claude-human-voice), nạp vào system prompt
# mỗi lượt. Đọc lại mỗi vòng nên sửa skill là có hiệu lực ngay, không cần restart.
HUMAN_VOICE=${HUMAN_VOICE-$HOME/.claude/skills/human-voice/SKILL.md}
human_voice_rules() {
  [ -n "$HUMAN_VOICE" ] && [ -r "$HUMAN_VOICE" ] || return 0
  echo "Khi soạn tin Teams, áp dụng quy tắc dưới đây ở chế độ nhúng: chỉ gửi bản cuối, không kèm ghi chú đã sửa gì. Xưng hô và chính sách gửi trong CLAUDE.md vẫn được ưu tiên."
  awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; next} !fm' "$HUMAN_VOICE"
}

# In "OK" nếu usage (5 giờ và 7 ngày) dưới ngưỡng; "PAUSE <chi tiết>" nếu từ ngưỡng trở lên.
# Đọc từ cache usage của Claude Code; cửa sổ đã qua resets_at thì coi là 0 để tự chạy lại.
check_usage() {
  python3 - "$USAGE_LIMIT" <<'PY'
import json, os, sys, datetime as dt
limit = float(sys.argv[1])
try:
    c = json.load(open(os.path.expanduser('~/.claude.json')))['cachedUsageUtilization']
    u = c['utilization']
except Exception as e:
    print('OK (không đọc được cache usage)'); sys.exit()
now = dt.datetime.now(dt.timezone.utc)
hits = []
for name in ('five_hour', 'seven_day'):
    w = u.get(name) or {}
    pct = w.get('utilization')
    if pct is None:
        continue
    r = w.get('resets_at')
    if r and dt.datetime.fromisoformat(r) <= now:
        continue
    if pct >= limit:
        hits.append(f'{name}={pct}%')
print('PAUSE ' + ', '.join(hits) if hits else 'OK')
PY
}

while true; do
  USAGE=$(check_usage)
  if [[ "$USAGE" == PAUSE* ]]; then
    echo "[$(date '+%F %T')] $USAGE >= ${USAGE_LIMIT}%, tạm dừng reply Teams" >> "$LOG"
    sleep "$INTERVAL"
    continue
  fi
  CURSOR=$(cat "$CURSOR_FILE")
  NOW=$(date -u '+%Y-%m-%d %H:%M:%S')
  PROMPT="Gọi get_new_mentions_since(cursor=\"$CURSOR\", limit=10). Chỉ xét mention thuộc nhóm \"$CHAT_NAME\" ($CHAT_ID); bỏ qua mention ở nhóm khác và tuyệt đối không gửi vào đó. Không có mention mới ở nhóm này thì chỉ trả lời đúng một dòng \"không có gì mới\" rồi dừng, không làm gì thêm. Nếu có: đọc vài tin gần nhất của nhóm để lấy ngữ cảnh (bỏ qua mention đã có tin trả lời của $OWNER_NAME phía sau, và tin do chính $OWNER_NAME gửi), rồi tự trả lời hợp lý bằng send_teams_message với is_user_confirm=true ($OWNER_NAME đã cho phép, không hỏi lại), tag người gửi, ngắn gọn, chuyên nghiệp, xưng hô theo CLAUDE.md. Không bịa thông tin, chưa chắc thì ghi \"chưa xác nhận\". Chỉ gửi vào nhóm $CHAT_ID."
  echo "[$(date '+%F %T')] run (cursor=$CURSOR)" >> "$LOG"
  if claude -p "$PROMPT" \
      --model "$MODEL" \
      --append-system-prompt "$(human_voice_rules)" \
      --allowedTools "mcp__auto-365-ms__get_new_mentions_since" "mcp__auto-365-ms__read_teams_chat" "mcp__auto-365-ms__send_teams_message" \
      >> "$LOG" 2>&1; then
    echo "$NOW" > "$CURSOR_FILE"
  else
    echo "[$(date '+%F %T')] claude lỗi, giữ nguyên cursor" >> "$LOG"
  fi
  sleep "$INTERVAL"
done
