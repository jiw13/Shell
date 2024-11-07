#!/bin/bash
#Colours

greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;037m\033[1m"
endColour="\033[0m\e[0m"

echo -e "\n
         ${yellowColour}[+++++++++++++++++++] ${endColour}\n
         Interfaz: ${turquoiseColor}$(ip a | grep enp0s3 | cut -c4-9 | grep enp0s3)${endColour}
         Ip privada: ${redColour}$(ip a | grep enp0s3 | awk 'NR==2' | cut -c9-21) ${endColour}\n
         ${yellowColour}[+++++++++++++++++++] ${endColour}\n"




