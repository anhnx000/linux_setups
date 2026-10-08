# claude-human-voice

Skill cho Claude Code giúp câu trả lời và văn bản Claude viết (tiếng Việt và tiếng Anh) đọc giống người viết hơn: bỏ "Chắc chắn rồi!", "không chỉ... mà còn...", gạch ngang dài, bộ ba, in đậm tràn lan, đoạn "Tóm lại" rỗng.

Nội dung tổng hợp từ [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), skill [blader/humanizer](https://github.com/blader/humanizer) (MIT) và các bài viết tiếng Việt về dấu hiệu văn AI. Nguồn đầy đủ nằm cuối `human-voice/SKILL.md`.

## Cấu trúc
```
human-voice/
├── SKILL.md                 # quy tắc chính, Claude nạp khi skill được gọi
├── references/patterns.md   # 28 dấu hiệu, ví dụ trước/sau (Việt + Anh)
├── scripts/scan.py          # quét nhanh dấu hiệu bề mặt, không cần thư viện ngoài
└── LICENSE-humanizer        # giấy phép MIT của blader/humanizer
```

## Cài
```bash
./install.sh          # symlink vào ~/.claude/skills/human-voice, git pull là cập nhật luôn
./install.sh --copy   # hoặc chép file
```
Sau đó mở phiên Claude Code mới.

## Dùng
- Bật cho cả phiên: gõ `/human-voice`, từ đó Claude trả lời theo quy tắc của skill.
- Sửa một đoạn: `/human-voice <dán văn bản>` hoặc "viết lại file docs/x.md cho bớt giọng AI".
- Quét thử: `python3 -I human-voice/scripts/scan.py file.md`.
- Có mẫu văn của mình thì đưa kèm, Claude sẽ bắt chước giọng đó thay vì giọng mặc định.

## Lưu ý
- Skill không đảm bảo qua được công cụ phát hiện AI. Không dùng để nộp bài thay hay giả danh người khác.
- Từ vựng AI đổi theo đời mô hình (Wikipedia có bảng theo năm). Nên xem lại danh sách định kỳ.
