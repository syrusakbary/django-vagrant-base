#!/bin/bash

# Detect platform
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='mac'
fi


if ! foobar_loc="$(type -p virtualbox)" || [ -z "$foobar_loc" ]; then
    printf "\e[31mVirtualbox does not appear to be installed on your system.\e[0m\n"
    printf "Try to download the binary here https://www.virtualbox.org/wiki/Downloads/\n"
    exit 1
fi

if ! foobar_loc="$(type -p vagrant)" || [ -z "$foobar_loc" ]; then
    printf "\e[31mVagrant does not appear to be installed on your system.\e[0m\n"
    printf "Try to download the binary here http://downloads.vagrantup.com/\n"
    exit 2
fi

# Trick for ask sudo password at beginning 
sudo bash -c ''

printf "\e[32mInstalling vagrant required plugins\e[0m\n"
# vagrant plugin install vagrant-librarian-chef
# vagrant plugin install vagrant-hostsupdater
# vagrant plugin install vagrant-omnibus
# vagrant plugin install vagrant-digitalocean

printf "\e[32mAdd digital_ocean box\e[0m\n"
vagrant box add digital_ocean https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box

if [[ $platform == 'mac' ]]; then
    if ! foobar_loc="$(type -p brew)" || [ -z "$foobar_loc" ]; then
        printf "\e[31mHomebrew does not appear to be installed on your system.\e[0m\n"
        printf "Try to download the binary here http://brew.sh/\n"
        exit 3
    fi
    printf "\e[32mInstalling curl-ca-bundle via brew\e[0m\n"
    brew install curl-ca-bundle

    # Export var to .bash_profile
    LINE='export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt'
    if ! grep -Fx "$LINE" ~/.bash_profile >/dev/null 2>/dev/null; then
        echo "$LINE" >> ~/.bash_profile
    fi
fi


# Initialize Vagrant VM
printf "\e[32mSetting up Vagrant\e[0m\n"
vagrant up
