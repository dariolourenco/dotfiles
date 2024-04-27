if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  # Relaunch the script with administrator rights
  $arguments = "& '" + $myinvocation.mycommand.definition + "'"
  # Start-Process powershell -Verb runAs -ArgumentList $arguments
  #Exit
}

function Remove-One-Drive {
  [OutputType([bool])]
  param()
  Write-Output "Removing One Drive"
  Stop-Process -Name "OneDrive" -Force
  Start-Process "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe" /uninstall
}

function Install-WSL {
  [OutputType([void])]
  param()
  Write-Output "Installing WSL"
  wsl --install Ubuntu -n
}

function Is-Application-Installed {
  [OutputType([bool])]
  param(
    [string]$applicationName
  )
  if (Get-Command $applicationName -ErrorAction SilentlyContinue) {
    return $true
  }
  else {
    return $false
  }
}

function Install-Scoop {
  if (Is-Application-Installed "scoop" -eq $false) {
    Write-Host "installing scoop"
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression 
  }
  else {
    Write-Host "scoop already installing. Updating scoop"
    scoop update
  }
}

function Add-Scoop-Buckets {
  scoop bucket add stripe https://github.com/stripe/scoop-stripe-cli.git
  scoop bucket add extras
  scoop bucket add nerd-fonts
}

function Install-With-Winget {
  param(
    [string]$packageName
  )
  $wingetInstallCommand = "winget install $packageName -e"
  Invoke-Expression -Command $wingetInstallCommand
}


Write-Host "[>] Installing Scoop"
Install-Scoop
Add-Scoop-Buckets

Write-Host "[>] Installing Basic Apps"
scoop install Monaspace-NF
scoop install Firacode-NF
scoop install fzf
scoop install bat
scoop install ripgrep
#scoop install nvim
scoop install neovide

Remove-One-Drive
#scoop update *
#Install-With-Winget "chocolatey"
#Install-With-Winget "vim.vim"

