
## Linux

1. Install [Starship](https://starship.rs/guide/#%F0%9F%9A%80-installation)
    ```
    curl -sS https://starship.rs/install.sh | sh
    ```
2. Install symbolic links to files in this repo.
    ```bash
    ./install-symlinks.sh
    ```

## Linux

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

