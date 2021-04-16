## Tool: nmap

Standard port scan with host discovery disabled

- ``` nmap -Pn -sC -sV -A 10.10.10.125 ```

## Tool: sqlmap

Check for SQL injection in a GET based login request (takes a request file)

- ```sqlmap -r login.req --batch```
- ```sqlmap -r login.req --batch -level 5 --risk 3 ```

## Tool: kerbrute

Validate a list of users via Kerberos

- ```/opt/kerbrute_linux_amd64 userenum --dc 10.10.10.193 -d fabricorp.local userlist.txt```
