### Using redirectors with PoshC2
#### PoshC2 configuration
- Update the ```PayloadCommsHost``` URL to that of the redirector machine.
#### Installing and starting socat on redirector machine
- ```sudo apt-get install socat```
- ```socat TCP4-LISTEN:80,fork TCP4:[C2 server IP]:80```
