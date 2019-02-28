#!/bin/bash

#Changing root password

passwd

#Enabling logging on terminal launch and creating log directory

echo 'test "$(ps -ocommand= -p $PPID | awk '"'"'{print $1}'"'"')" == '"'"'script'"'"' || (script -f $HOME/logs/$(date +"%d-%b-%y_%H-%M-%S").${HOSTNAME:-$(hostname)}.$$.${RANDOM}_shell.log)' >> /etc/bash.bashrc
mkdir $HOME/logs

#Creating WorkDesk

mkdir $HOME/Documents/WorkDesk
mkdir $HOME/Documents/WorkDesk/yaksas

#Installing Sublime-Text

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get update

sudo apt-get install sublime-text
