* The first step is to [open a command line terminal](https://linuxconfig.org/how-to-open-a-terminal-on-ubuntu-xenial-xerus-16-04-linux) and make sure that we have the universe repository enabled on our Ubuntu 22.04 system:

  ```
  $ sudo add-apt-repository universe
  ```
* Once ready, execute the following command to install Tweak Tool on your Ubuntu 22.04 system:

  ```
  $ sudo apt install gnome-tweaks
  ```
* Use the Activities menu and search for `tweak` keyword to start the Tweak Tool. Alternatively, execute the below command:

  ```
  $ gnome-tweaks
  ```
* Optionally, you may now install additional extensions to further tweak your system. Search for available gnome shell extensions:

  ```
  $ apt search gnome-shell-extension
  ```

  Next, either install only selected extensions for example:

  ```
  $ sudo apt install gnome-shell-extension-gsconnect
  ```

  or install all extensions:

  ```
  $ sudo apt install $(apt search gnome-shell-extension | grep ^gnome | cut -d / -f1)
  ```
