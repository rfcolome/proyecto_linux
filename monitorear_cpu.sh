#!/bin/bash
#
# Proyecto de Linux
# Monitorear el uso de CPU durante un lapso de tiempo determinado
#
# Ricardo Francisco Colome Altamirano 00054809
# Diego Alberto Arana Vaquerano       00017912
#
#
#  argumentos:
#
#    - -u usuario: indica que se van a tomar unicamente los procesos del usuario dado
#    - -n numero : indica que se mostraran los primeros n procesos, ordenados por uso de CPU
#    - -i numero : indica el numero de iteraciones del comando (default: 10)
#    - -s numero : "sleep". Indica cada cuantos segundos va a iterar y revisar el uso de CPU (default: 1)
#    - -h        : "help". muestra la ayuda

if ! command -v cat 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando cat no se encontro"
  exit 1
fi

if ! command -v grep 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando grep no se encontro"
  exit 1
fi

if ! command -v wc 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando wc no se encontro"
  exit 1
fi

if ! command -v getopts 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando getopts no se encontro"
  exit 1
fi

if ! command -v echo 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando echo no se encontro"
  exit 1
fi

if ! command -v while 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando while no se encontro"
  exit 1
fi

if ! command -v ps 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando ps no se encontro"
  exit 1
fi

if ! command -v tail 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando tail no se encontro"
  exit 1
fi

if ! command -v awk 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando awk no se encontro"
  exit 1
fi

if ! command -v sort 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando sort no se encontro"
  exit 1
fi

if ! command -v head 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando head no se encontro"
  exit 1
fi

if ! command -v sleep 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando sleep no se encontro"
  exit 1
fi


COUNTER=0
NUM_ITERACIONES=10
SECS_SLEEP=1
NUM_PROCESADORES=$(cat /proc/cpuinfo | grep 'processor' | wc -l)

USUARIO=""
PROCESOS_A_MOSTRAR=""



while getopts "u:xn:i:s:h" opt; do
  case $opt in
       u) USUARIO="$OPTARG"
          ;;
       n) PROCESOS_A_MOSTRAR="$OPTARG"
          ;;
       i) NUM_ITERACIONES="$OPTARG"
          ;;
       s) SECS_SLEEP="$OPTARG"
          ;;
       h) echo ""
          echo "monitorear_cpu.sh [OPCIONES]"
          echo ""
          echo "donde OPCIONES son:"
          echo ""
          echo "-u USUARIO"
          echo "  al usar esta opcion, se toman en cuenta unicamente los procesos del usuario dado"
          echo ""
          echo "-n NUMERO"
          echo "  al usar esta opcion, se muestran los n procesos que mas uso hacen de CPU"
          echo ""
          echo "-i NUMERO"
          echo "  indica el numero de iteraciones del comando (default: 10)"
          echo ""
          echo "-s NUMERO"
          echo "  'sleep'. Indica cada cuantos segundos va a iterar el script y revisar el uso de CPU (default: 1)"
          echo ""
          echo "-h"
          echo "  muestra este mensaje de ayuda"
          echo ""
          exit 0
          ;;
  esac
done





# script que suma todos los porcentajes de CPU
# y muestra el resultado
AWK_SUM='
BEGIN {
  usage = 0;
}

{
  usage = usage + $2;
}

END {
  print usage/'$NUM_PROCESADORES'
}'

# script que filtra de acuerdo al usuario ingresado
AWK_FILTER_USER='
{
  if ($1 == "'"$USUARIO"'") {
    print
  }
}
'

# este script extrae el numero del campo id (idle) de la linea de top que contiene 
# las estadisticas del CPU
SED_SCRIPT_IDLE='
/Cpu/ {
  s/.* ([0-9.]+) id.*/\1/g;
  p
}'

while [ $COUNTER -lt $NUM_ITERACIONES ]; do

  # $1 es el usuario, $3 es CPU%, y $11 es comando
  PS_OUTPUT=$(ps aux | 
                 tail --lines=+2 | 
                 awk --field-separator=' ' '{ print $1 " " $3 " " $11 }' | 
                 sort --reverse --field-separator=' ' --numeric-sort --key=2)
  
  if [ -n "$USUARIO" ]; then
    PS_OUTPUT=$(echo "$PS_OUTPUT" | awk "$AWK_FILTER_USER")
  fi

  SUMA_CPU=$(echo "$PS_OUTPUT" | awk "$AWK_SUM")

  echo "CPU%: $SUMA_CPU"

  if [ -n "$PROCESOS_A_MOSTRAR" ]; then
    echo ""
    echo "USR CPU% CMD"
    PS=$(echo "$PS_OUTPUT" | head -n "$PROCESOS_A_MOSTRAR")
    echo "$PS"
  fi



  COUNTER=$(( $COUNTER + 1 ))
  sleep $SECS_SLEEP
done

exit 0
