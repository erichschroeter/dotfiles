$ENV:STARSHIP_CONFIG = "$HOME\.dotfiles\config\starship.toml"
Get-ExecutionPolicy -Scope CurrentUser -OutVariable CurrentUserExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
If(Get-Command starship -errorAction SilentlyContinue){Invoke-Expression (&starship init powershell)}
Set-ExecutionPolicy $CurrentUserExecutionPolicy -Scope CurrentUser

If (Test-Path Alias:ls) {Remove-Item Alias:ls}
New-Alias -Name ls -Value eza
function ll {eza -alh}
function tree {eza --tree}
#New-Alias -Name cat -Value 'batcat -p'

Import-Module posh-git