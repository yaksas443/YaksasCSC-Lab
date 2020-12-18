#!/bin/bash

# Creating dist directory to store tools that need to be available for download via the web server. Copy this directory to /var/www/html folder
mkdir /home/kali/Documents/WorkDesk/Tools/dist

# Installing Metalist - custom wordlist generation tool

mkdir /home/kali/Documents/WorkDesk/Tools/mentalist

git clone https://github.com/sc0tfree/mentalist.git /home/kali/Documents/WorkDesk/Tools/mentalist
cd /home/kali/Documents/WorkDesk/Tools/mentalist/
sudo python3 setup.py install

# Downloading Mimikatz - tool to dump cached credentials and perform certain Active Directory related attacks

mkdir /home/kali/Documents/WorkDesk/Tools/mimikatz

wget https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20200918-fix/mimikatz_trunk.zip -O /home/kali/Documents/WorkDesk/Tools/mimikatz/mimikatz.zip

unzip /home/kali/Documents/WorkDesk/Tools/mimikatz/mimikatz.zip -d /home/kali/Documents/WorkDesk/Tools/mimikatz

cp /home/kali/Documents/WorkDesk/Tools/mimikatz/x64/mimikatz.exe /home/kali/Documents/WorkDesk/Tools/dist/mimikatz64.exe

cp /home/kali/Documents/WorkDesk/Tools/mimikatz/Win32/mimikatz.exe /home/kali/Documents/WorkDesk/Tools/dist/mimikatz32.exe

# Downloading PowerUp.ps1 - PowerShell script to check for privilege escalation vectors in Windows systems

mkdir /home/kali/Documents/WorkDesk/Tools/PowerUp

wget https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Privesc/PowerUp.ps1 -O /home/kali/Documents/WorkDesk/Tools/PowerUp/PowerUp.ps1

cp /home/kali/Documents/WorkDesk/Tools/PowerUp/PowerUp.ps1 /home/kali/Documents/WorkDesk/Tools/dist/PowerUp.ps1

# Downloading Nmap static binary - network scanning tool

mkdir /home/kali/Documents/WorkDesk/Tools/nmap-static

wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/nmap -O /home/kali/Documents/WorkDesk/Tools/nmap-static/nmap

cp /home/kali/Documents/WorkDesk/Tools/nmap-static/nmap /home/kali/Documents/WorkDesk/Tools/dist/nmap


# Downloading nc64.exe - 64-bit version of netcat

mkdir /home/kali/Documents/WorkDesk/Tools/nc64

wget https://github.com/int0x33/nc.exe/raw/master/nc64.exe -O /home/kali/Documents/WorkDesk/Tools/nc64/nc64.exe

cp /home/kali/Documents/WorkDesk/Tools/nc64/nc64.exe /home/kali/Documents/WorkDesk/Tools/dist/nc64.exe


# Downloading SharpHound - Tool to perform AD enumeration. Output from this tool is fed to BloodHound

mkdir /home/kali/Documents/WorkDesk/Tools/SharpHound

wget https://github.com/BloodHoundAD/BloodHound/raw/master/Collectors/SharpHound.exe -O /home/kali/Documents/WorkDesk/Tools/SharpHound/SharpHound.exe

cp /home/kali/Documents/WorkDesk/Tools/SharpHound/SharpHound.exe /home/kali/Documents/WorkDesk/Tools/dist/SharpHound.exe

# Installing BloodHound - Graph theory based tool to represent information collected from Active Directory network

sudo apt-get install bloodhound

# Installing PoshC2 - Python3 based command and control centre framework

curl -sSL https://raw.githubusercontent.com/nettitude/PoshC2/master/Install.sh | sudo bash
