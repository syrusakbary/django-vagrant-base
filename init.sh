#!/bin/bash
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
vagrant plugin install vagrant-librarian-chef
vagrant plugin install vagrant-hostsupdater

# Initialize Vagrant VM
printf "\e[32mSetting up Vagrant\e[0m\n"
INSTALL_CHEF=1 vagrant up