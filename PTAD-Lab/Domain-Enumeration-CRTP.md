### Get current domain
- Get-NetDomain (PowerView)
- Get-ADDomain (ActiveDirectory Module)

### Get object of another domain
- Get-NetDomain Domain <domain>
- Get-ADDomain Identity <domain>

### Get domain SID for the current domain
- Get-DomainSID
- (Get-ADDomain).DomainSID
