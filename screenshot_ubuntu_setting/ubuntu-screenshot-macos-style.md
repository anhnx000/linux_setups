# Hướng dẫn cài đặt chụp màn hình trên ubuntu 
# Phím tắt chụp màn hình Ubuntu (giống macOS) - bản cuối

Tài liệu này tổng hợp cấu hình cuối cùng đang dùng trên máy:

- `Ctrl + Shift + 3`: chụp toàn màn hình
- `Ctrl + Shift + 4`: kéo vùng chụp, tự động copy vào clipboard (không cần Enter)
- `Ctrl + Shift + 5`: mở giao diện chụp tương tác

## 1) Cài đặt gói cần thiết

```bash
sudo apt update && sudo apt install -y flameshot gnome-screenshot libnotify-bin
```

## 2) Tắt phím chụp mặc định để tránh xung đột

```bash
gsettings set org.gnome.shell.keybindings show-screenshot-ui "[]"
gsettings set org.gnome.shell.keybindings screenshot "[]"
gsettings set org.gnome.shell.keybindings screenshot-window "[]"
```

## 3) Tạo 3 custom shortcuts (Ctrl+Shift+3/4/5)

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
"['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
```

### `Ctrl + Shift + 3` - Chụp toàn màn hình (lưu Desktop)

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Chụp toàn màn hình (Mac)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command \
'bash -lc "mkdir -p \"$HOME/Desktop\"; if command -v gnome-screenshot >/dev/null; then gnome-screenshot -f \"$HOME/Desktop/Screenshot $(date +%Y-%m-%d_%H-%M-%S).png\"; elif command -v flameshot >/dev/null; then flameshot full -p \"$HOME/Desktop\"; else notify-send \"Screenshot tools missing\" \"Run: sudo apt install flameshot gnome-screenshot\"; fi"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Ctrl><Shift>3'
```

### `Ctrl + Shift + 4` - Chụp vùng, copy clipboard ngay

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Chụp vùng chọn (Mac)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command \
'bash -lc "flameshot gui -c --accept-on-select || gnome-screenshot -a -c"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Ctrl><Shift>4'
```

> Ghi chú: `--accept-on-select` giúp kéo xong là chấp nhận ngay, không cần nhấn Enter.

### `Ctrl + Shift + 5` - Giao diện chụp tương tác

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Công cụ chụp màn hình (Mac)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command \
'bash -lc "if command -v gnome-screenshot >/dev/null; then gnome-screenshot -i; elif command -v flameshot >/dev/null; then flameshot gui; else notify-send \"Screenshot tools missing\" \"Run: sudo apt install flameshot gnome-screenshot\"; fi"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Ctrl><Shift>5'
```

## 4) Tắt hiệu ứng tiếng "tách" và nháy màn hình

```bash
gsettings set org.gnome.desktop.sound input-feedback-sounds false
gsettings set org.gnome.desktop.sound event-sounds false
gsettings set org.gnome.desktop.wm.preferences visual-bell false
```

## 5) Kiểm tra nhanh cấu hình

```bash
gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding
gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding
gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding
```

Kỳ vọng kết quả:

- `'<Ctrl><Shift>3'`
- `'<Ctrl><Shift>4'`
- `'<Ctrl><Shift>5'`

## 6) Nếu phím tắt vẫn bị lỗi

1. Đăng xuất và đăng nhập lại.
2. Thử chạy tay:
   ```bash
   flameshot gui -c --accept-on-select
   ```
3. Nếu vẫn lỗi backend chụp màn hình, tạm thời đổi `Ctrl+Shift+4` về:
   ```bash
   gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'gnome-screenshot -a -c'
   ```
