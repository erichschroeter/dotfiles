
# Installing my dotfiles

## Linux

1. Install dependencies
    - [stow](https://www.gnu.org/software/stow/) (see [docs](https://www.gnu.org/software/stow/manual/stow.html))
    - [Starship](https://starship.rs/guide/#%F0%9F%9A%80-installation)
    - [exa](https://github.com/ogham/exa)
    - [ripgrep](https://github.com/BurntSushi/ripgrep)
    - [bat](https://github.com/sharkdp/bat)
    ```bash
    curl -sS https://starship.rs/install.sh | sh
    sudo apt install stow exa ripgrep bat
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
2. Add the following to `$PROFILE`:
    ```powershell
    $ENV:STARSHIP_CONFIG = "$HOME\dotfiles\config\starship.toml"
    Get-ExecutionPolicy -Scope CurrentUser -OutVariable CurrentUserExecutionPolicy
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    If(Get-Command starship -errorAction SilentlyContinue){Invoke-Expression (&starship init powershell)}
    Set-ExecutionPolicy $CurrentUserExecutionPolicy -Scope CurrentUser
    ```

