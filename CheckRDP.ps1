$Hosts = Get-Content .\hosts.txt
$UserName = $env:USERNAME

foreach ($Host in $Hosts) {
    $RDP = Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -ComputerName $Host | Where-Object {$_.TerminalName -eq "RDP-Tcp"}
    $SecurityDescriptor = $RDP.GetSecurityDescriptor().Descriptor
    $DA = New-Object System.Security.AccessControl.DirectorySecurity
    $DA.SetSecurityDescriptorSddlForm($SecurityDescriptor)
    $AccessRules = $DA.GetAccessRules($true, $false, [System.Security.Principal.NTAccount])
    $RDPAccess = $AccessRules | Where-Object { $_.IdentityReference.Value -eq "NT Authority\Remote Desktop Users" -and $_.AccessControlType -eq "Allow" }

    if ($RDPAccess) {
        Write-Host "You have Remote Desktop access to $Host"
    }
    else {
        Write-Host "You do not have Remote Desktop access to $Host"
    }
}
