Activating Windows Server 2016 with KMS Server - http://woshub.com/activating-windows-server-2016-with-kms-server/#h2_5

http://woshub.com/how-to-upgrade-windows-server-2016-evaluation-to-full-version/

https://www.bulldogtechinc.com/2017/09/19/converting-evaluation-versions-to-retail-versions-of-windows-server-2012/

Activatin Visio 2019

https://msguides.com/microsoft-software-products/project-visio-free-license.html

Building and Attacking an Active Directory lab with PowerShell	 - https://1337red.wordpress.com/building-and-attacking-an-active-directory-lab-with-powershell/

  Commands to Install AD on Windows Server 2016:
  
    Install-windowsfeature AD-domain-services

    Import-Module ADDSDeployment

    Install-ADDSForest -CreateDnsDelegation:$false ` -DatabasePath "C:\Windows\NTDS" ` -DomainMode "Win2012R2" ` -DomainName "server1.hacklab.local" ` -DomainNetbiosName "server1" `  -ForestMode "Win2012R2" `  -InstallDns:$true `  -LogPath "C:\Windows\NTDS" `  -NoRebootOnCompletion:$false `  -SysvolPath "C:\Windows\SYSVOL" `  -Force:$true
    
    Install-WindowsFeature RSAT-ADDS
  
  Commands to add user to domain:
  
    net user ptadlab1 <password> /ADD /DOMAIN
    
    net group “Domain Admins” user1 /add

To resolve "Specified domain already exists" - run NewSID or Sysprep (located in C:\Windows\System32\sysprep folder)  - https://www.experts-exchange.com/questions/26394641/DCPromo-The-Specified-Domain-Already-Exists.html

## Commands to configure servers and machines

```powershell
$hostname = hostname
Rename-Computer -ComputerName $hostname -NewName "tfl-dev-jk-71" -LocalCredential Administrator -Force
$ifindex = Get-NetAdapter | Where-Object Status -eq "Up" | select ifindex -ExpandProperty ifindex
New-NetIPAddress -InterfaceIndex $ifindex -IPAddress 192.168.3.71
Set-NetIPAddress -InterfaceIndex $ifindex -IPAddress 192.168.3.71 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceIndex $ifindex -ServerAddresses ("192.168.3.80")
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Set-MpPreference -DisableRealtimeMonitoring $true
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6
```
