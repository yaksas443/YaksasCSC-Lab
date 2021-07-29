### Bypass Execution Policy for current user
- Set-ExecutionPolicy bypass -Scope CurrentUser

### To import a module
- Import-Module <module-name>
- Import-Module .\Microsoft.ActiveDirectory.Management.dll
- Import-Module .\ActiveDirectory\ActiveDirectory.psd1

### Get current domain
- Get-NetDomain (PowerView)
- Get-ADDomain (ActiveDirectory Module)

- $ADClass = [System.DirectoryServices.ActiveDirectory.Domain] (ADSI)
- $ADClass::GetCurrentDomain()

### Get object of another domain
- Get-NetDomain Domain <domain>
- Get-ADDomain Identity <domain>

### Get Information on Domain Controllers
- Get-NetDomainController
- Get-ADDomainController

### Get domain SID for the current domain
- Get-DomainSID
- (Get-ADDomain).DomainSID

### Get domain policy for the current domain
- Get-DomainPolicy
- (Get-DomainPolicy -domain ycsccorp.local))."system access"
- (Get-DomainPolicy)."kerberos policy"

### Get domain policy for another domain
- (Get-DomainPolicy -domain <domain>))."system access"
  
### Get a list of users in the current domain
- Get-NetUser
- Get-NetUser -Username user.ycsc01
- Get-NetUser | Select-Object samaccountname
- Get-NetUser | Select-Object adspath
- Get-ADUser -Filter * -Properties *
- Get-ADUser -Identity user.ind01 -Properties *

### Get list of all properties for users in the current domain
- Get-UserProperty
- Get-UserProperty -Properties pwdlastset
- Get-UserProperty -Properties badpwdcount
- Get-ADUser -Filter * -Properties * | select -First 1 | Get-Member -MemberType *Property | select Name
- Get-ADUser -Filter * -Properties * | select name,@{expression={[datetime]::fromFileTime($_.pwdlastset)}}  

### Search for a particular string in a user's attributes:
- Find-UserField -SearchField Description -SearchTerm "built"
- Get-ADUser -Filter 'Description -like "*built*"' -Properties Description | select name, Description

### Get a list of computers in the current domain
- Get-NetComputer
- Get-NetComputer -OperatingSystem "*Server 2016*"
- Get-NetComputer -Ping
- Get-NetComputer FullData
- Get-ADComputer -Filter * | select Name
- Get-ADComputer -Filter 'OperatingSystem -like "*Server 2016*"' -Properties OperatingSystem | select Name, OperatingSystem
- Get-ADComputer -Filter * -Properties DNSHostName | %{Test-Connection -Count 1 -ComputerName $_.DNSHostName}
- Get-ADComputer -Filter * -Properties *

### Get all the groups in the current domain
- Get-NetGroup
- Get-NetGroup -Domain <targetdomain>
- Get-NetGroup -FullData
- Get-ADGroup -Filter | select Name
- Get-ADGroup -Filter * -Properties *

### Get all groups containing the word "admin" in group name
- Get-NetGroup *admin*
- Get-ADGroup -Filter 'Name -like "*admin*"' | select Name

### Get all the members of the Domain Admins group
- Get-NetGroupMember -GroupName "Domain Admins" -Recurse
- Get-ADGroupMember -Identity "Domain Adins" -Recursive

### List all the local groups on a machine (needs administrator privs on non-dc machines)
- Get-NetLocalGroup -ComputerName ycsc-ind-dc.ind.ycsccorp.local -ListGroups

### Get members of all the local groups on a machine
- Get-NetLocalGroup -ComputerName ycsc-ind-dc.ind.ycsccorp.local -Recurse

### Get the group membership for a user
- Get-NetGroup -UserName "user.ind01"
- Get-ADPrincipalGroupMembership -Identity user.ind01

### Get actively logged users on a computer (needs local admin rights on the target)
- Get-NetLoggedon –ComputerName <servername>

### Get locally logged users on a computer (needs remote registry on the target - started by-default on server OS)
- Get-LoggedonLocal -ComputerName dcorp- dc.dollarcorp.moneycorp.local

### Get the last logged user on a computer (needs administrative rights and remote registry on the target)
- Get-LastLoggedOn –ComputerName <servername>

### Find shares on hosts in current domain 
- Invoke-ShareFinder –Verbose

### Find sensitive files on computers in the domain 
- Invoke-FileFinder –Verbose

### Get all fileservers of the domain 
- Get-NetFileServer

### Get list of GPO in current domain. 
- Get-NetGPO
- Get-NetGPO -ComputerName ycsc-ind-web.ind.ycsccorp.local
- Get-GPO -All (GroupPolicy module) 
- Get-GPResultantSetOfPolicy -ReportType Html -Path C:\Users\Administrator\report.html (Provides RSoP)

### Get GPO(s) which use Restricted Groups or groups.xml for interesting users
- Get-NetGPOGroup

### Get users which are in a local group of a machine using GPO 
- Find-GPOComputerAdmin –Computername ycsc-ind-web.ind.ycsccorp.local

### Get machines where the given user is member of a specific group 
- Find-GPOLocation -UserName user.ind01 -Verbose

### Get OUs in a domain 
- Get-NetOU -FullData
- Get-ADOrganizationalUnit -Filter * -Properties *

### Get GPO applied on an OU. Read GPOname from gplink attribute from Get-NetOU
- Get-NetGPO -GPOname "{AB306569-220D-43FF-B03B- 83E8F4EF8081}"
- Get-GPO -Guid AB306569-220D-43FF-B03B-83E8F4EF8081 (GroupPolicy module)

## ACL Enumeration

### Get the ACLs associated with the specified object
- Get-ObjectAcl -SamAccountName <Objectname> -ResolveGUIDs
  
### Get the ACLs associated with the specified prefix to be used for search
 - Get-ObjectAcl -ADSprefix 'CN=Administrator,CN=Users' -Verbose
 
### Get the ACLs associated with the specified LDAP path to be used for search
 - Get-ObjectAcl -ADSpath "LDAP://CN=DomainAdmins,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local" -ResolveGUIDs -Verbose
 
### Search for interesting ACEs
- Invoke-ACLScanner -ResolveGUIDs
- Get-NetGPO | %{Get-ObjectAcl -ResolveGUIDs -Name $_.Name} | ?{$_.IdentityReference -match "ind"}
- Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference - match "ind"}
- Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference - match "RDPUsers"}

### Get the ACLs associated with the specified path
- Get-PathAcl -Path "\\dcorp-dc.dollarcorp.moneycorp.local\sysvol"

## Domain Trust mapping
 
### Get a list of all domain trusts for the current domain
- Get-NetDomainTrust
- Get-NetDomainTrust -Domain us.dollarcorp.moneycorp.local

## Forest mapping
 
### Get details about the current forest
- Get-NetForest
- Get-NetForest -Forest eurocorp.local

### Get all domains in the current forest
- Get-NetForestDomain
- Get-NetForestDomain -Forest eurocorp.local

### Get all global catalogs for the current forest
- Get-NetForestCatalog
- Get-NetForestCatalog -Forest eurocorp.local

### Map trusts of a forest
- Get-NetForestTrust
- Get-NetForestTrust -Forest eurocorp.local

## User Hunting

### Find all machines on the current domain where the current user has local admin access
- Find-LocalAdminAccess -Verbose

### Find local admins on all machines of the domain (needs administrator privs on non dc machines).
- Invoke-EnumerateLocalAdmin -Verbose

### Find computers where a domain admin (or specified user/group) has sessions:
- Invoke-UserHunter
- Invoke-UserHunter -GroupName "RDPUsers"
- Get-NetSession -Computername ycsc-ind-dc

### To confirm admin access
- Invoke-UserHunter -CheckAccess

### Find computers where a domain admin is logged in.
- Invoke-UserHunter -Stealth
