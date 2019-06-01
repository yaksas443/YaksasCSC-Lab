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
