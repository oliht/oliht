while($true) {

    Write-host 
    "Bitte starten Sie das Programm als Administrator!
    1. Rechte setzen fuer Tool
    2. Prozesse anzeigen
    3. IP Konfiguration anzeigen
    4. Logins in Datei speichern (C:\)
    5. Security Logs (letzte 1000) anzeigen
    6. Security Logs (letzte 10000) speichern (C:\)
    7. freien Speicherplatz anzeigen
    8. Computer Info anzeigen
    9. Netzwerkübersicht anzeigen
    10.Test-Connection (Ping)
    "
    $Eingabe=read-host -prompt "Bitte eine Zahl eingeben"

    if ($Eingabe -eq '1') {
    set-ExecutionPolicy RemoteSigned
    }
    
        elseif ($Eingabe -eq '2') { 
           Get-Process
        }

        elseif ($Eingabe -eq '3') {
            Get-NetIPConfiguration
        }
    
        elseif ($Eingabe -eq '4') {
            Get-EventLog security | Where-Object {$_.TimeGenerated -gt '9/15/16'} | Where-Object {($_.InstanceID -eq 4634) -or ($_.InstanceID -eq 4624)} | Select-Object TimeGenerated,InstanceID,Message | Out-File -FilePath "c:\Logins.txt"
        
        }

        elseif ($Eingabe -eq '5') {
            Get-EventLog Security -Newest 1000
        }

        elseif ($Eingabe -eq '6') {
            Get-EventLog Security -Newest 10000 | Out-File -FilePath "c:\Security_Logs.txt"
        }

        elseif ($Eingabe -eq '7') {
            Get-Volume | Select-Object DriveLetter, FileSystemLabel, @{Name="FreeSpace(GB)";Expression={$_.SizeRemaining/1GB -as [int]}}
        }

        elseif ($Eingabe -eq '8') {
            Get-ComputerInfo | fl CsManufacturer,CsModel,CsName,CsPhyicallyInstalledMemory,CsProcessors,CsNumberOfProcessors,WindowsInstallDateFromRegistry,WindowsProductName,OsArchitecture,OsLanguage,OsInstallDate,OsVersion,OsRegisteredUser
        }

        elseif ($Eingabe -eq '9') {
            Get-NetNeighbor -AddressFamily IPv4 -State Reachable 
        }

        elseif ($Eingabe -eq '10') {
            $computerName = Read-Host "Geben Sie den Namen oder die IP-Adresse des Zielhosts ein:"
            Test-Connection -ComputerName $computerName -Count 5 -Delay 1 -BufferSize 32    
        }

    
    else {
        write-host 'Die Eingabe ist keine gültige Zahl' -foregroundcolor red
    }
 pause
}