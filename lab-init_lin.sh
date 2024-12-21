#!/bin/bash

#Changing root password

passwd

#Enabling logging on terminal launch and creating log directory

echo 'test "$(ps -ocommand= -p $PPID | awk '"'"'{print $1}'"'"')" == '"'"'script'"'"' || (script -f $HOME/logs/$(date +"%d-%b-%y_%H-%M-%S").${HOSTNAME:-$(hostname)}.$$.${RANDOM}_shell.log)' >> /home/kali/.zshrc
mkdir $HOME/logs
sudo -u kali mkdir /home/kali/logs

#Creating WorkDesk

sudo -u kali mkdir /home/kali/Documents/WorkDesk
sudo -u kali mkdir /home/kali/Documents/WorkDesk/yaksas

#Installing Sublime-Text

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get update

sudo apt-get install sublime-text

echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections

sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders
