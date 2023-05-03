# Define the path to the hosts file
$hostsFilePath = Join-Path $PSScriptRoot "hosts.txt"

# Get the current user's name
$userName = $env:USERNAME

# Read the hosts file into an array
$hosts = Get-Content $hostsFilePath

# Loop through each host and test RDP connection
foreach ($computerName in $hosts) {
    try {
        $result = Test-NetConnection -ComputerName $computerName -Port 3389
        if ($result.TcpTestSucceeded) {
            # Check if the current user has Remote Desktop access to the computer
            $acl = (Get-Acl "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\").AccessToString
            if ($acl -match "$userName\s+Allow\s+FullControl") {
                Write-Host "You have Remote Desktop access to $computerName"
            } else {
                Write-Host "You do not have Remote Desktop access to $computerName"
            }
        } else {
            Write-Host "Could not establish a connection to $computerName"
        }
    } catch {
        Write-Host "Error testing connection to $computerName: $_"
    }
}
