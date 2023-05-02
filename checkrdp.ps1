$cred = Get-Credential
$hosts = Get-Content -Path "C:\Users\Rootsec\Desktop\hosts.txt"

foreach ($host in $hosts) {
    $error.Clear()
    $connection = New-Object -ComObject "MsRdp.RdpClient"
    $connection.Server = $host
    $connection.AdvancedSettings2.ClearTextPassword = $cred.GetNetworkCredential().Password
    $connection.UserName = $cred.GetNetworkCredential().UserName

    $connection.Connect()

    if ($connection.Connected) {
        Write-Host "You can log in to $host with your current credentials."
        $connection.Disconnect()
    }
    else {
        Write-Host "Failed to connect to $host. Error: $($error[0].Exception.Message)"
    }
}
