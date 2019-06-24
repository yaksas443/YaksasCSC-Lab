### To import a module

Import-Module <module-name>

### Get current domain
- Get-NetDomain (PowerView)
- Get-ADDomain (ActiveDirectory Module)

### Get object of another domain
- Get-NetDomain Domain <domain>
- Get-ADDomain Identity <domain>

### Get domain SID for the current domain
- Get-DomainSID
- (Get-ADDomain).DomainSID

### Get domain policy for the current domain
- Get-DomainPolicy
- (Get-DomainPolicy)."system access"

### Get domain policy for another domain
- (Get-DomainPolicy -domain <domain>))."system access"
  
### Get a list of users in the current domain
- Get-NetUser
- Get-NetUser Username <username>
- Get-ADUser Filter Properties
- Get-ADUser Identity <username> Properties *

### Get list of all properties for users in the current domain
- Get-UserProperty
- Get-UserProperty Properties pwdlastset
- Get-ADUser -Filter * -Properties * | select -First 1 | Get-Member -MemberType *Property | select Name
- Get-ADUser -Filter * -Properties * | select name,@{expression={[datetime]::fromFileTime($_.pwdlastset)}}  

### Search for a particular string in a user's attributes:
- Find-UserField -SearchField Description -SearchTerm "built"
- Get-ADUser -Filter 'Description -like "*built*"' -Properties Description | select name, Description

### Get a list of computers in the current domain
- Get-NetComputer
- Get-NetComputer -OperatingSystem "*Server 2016*"
- Get-NetComputer Ping
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

### Get the ACLs associated with the specified object

- Get-ObjectAcl -SamAccountName <Objectname> -ResolveGUIDs
  
 ### Get the ACLs associated with the specified prefix to be used for search
 
 - Get-ObjectAcl -ADSprefix 'CN=Administrator,CN=Users' -Verbose
 
  ### Get the ACLs associated with the specified prefix to be used for search
 
 - Get-ObjectAcl -ADSprefix 'CN=Administrator,CN=Users' -Verbose
