#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function install(){

  if [ -f xrpck.sh ]; then
    cp xrpck.sh /usr/bin/xrpck
    echo -e "\n${greenColour}[+]${endColour} The tool has been installed"
  else
    echo -e "\n${redColour}[!]${endColour} The tool is not in the current directory"
  fi
}

install
