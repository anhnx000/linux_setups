# Ubuntu screenshot setup (macOS-style shortcuts)

This document describes the final configuration in use:

- `Ctrl + Shift + 3`: full-screen capture
- `Ctrl + Shift + 4`: region capture, auto-copy to clipboard (no Enter)
- `Ctrl + Shift + 5`: interactive capture UI

## 1) Install required packages

```bash
sudo apt update && sudo apt install -y flameshot gnome-screenshot libnotify-bin
```

## 2) Disable default screenshot shortcuts to avoid conflicts

```bash
gsettings set org.gnome.shell.keybindings show-screenshot-ui "[]"
gsettings set org.gnome.shell.keybindings screenshot "[]"
gsettings set org.gnome.shell.keybindings screenshot-window "[]"
```

## 3) Create three custom shortcuts (Ctrl+Shift+3/4/5)

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
"['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
```

### `Ctrl + Shift + 3` — Full screen (save to Desktop)

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Full screen (Mac-style)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command \
'bash -lc "mkdir -p \"$HOME/Desktop\"; if command -v gnome-screenshot >/dev/null; then gnome-screenshot -f \"$HOME/Desktop/Screenshot $(date +%Y-%m-%d_%H-%M-%S).png\"; elif command -v flameshot >/dev/null; then flameshot full -p \"$HOME/Desktop\"; else notify-send \"Screenshot tools missing\" \"Run: sudo apt install flameshot gnome-screenshot\"; fi"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Ctrl><Shift>3'
```

### `Ctrl + Shift + 4` — Region capture, copy to clipboard immediately

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Region capture (Mac-style)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command \
'bash -lc "flameshot gui -c --accept-on-select || gnome-screenshot -a -c"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Ctrl><Shift>4'
```

> Note: `--accept-on-select` accepts the selection as soon as you finish dragging, without pressing Enter.

### `Ctrl + Shift + 5` — Interactive capture UI

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Screenshot tool (Mac-style)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command \
'bash -lc "if command -v gnome-screenshot >/dev/null; then gnome-screenshot -i; elif command -v flameshot >/dev/null; then flameshot gui; else notify-send \"Screenshot tools missing\" \"Run: sudo apt install flameshot gnome-screenshot\"; fi"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Ctrl><Shift>5'
```

## 4) Disable shutter sound and screen flash

```bash
gsettings set org.gnome.desktop.sound input-feedback-sounds false
gsettings set org.gnome.desktop.sound event-sounds false
gsettings set org.gnome.desktop.wm.preferences visual-bell false
```

## 5) Quick verification

```bash
gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding
gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding
gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding
```

Expected output:

- `'<Ctrl><Shift>3'`
- `'<Ctrl><Shift>4'`
- `'<Ctrl><Shift>5'`

## 6) If shortcuts still misbehave

1. Log out and log back in.
2. Run manually:
   ```bash
   flameshot gui -c --accept-on-select
   ```
3. If the screenshot backend still fails, temporarily set `Ctrl+Shift+4` to:
   ```bash
   gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'gnome-screenshot -a -c'
   ```
