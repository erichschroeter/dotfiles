
# Installing my dotfiles

## Linux

1. Install dependencies
    - [stow](https://www.gnu.org/software/stow/) (see [docs](https://www.gnu.org/software/stow/manual/stow.html))
    - [Starship](https://starship.rs/guide/#%F0%9F%9A%80-installation)
    - [eza](https://github.com/eza-community/eza)
      - [installation on Ubuntu](https://github.com/eza-community/eza/blob/main/INSTALL.md#debian-and-ubuntu)
    - [ripgrep](https://github.com/BurntSushi/ripgrep)
    - [bat](https://github.com/sharkdp/bat)
    ```bash
    sudo apt update
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza

    curl -sS https://starship.rs/install.sh | sh
    sudo apt install -y stow ripgrep bat
    ```
2. Clone and install links to [erichschroeter/dotfiles.git](https://github.com/erichschroeter/dotfiles)
    ```bash
    cd ~
    git clone git@github.com:erichschroeter/dotfiles.git .dotfiles
    cd .dotfiles/
    stow --adopt .
    ```

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
