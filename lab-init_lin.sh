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

archii="$(uname -m)"

if [ $archii = "x86_64" ]
then
    wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb
    dpkg -i sublime-text_build-3083_amd64.deb
else
    wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_i386.deb
    dpkg -i sublime-text_build-3083_i386.deb
fi
