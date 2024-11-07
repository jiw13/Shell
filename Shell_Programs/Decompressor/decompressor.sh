#!/bin/bash

function ctrl_c
{ echo -e "\n[!] Saliendo...\n\n"
  exit 1
}

trap ctrl_c INT

filename="data.gz"
f_sig="$(7z l data.gz | tail -n 3 | head -n 1 |  awk 'NF{print $NF}')"

7z x $filename &>/dev/null

while [ $f_sig ];do
 echo -e "\n[+] Nuevo archivo descomprimido: $f_sig "
 7z x $f_sig &>/dev/null
 f_sig="$(7z l $f_sig 2>/dev/null | tail -n 3 | head -n 1 |  awk 'NF{print $NF}')"

done
exit 0
