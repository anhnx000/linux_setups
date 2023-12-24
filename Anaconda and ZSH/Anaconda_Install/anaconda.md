### Download Anaconda

```
wget https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
```

### Install

```console
sha256sum ~/Downloads/Anaconda3-2021.11-Linux-x86_64.sh
```

```console
bash ~/Downloads/Anaconda3-2021.11-Linux-x86_64.sh
```

### Set the auto_activate_base on

```console
conda config --set auto_activate_base true
```

### Set the auto_activate_base off

```console
conda config --set auto_activate_base false
```

### List all enviroments

```console
conda info --env
```

### Create new enviroment

```console
conda create -n newEnvName python=3.6
```

### Conda delete a enviroment

```console
conda env remove -n [ENV_NAME]
```

### Clean cache

```console
condac clean --all
```

### Export enviroment library

```console
conda env export > env.yaml
```

Conda auto run

# ADD THIS CODE TO ~/BASHRC FILE

```






# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


NOTE THAT IF NOT RUN ANACONDA

The installer prompts “Do you wish the installer to initialize Anaconda3 by running conda init?” We recommend “yes”.
Note: If you enter “no”, then conda will not modify your shell scripts at all. In order to initialize after the installation process is done, first run source <path to conda>/bin/activate and then run conda init.
Note: If you are on macOS Catalina, the new default shell is zsh. You will instead need to run source <path to conda>/bin/activate followed by conda init zsh.
```

# Add this code to ~/bashrc file

`# >>> conda initialize >>>`

`# !! Contents within this block are managed by 'conda init' !!`

`__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"`

`if [ $? -eq 0 ]; then`

`eval "$__conda_setup"`

`else`

`if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then`

`. "/opt/anaconda3/etc/profile.d/conda.sh"`

`else`

`export PATH="/opt/anaconda3/bin:$PATH"`

`fi`

`fi`

`unset __conda_setup`

`# <<< conda initialize <<<`
