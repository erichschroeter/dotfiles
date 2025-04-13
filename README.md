# dotfiles
- [dotfiles](#dotfiles)
  - [Windows](#windows)
  - [Linux (Ubuntu)](#linux-ubuntu)
    - [dwm](#dwm)

## Windows

1. Install [Starship](https://starship.rs/guide/#%F0%9F%9A%80-installation)
    ```powershell
    winget install --id Starship.Starship
    ```
1. Install [eza](https://github.com/eza-community/eza)
   ```powershell
   winget install eza-community.eza
   ```
1. Copy contents of [Microsoft.PowerShell_profile.ps1](./PowerShell/Microsoft.PowerShell_profile.ps1) to `$PROFILE`:

## Linux (Ubuntu)

1. Dependencies for [eza](https://github.com/eza-community/eza) (see [installation on Ubuntu](https://github.com/eza-community/eza/blob/main/INSTALL.md#debian-and-ubuntu))
    ```bash
    sudo apt update && sudo apt install -y gpg && sudo mkdir -p /etc/apt/keyrings && \
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list && \
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    ```
1. Install apps
    - [stow](https://www.gnu.org/software/stow/) (see [docs](https://www.gnu.org/software/stow/manual/stow.html))
    - [ripgrep](https://github.com/BurntSushi/ripgrep)
    - [bat](https://github.com/sharkdp/bat)
    - [tmux](https://github.com/tmux/tmux/wiki)
    ```bash
    sudo apt install -y bat curl eza ripgrep stow tmux
    ```
    Install [Cascadia Code Nerd Font](https://github.com/microsoft/cascadia-code)
    ```bash
    cp ~/.dotfiles/fonts/CascadiaCodeNF-Regular.otf ~/.local/share/fonts/
    ```
    Install [Starship](https://starship.rs/guide/#%F0%9F%9A%80-installation)
    ```bash
    curl -sS https://starship.rs/install.sh | sh
    ```
1. Clone and install links to [erichschroeter/dotfiles.git](https://github.com/erichschroeter/dotfiles)
    ```bash
    cd ~ && \
    git clone git@github.com:erichschroeter/dotfiles.git .dotfiles && \
    cd .dotfiles/ && \
    stow --adopt .
    ```

### dwm
1. [dwm](https://dwm.suckless.org/)
    ```bash
    sudo apt install -y build-essential libx11-dev libxft-dev libxinerama-dev libxrandr-dev xclip
    ```
    ```bash
    cd ~/.dotfiles/dwm && \
    sudo make clean install
    ```
1. [dmenu](https://tools.suckless.org/dmenu/)
    ```bash
    git clone https://git.suckless.org/dmenu && cd dmenu
    ```
    ```bash
    ln -s ../dwm/config.dmenu.h config.h
    ```
    ```bash
    sudo make clean install
    ```
1. [slock](https://tools.suckless.org/slock/)
    ```bash
    git clone https://git.suckless.org/slock && cd slock
    ```
    ```bash
    ln -s ../dwm/config.slock.h config.h
    ```
    ```bash
    sudo make clean install
    ```
1. [slstatus](https://tools.suckless.org/slstatus/)
    ```bash
    git clone https://git.suckless.org/slstatus && cd slstatus
    ```
    ```bash
    ln -s ../dwm/config.slstatus.h config.h
    ```
    ```bash
    sudo make clean install
    ```
1. [rterm](https://github.com/mechpen/rterm)

    Install [Rust](https://www.rust-lang.org/tools/install)
    ```bash
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    ```
    Build and install rterm
    ```bash
    cd ~/.dotfiles/ && \
    git clone https://github.com/mechpen/rterm.git && \
    cd rterm/
    ```
    ```bash
    cargo install --locked --path $(pwd)
    ```
1. [LightDM](https://github.com/canonical/lightdm) and [slick-greeter](https://github.com/linuxmint/slick-greeter)
    ```bash
    sudo apt install -y slick-greeter
    ```
    Configure lightdm and XSession
    ```bash
    cp ~/.dotfiles/dwm/{dwm.desktop,dwm-session.desktop} /usr/share/xsessions/
    ```
    ```bash
    # copy .xsession.example to .xsession and modify to your liking
    ln -st ~ ~/.dotfiles/.xsession
    ```
