# Install Tmux

---
[***@nabang1010***](https://github.com/nabang1010)

## Install Tmux

```bash
sudo apt install tmux
```

## Command

### Tmux List All Session

```bash
tmux ls
```

### Tmux New Session

```bash
tmux new -s NAME_SESSION
```

### Tmux Attach Session

```bash
tmux a -t NAME_SESSION
```

### Tmux Kill Session

```bash
tmux kill-session -t NAME_SESSION
```

### Tmux Kill Server

```bash
tmux kill-server
```

### Clone tmux cpu

```bash
git clone https://github.com/nabang1010/tmux-cpu.git ~/clone/path
```

### Reload tmux

```bash
tmux source-file ~/.tmux.conf
```
