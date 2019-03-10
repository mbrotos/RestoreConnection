# Creates a new registry key or updates the existing RestoreConnection key in order to stop mapped network drives from auto connection on start up.
# This script makes persistent network drives only attempt connection when opened in explorer.

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "&" + $MyInvocation.MyCommand.Definition + "" 
    Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator." -ForegroundColor "White"
    Start-Sleep 1
    Start-Process "powershell.exe" -Verb RunAs -ArgumentList $arguments
    Break
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
