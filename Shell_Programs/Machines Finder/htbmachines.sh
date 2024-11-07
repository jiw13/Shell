#!/bin/bash


#Tarea a implementar a futuro
#1-> Mejora visual con colores
#2-> Implementar mas tipos de filtro pudiendo abrir el enlace de youtube con otro parametro
#3-> Poder implementar otro menu mas general para otras paginas de hacking pudiendo elegir entre HTB,TryHackme...



#Colours

greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;037m\033[1m"
endColour="\033[0m\e[0m"


function ctrl_c()
{ echo -e "\n${redColour}[+] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}
#VARIABLES GLOBALES
main_url="https://htbmachines.github.io/bundle.js"

#Ctrl_C
trap ctrl_c INT

#Menu
function help_panel()
{
  echo -e "\nUso: \n"
  echo -e "\t m) Buscar por un nombre de maquina"
  echo -e "\t i) Obtener maquina proporcionando ip"
  echo -e "\t d) Obtener maquinas proporcionando dificultad\n\t\t ->Dificultades: Fácil,Media,Difícil e Insane\n"
  echo -e "\t o) Obtener maquinas de un SO concreto.\n"
  echo -e "\t s) Obtener maquinas donde hagan falta cierto tipo de skill.\n\t ->Skills: SQLI, Active Directory, Buffer Overflow...\n\tNota: Si el nombre de una skill es compuesto, utilizar \"\"\n"
  echo -e "\t y) Obtener link de resolucion de la maquina de Youtube"
  echo -e "\t u) Actualizar y/u obtener ficheros nuevos"
  echo -e "\t h) Buscar por panel de ayuda"
}

function searchMachine(){
  machine_name="$1"
  busqueda=$(cat bundle.js | awk "/name: \"$machine_name\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//')
  if [ "$busqueda" ]; then
    echo -e "\nMostrando las propiedades de de la maquina: $machine_name\n"
    echo -e "$busqueda"
  else
    echo -e "\nNo existe la maquina $machine_name\n"
  fi
}

function updateFiles(){
  echo -e "\n[!] Comprobando Updates..."
  if [ ! -f bundle.js ]; then
     tput civis
     echo -e "\n[!]Descargando archivos necesarios..."
     curl -s $main_url > bundle.js
     js-beautify bundle.js | sponge bundle.js
     echo -e "\n[!]Archivos descargados"
     tput cnorm
   else
     #En caso de que exista hacemos validaciones con md5 para ver si ha cambiado algo
     tput civis
     curl -s $main_url > bundle_temp.js
     js-beautify bundle_temp.js | sponge bundle_temp.js
     md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
     md5_original_value=$(md5sum bundle.js | awk '{print $1}')
    
     if [ "$md5_temp_value" == "$md5_original_value" ]; then
        echo -e "\nNo hay actualizaciones"
        rm bundle_temp.js
        else
         #Si hay acts cambiamos los ficheros desact por los mas actuales
         echo -e "\nHay actualizaciones\nDescargando..."
         rm bundle.js && mv bundle_temp.js bundle.js
         echo -e "\n[+]Todos los archivos han sido actualizados"
     fi
      tput cnorm
    
  fi

}
function searchIp(){
 ipAddress="$1"
 machine_name="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
 if [ "$machine_name" ]; then
  echo -e "\n\nLa maquina con ip $ipAddress es: $machine_name\n\n"
else
  echo -e "\nLa maquina $machine_name no existe\n"
 fi
}

function getYoutubeLink(){
  machine_name="$1"
  link="$(cat bundle.js | awk "/name: \"$machine_name\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')"
  if [ "$link" ]; then
   echo -e "\nEl link para la maquina $machine_name es: $link"
 else
   echo -e "\nNo existe la maquina $machine_name"
  fi
}

function getDificult(){
 machineDif="$1"
 maquinas="$(cat bundle.js | grep  "dificultad: \"$machineDif\"" -B 5 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column)"
 if [ "$maquinas" ]; then
   echo -e "\nLas maquinas con dificultad: \"$machineDif\" son:\n"
   cat bundle.js | grep  "dificultad: \"$machineDif\"" -B 5 | grep "name:" | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column
 else
  echo -e "\nDificultad proporcionada erronea o no existe\n"
 fi

}

function getSo(){
 so="$1"
 maquinas="$(cat bundle.js | grep  "so: \"$so\"" -B 5 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ',')"
 if [ "$maquinas" ]; then
   echo -e "\nLas máquinas con Sistema operativo: \"$so\" son: \n"
   cat bundle.js | grep  "so: \"$so\"" -B 5 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column
   
 else
   echo -e "\nNo hay maquinas disponibles para ese SO."
 fi

}

function getSoDifMachines(){
 machineDif="$1"
 so="$2"
 maquinas="$(cat bundle.js | grep "so: \"$so\"" -C 4 | grep "dificultad: \"$machineDif\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
 if [ "$maquinas" ]; then
   echo -e "\nLas maquinas con SO: \"$so\" y dificultad: \"$machineDif\" son:\n"
   cat bundle.js | grep "so: \"$so\"" -C 4 | grep "dificultad: \"$machineDif\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
 else
   echo -e "\nNo se ha encontrado ninguna maquina \"$so\" con dificultad \"$machineDif\""
 fi

}

function getSkillMachine(){
 skill="$1"
 machines="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
 if [ "$machines" ]; then
  echo -e "\nLas maquinas con skill \"$skill\" son:\n"
  cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
 else
   echo -e "\nNo se han encontrado maquinas con la skill: \"$skill\""
 fi

}

#Indicadores
#declaramos un entero
declare -i parameter_counter=0
declare -i param_os=0
declare -i param_dif=0

while getopts "m:ui:y:d:o:s:h" arg; do 
  case $arg in 
      m) machine_name="$OPTARG"; let parameter_counter+=1;;
      u)let parameter_counter+=2;;
      i)ipAddress="$OPTARG"; let parameter_counter+=3;;
      y)machine_name="$OPTARG"; let parameter_counter+=4;;
      d)machineDif="$OPTARG";param_dif=1; let parameter_counter+=5;;
      o)so="$OPTARG";param_os=1; let parameter_counter+=6;;
      s)skill="$OPTARG";let parameter_counter+=7;;
      h);;


 esac #cerrar case
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machine_name
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIp $ipAddress
elif [ $parameter_counter -eq 4 ]; then
  getYoutubeLink $machine_name
elif [ $parameter_counter -eq 5 ]; then
  getDificult $machineDif
elif [ $parameter_counter -eq 6 ]; then
  getSo $so
elif [ $parameter_counter -eq 7 ]; then
  #Hace falta poner doble comilla por que si una skill es por ej "Active Directory" $1 solo pilla Active. De esta forma se tiene constancia de todo
  getSkillMachine "$skill"
elif [ $param_os -eq 1  ] && [ $param_dif -eq 1 ]; then
  getSoDifMachines $machineDif $so
else
  help_panel
fi
