# Install oh-my-zsh

---

[***@nabang1010***](https://github.com/nabang1010)

# Install oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Install powerlevel10k

***Ubuntu***

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

then edit `~/.zshrc` file and then search for `ZSH_THEME` and add `powerlevel10k/powerlevel10k` as it's value.

The final result should look like this:

```

ZSH_THEME=powerlevel10k/powerlevel10k
```

And then run:

```
p10k configure

```


*MacOS home brew*

```
brew install powerlevel10k
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
```

## Install Plugins

### zsh-autosuggestions

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### zsh-syntax-highlighting

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Add Plugins to `.zshrc`

- Edit `.zshrc`

```bash
sudo gedit ~/.zshrc
```

or use nano or vim to edit file  if you are using SSH and cannot have a monitor

```bash
sudo nano ~/.zshrc
```

- Add plugins

```txt
## also remove old plugin 
plugins=(git 
        zsh-syntax-highlighting
        zsh-autosuggestions 
        history 
        aliases 
        web-search
        )
```

- Soure

```bash
source ~/.zshrc
```
