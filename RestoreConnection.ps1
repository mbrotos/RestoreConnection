# Creates a new registry key or updates the existing RestoreConnection key in order to stop mapped network drives from auto connection on start up.
# This script makes persistent network drives only attempt connection when opened in explorer.

param([switch]$Elevated)

function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) 
    {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-windowstyle hidden -noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }

    exit
}

#Now running with as admin

$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\NetworkProvider"

$Name = "RestoreConnection"

$value = "0"

IF(!(Test-Path $registryPath))#If the regitry doesn't already exist we create it
{
    New-Item -Path $registryPath -Force | Out-Null
}

New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null #set the value to 0
