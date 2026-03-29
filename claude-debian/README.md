# Cài Claude Desktop trên Ubuntu (Debian)

**Tham khảo chính:** [aaddrick/claude-desktop-debian](https://github.com/aaddrick/claude-desktop-debian) — bản build không chính thức, repackage ứng dụng Windows cho Linux (`.deb`, APT repo, v.v.). Hỗ trợ chính thức: trang Anthropic.

---

## Cài một lần (script)

Trong terminal trên máy bạn (để nhập mật khẩu `sudo` khi được hỏi):

```bash
cd ~/work/linux_setups/claude-debian
./install-claude-desktop.sh
```

---

## Cách khuyến nghị: kho APT (cập nhật qua `apt upgrade`)

Chạy lần lượt:

```bash
# Thêm khóa GPG
curl -fsSL https://aaddrick.github.io/claude-desktop-debian/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/claude-desktop.gpg
```

```bash
# Thêm nguồn package
echo "deb [signed-by=/usr/share/keyrings/claude-desktop.gpg arch=amd64,arm64] https://aaddrick.github.io/claude-desktop-debian stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop.list
```

```bash
sudo apt update
sudo apt install claude-desktop
```

Sau này cập nhật cùng hệ thống: `sudo apt upgrade`.

---

## Cách khác

- **File `.deb` có sẵn:** tải từ [Releases](https://github.com/aaddrick/claude-desktop-debian/releases) rồi cài bằng `sudo apt install ./tên-file.deb` (hoặc GDebi).
- **Build từ mã nguồn:** xem `docs/BUILDING.md` trong repo trên.

---

## Ghi chú nhanh

- **Cấu hình MCP:** `~/.config/Claude/claude_desktop_config.json`
- **Biến môi trường / Wayland:** xem `docs/CONFIGURATION.md` trong repo.
- **Kiểm tra môi trường:** chạy `claude-desktop --doctor` (display, sandbox, MCP, v.v.).
- **Cowork mode:** trong bản build này thường bật mặc định; backend mặc định là **bubblewrap** (cần `bwrap`). Chi tiết trong README repo.

---

## Link

- Repo & hướng dẫn đầy đủ: https://github.com/aaddrick/claude-desktop-debian
