# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

Import-Module .\Set-AuditRule.ps1

$AuditRules = @"
regKey;identityReference;rights;inheritanceFlags;propagationFlags;auditFlags
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunService";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceService";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunService";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnceService";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\Software\Policies\Microsoft Services\AdmPwd";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SYSTEM\CurrentControlSet\Control\Lsa";"Everyone";"QueryValues";"None";"None";"Success"
"HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\SYSTEM\CurrentControlSet\Services\SysmonDrv\Parameters";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\Software\Policies\Microsoft\Windows\EventLog\EventForwarding\SubscriptionManager";"Everyone";"QueryValues";"None";"None";"Success"
"HKLM:\Software\Microsoft\.NETFramework";"Everyone";"WriteKey";"None";"None";"Success"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam";"Everyone";"SetValue,WriteKey";"ContainerInherit";"InheritOnly";"Success"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone";"Everyone"; "SetValue,WriteKey";"ContainerInherit";"InheritOnly";"Success"
"HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TelemetryController";"Everyone"; "SetValue,WriteKey";"ContainerInherit";"InheritOnly";"Success"
"@

write-host "Enabling audit rules.."
$AuditRules | ConvertFrom-Csv -Delimiter ';' | ForEach-Object {
    if(!(Test-Path $_.regKey)){
        Write-Host $_.regKey " does not exist.."
        New-Item $_.regKey -Force
    }
    else {
        Write-Host "Updating SACL of " $_.regKey
        Set-AuditRule -RegistryPath $_.regKey -IdentityReference $_.identityReference  -Rights $_.rights.split(",") -InheritanceFlags $_.inheritanceFlags -PropagationFlags $_.propagationFlags -AuditFlags $_.auditFlags -ErrorAction SilentlyContinue
    }
}