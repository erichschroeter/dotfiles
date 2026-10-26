# dotfiles
- [dotfiles](#dotfiles)
  - [Windows](#windows)
  - [Linux (Ubuntu)](#linux-ubuntu)
    - [dwm](#dwm)
    - [custom-pinentry](#custom-pinentry)
  - [devcontainer](#devcontainer)

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
    sudo apt install -y bat curl eza ripgrep stow tmux ncal
    ```
    Additional apps:
    ```bash
    sudo apt install -y ffmpeg
    ```
    Install [Rust](https://www.rust-lang.org/tools/install)
    ```bash
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    ```
    Install [Cascadia Code Nerd Font](https://github.com/microsoft/cascadia-code)
    ```bash
    cp ~/.dotfiles/fonts/CascadiaCodeNF-Regular.otf ~/.local/share/fonts/
    ```
    Install [Starship](https://starship.rs/guide/#%F0%9F%9A%80-installation)
    ```bash
    curl -sS https://starship.rs/install.sh | sh
    ```
    Install [neovim](https://neovim.io/)
    ```bash
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-x86_64.tar.gz
    tar xzf nvim-macos-x86_64.tar.gz
    ./nvim-macos-x86_64/bin/nvim
    ```
    Install [fzf](https://github.com/junegunn/fzf)
    ```
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
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
1. [alacritty](https://alacritty.org/)

    Install [Rust](https://www.rust-lang.org/tools/install)
    ```bash
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    ```
    ```bash
    cargo install alacritty
    ```
1. Install [dwm.desktop](dwm/dwm.desktop)
    ```bash
    sudo cp ~/.dotfiles/dwm/dwm.desktop /usr/share/xsessions/
    ```

### custom-pinentry

`custom-pinentry` is a GTK 4 pinentry for `rbw` with a per-prompt password visibility toggle. Set it up from its source checkout (currently `~/Code/custom-pinentry`):

1. Install GTK/PyGObject and [uv](https://docs.astral.sh/uv/getting-started/installation/):
    ```bash
    sudo apt install -y gir1.2-gtk-4.0 python3-gi python3-gi-cairo
    cd ~/Code/custom-pinentry
    uv venv --python /usr/bin/python3 --system-site-packages
    uv sync
    ```
1. Create the rbw launcher:
    ```bash
    cd ~/Code/custom-pinentry
    PROJECT_DIR="$(pwd -P)"
    mkdir -p "$HOME/.local/bin"
    cat > "$HOME/.local/bin/custom-pinentry" <<EOF
    #!/bin/sh
    export PYTHONPATH="$PROJECT_DIR/src"
    exec "$PROJECT_DIR/.venv/bin/python" -m rbw_pinentry "\$@"
    EOF
    chmod 755 "$HOME/.local/bin/custom-pinentry"
    ```
1. Ensure `~/.local/bin` is in the `PATH` inherited by dwm/rbw, then configure rbw and restart its agent:
    ```bash
    rbw config set pinentry custom-pinentry
    rbw stop-agent
    ```

The dwm rule in [`dwm/config.h`](dwm/config.h) matches the prompt's stable window title and floats it without changing the tiled layout. Rebuild and restart dwm after changing its config. See `~/Code/custom-pinentry/README.md` for testing and disposable-profile instructions.

## ssh-unlock

The `ssh-unlock` function (defined in `.bash_aliases`) allows you to unlock multiple SSH keys using passphrases stored in Bitwarden via `rbw`.

### Prerequisites
- [rbw](https://github.com/totoloto/rbw)
- `expect`
```bash
sudo apt install expect
```

### Configuration
Create a configuration file at `~/.ssh/unlock.conf` on each machine. Each line should map a private key path to its corresponding Bitwarden item name, separated by a pipe (`|`):

```text
/path/to/ssh/key | Bitwarden Item Name
```

Example `~/.ssh/unlock.conf`:
```text
~/.ssh/id_ed25519 | SSH (ED25519)
~/.ssh/id_rsa     | SSH (RSA)
```

## devcontainer

```bash
sudo apt update && sudo apt install -y gpg && sudo mkdir -p /etc/apt/keyrings && \
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && \
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list && \
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list && \
sudo apt update && \
curl -sS https://starship.rs/install.sh -y | sudo sh && \
sudo apt install -y bat curl eza ripgrep stow tmux && \
. ~/.bashrc
```

## stow
```bash
cd .local && stow -t ~/.local .
```
