$computers = Get-Content -Path ".\hosts.txt"

foreach ($computer in $computers) {
    $acl = Get-Acl "WinRM:\$computer\root"
    $access = $acl.Access | Where-Object { $_.IdentityReference -eq $env:USERNAME -and $_.FileSystemRights -eq 'ReadAndExecute' }

    if ($access -ne $null) {
        Write-Output "$computer: Access granted"
        mstsc /v:$computer
    } else {
        Write-Output "$computer: Access denied"
    }
}
