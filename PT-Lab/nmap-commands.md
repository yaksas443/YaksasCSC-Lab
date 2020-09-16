## Host Discovery

nmap -sn <IP range>
sudo nmao -sn <IP range>
for i in {1..254}; do (ping 172.16.1.$i -c 1 -w 5 >/dev/null && echo "172.16.1.$i" &); done
