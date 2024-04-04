if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Relaunch the script with administrator rights
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
   # Start-Process powershell -Verb runAs -ArgumentList $arguments
    #Exit
}


function Install-Scoop{
  $installed = $null
  try{
      $installed = Get-Command scoop -ErrorAction Stop
  }catch{
        Write-Host "scoop is not Installed"
  }
  if($null -eq $installed){
      Write-Host "installing scoop"
      Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
      Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression 
  }
  else{
      Write-Host "scoop already installing. Updating scoop"
      scoop update
    }
  }
function Add-Scoop-Buckets{
  scoop bucket add stripe https://github.com/stripe/scoop-stripe-cli.git
  scoop bucket add extras
  scoop bucket add nerd-fonts
}

function Install-With-Winget{
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
scoop install nvim
scoop install neovide

#scoop update *
#Install-With-Winget "chocolatey"
#Install-With-Winget "vim.vim"

