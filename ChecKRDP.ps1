$computers = Get-Content -Path ".\hosts.txt"

foreach ($computername in $computers) {
    Write-Host "Testing connection to $computername..."
    try {
        $test = Test-NetConnection -ComputerName $computername -CommonTCPPort RDP
        if ($test.TcpTestSucceeded) {
            Write-Host "$computername is reachable."
            $acl = (Get-Acl "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system").AccessToString
            if ($acl -match "RemoteInteractive") {
                Write-Host "You have RDP access to $computername."
            } else {
                Write-Host "You do not have RDP access to $computername."
            }
        } else {
            Write-Host "$computername is unreachable."
        }
    } catch {
        Write-Host "Error testing connection to $computername: $_"
    }
}
