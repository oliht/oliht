$serversOuPath = 'OU=Servers,DC=domain,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
    $output = @{
        'ServerName'                  = $null
        'IPAddress'                   = $null
        'OperatingSystem'             = $null
        'AvailableDriveSpace (GB)'    = $null
        'Memory (GB)'                 = $null
        'UserProfilesSize (MB)'       = $null
        'StoppedServices'             = $null
    }
    $getCimInstParams = @{
        CimSession = New-CimSession -ComputerName $server
    }
    $output.ServerName = $server
    $output.'UserProfilesSize (MB)' = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
    $output.'AvailableDriveSpace (GB)' = [Math]::Round(((Get-CimInstance @getCimInstParams -ClassName Win32_LogicalDisk).FreeSpace / 1GB),1)
    $output.'OperatingSystem' = (Get-CimInstance @getCimInstParams -ClassName Win32_OperatingSystem).Caption
    $output.'Memory (GB)' = (Get-CimInstance @getCimInstParams -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum /1GB
    $output.'IPAddress' = (Get-CimInstance @getCimInstParams -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress[0]
    $output.StoppedServices = (Get-Service -ComputerName $server | Where-Object { $_.Status -eq 'Stopped' }).DisplayName
    Remove-CimSession -CimSession $getCimInstParams.CimSession
    [pscustomobject]$output
}
