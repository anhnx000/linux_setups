# Teams / Microsoft 365 MCP cho Claude Code (dùng Edge trên Linux)

Kết nối Claude Code với Teams, SharePoint/OneDrive và Outlook qua
[hotamago/mcp-auto-365-ms](https://github.com/hotamago/mcp-auto-365-ms). Server đọc cookie phiên
đăng nhập trong trình duyệt, nên không cần quyền admin tenant hay app registration.

Đã test trên: Ubuntu 24.04, Microsoft Edge 151, mcp-auto-365-ms commit `c1ea338` (30/09/2026).

---

## Cài đặt

```bash
# 1. uv (nếu chưa có)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 2. Clone và cài
git clone https://github.com/hotamago/mcp-auto-365-ms ~/work/proactive-prj-note/mcp-auto-365-ms
cd ~/work/proactive-prj-note/mcp-auto-365-ms
git apply ~/work/linux_setups/teams-mcp-365/edge-keyring.patch   # xem mục "Lỗi Edge" bên dưới
./install.sh
```

`install.sh` tự tạo `.venv`, link launcher vào `~/.local/bin` (`mcp-auto-365-ms`,
`mcp-teams-reader`, `mcp-doc-reader`) và đăng ký server `auto-365-ms` với Claude Code
(scope user). Kiểm tra: `claude mcp list` → `auto-365-ms ... ✔ Connected`.

> **Chuyển thư mục clone:** `.venv` chứa đường dẫn tuyệt đối, nên sau khi `mv` phải
> `rm -rf .venv && ./install.sh` để tạo lại venv và trỏ lại symlink.

## Cấu hình

```bash
mkdir -p ~/.config/mcp-auto-365-ms
cp ~/work/linux_setups/teams-mcp-365/config.toml ~/.config/mcp-auto-365-ms/config.toml
# sửa hostname / site_path cho đúng tenant
```

Máy này không có Chrome nên dùng `name = "edge"`. Thứ tự ưu tiên: biến môi trường `MCP365_*`
→ `~/.config/mcp-auto-365-ms/config.toml` → `./config.toml` → mặc định.

## Edge: bật keyring và đăng nhập

Cookie của Edge được mã hoá bằng một key lưu trong GNOME keyring. Edge phải chạy với
libsecret thì key mới nằm ở đó:

```bash
microsoft-edge --password-store=gnome-libsecret
```

Để khỏi phải gõ mỗi lần, thêm flag vào launcher:

```bash
cp /usr/share/applications/microsoft-edge.desktop ~/.local/share/applications/
sed -i 's|^Exec=/usr/bin/microsoft-edge-stable|Exec=/usr/bin/microsoft-edge-stable --password-store=gnome-libsecret|' \
  ~/.local/share/applications/microsoft-edge.desktop
```

Sau đó trong Edge, đăng nhập (tick **Stay signed in**):

- <https://teams.microsoft.com>
- <https://outlook.office.com>
- `https://<tenant>.sharepoint.com` (site cần dùng)

## Lỗi Edge: "Không lấy được master key của edge từ keyring"

**Nguyên nhân:** Edge trên Linux lưu key dưới tên `Chromium Safe Storage` (`application=chromium`),
còn code gốc tìm `microsoft-edge`. yt-dlp cũng tra key của Edge trên Linux theo tên `Chromium`.

**Sửa:** [`edge-keyring.patch`](edge-keyring.patch), đổi 1 dòng trong
`src/common/chrome_cookies.py`:

```python
"edge": (("~/.config/microsoft-edge",), "chromium"),
```

Patch này là thay đổi local chưa commit — `git pull` đụng file đó thì phải apply lại.
Nếu máy có cài Chromium hoặc app khác cùng dùng tên `chromium` thì có thể lấy nhầm key;
khi đó `check_365_connection` sẽ báo cookie không giải mã được.

## Kiểm tra

Khởi động lại Claude Code (hoặc `/mcp`), rồi nhờ Claude chạy `check_365_connection`.
Kết quả mong đợi:

| Kênh | Trạng thái |
|---|---|
| Trình duyệt & Keyring | ✅ edge · profile `Default` · master key giải mã được |
| Teams (skypetoken) | ✅ (token sống ~24h) |
| SharePoint (cookie phiên) | ✅ |
| Outlook mail | ✅ |
| Azure CLI / Graph | ⚠️ tuỳ chọn — chỉ cần nếu muốn kênh dự phòng Graph |

Không có tool MCP trong phiên thì gọi thẳng:

```bash
cd ~/work/proactive-prj-note/mcp-auto-365-ms
uv run --frozen --quiet python -c "
import sys, asyncio; sys.path.insert(0, 'src'); import server
print(asyncio.run(server.mcp.call_tool('check_365_connection', {})).structured_content['result'])"
```

## Xử lý sự cố

| Triệu chứng | Cách sửa |
|---|---|
| `Không tìm thấy file Cookies nào trong ~/.config/google-chrome` | Đang để `name = "chrome"` nhưng máy không có Chrome → đổi sang `edge`. |
| `Không tìm thấy mục 'microsoft-edge Safe Storage'` | Chưa apply `edge-keyring.patch`, hoặc Edge chạy không có `--password-store=gnome-libsecret`. |
| Teams tools 401 | skypetoken hết hạn (~24h) → mở lại teams.microsoft.com trong Edge. |
| SharePoint 403 `917656` | Đăng nhập lại, tick **Stay signed in**. |
| Tool list cũ sau khi sửa code | `pkill -f "mcp-auto-365-ms/src/server.py"` (chạy riêng, đừng ghép với lệnh khác vì `pkill -f` sẽ khớp luôn shell đó). |

## Lưu ý an toàn

Mọi tool gửi/sửa/xoá (`send_teams_message`, `send_email`, upload…) bắt buộc
`is_user_confirm=true` — Claude phải cho xem nguyên văn bản nháp và nơi gửi, và chỉ gửi khi được đồng ý.
