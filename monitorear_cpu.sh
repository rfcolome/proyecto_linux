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
#


#### VALIDACIONES ####

if ! command -v cat 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando cat no se encontro" 1>&2
  exit 1
fi

if ! command -v grep 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando grep no se encontro" 1>&2
  exit 1
fi

if ! command -v wc 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando wc no se encontro" 1>&2
  exit 1
fi

if ! command -v getopts 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando getopts no se encontro" 1>&2
  exit 1
fi

if ! command -v echo 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando echo no se encontro" 1>&2
  exit 1
fi

if ! command -v while 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando while no se encontro" 1>&2
  exit 1
fi

if ! command -v ps 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando ps no se encontro" 1>&2
  exit 1
fi

if ! command -v tail 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando tail no se encontro" 1>&2
  exit 1
fi

if ! command -v gawk 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando gawk no se encontro" 1>&2
  exit 1
fi

if ! command -v sort 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando sort no se encontro" 1>&2
  exit 1
fi

if ! command -v head 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando head no se encontro" 1>&2
  exit 1
fi

if ! command -v sleep 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando sleep no se encontro" 1>&2
  exit 1
fi

if ! command -v touch 2>/dev/null 1>/dev/null; then
  echo "ERROR: el comando touch no se encontro" 1>&2
  exit 1
fi

# validando la existencia el archivo de configuracion

if [ -a /etc/monitorear_cpu.conf ]; then
  if [ ! -r /etc/monitorear_cpu.conf ]; then
    echo "ERROR: el archivo /etc/monitorear_cpu.conf existe pero no se puede leer" 1>&2
    logger "ERROR: monitorear_cpu - el archivo /etc/monitorear_cpu.conf existe pero no se puede leer"
    exit 1
  fi
else
  logger "el archivo /etc/monitorear_cpu.conf no existe; creandolo"
  touch /etc/monitorear_cpu.conf
  if [ $? -ne 0 ]; then
    echo "ERROR: el archivo /etc/monitorear_cpu.conf no se pudo crear" 1>&2
    logger "ERROR: monitorear_cpu - el archivo /etc/monitorear_cpu.conf no se pudo crear"
    exit 1    
  fi
  echo "SLEEP=1" > /etc/monitorear_cpu.conf
  echo "ITER=10" >> /etc/monitorear_cpu.conf
  echo "PROCS=0" >> /etc/monitorear_cpu.conf
fi

#### FIN VALIDACIONES ####


COUNTER=0
NUM_ITERACIONES=10
SECS_SLEEP=1
NUM_PROCESADORES=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
PROCESOS_A_MOSTRAR=""


#### LECTURA DE ARCHIVO ####

ARCHIVO=$(cat /etc/monitorear_cpu.conf | grep -Eo '^.+$')
LINEAS_VALIDAS=$(echo "$ARCHIVO" | grep -Eo '^[[:space:]]*(#.*|SLEEP[[:space:]]*=[[:space:]]*[0-9]+|ITER[[:space:]]*=[[:space:]]*[0-9]+|PROCS[[:space:]]*=[[:space:]]*[0-9]+|[[:space:]]*)[[:space:]]*$')

if [ "$ARCHIVO" != "$LINEAS_VALIDAS" ]; then
  LINEAS_INVALIDAS=$( (echo "$ARCHIVO"; echo "$LINEAS_VALIDAS") | sort | uniq --unique)
  echo "ERROR (/etc/monitorear_cpu.conf): error en las siguientes lineas:" 1>&2
  echo "$LINEAS_INVALIDAS" 1>&2
  logger "ERROR: monitorear_cpu - se detectaron errores en el archivo /etc/monitorear_cpu.conf"
  exit 1;
fi

NUM_ITERACIONES=$(echo "$ARCHIVO" | grep -E '^[[:space:]]*ITER' | grep -Eo '[0-9]+' | tail -n 1)
SECS_SLEEP=$(echo "$ARCHIVO" | grep -E '^[[:space:]]*SLEEP' | grep -Eo '[0-9]+' | tail -n 1)
PROCESOS_A_MOSTRAR=$(echo "$ARCHIVO" | grep -E '^[[:space:]]*PROCS' | grep -Eo '[0-9]+' | tail -n 1)

if [ -z "$NUM_ITERACIONES" ]; then
  NUM_ITERACIONES=10
fi

if [ -z "$SECS_SLEEP" ]; then
  SECS_SLEEP=1
fi


#### FIN LECTURA DE ARCHIVO ####



USUARIO=""


# las variables son utilizadas despues para decidir la manera como se va a procesar 
# la salida de ps
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
          echo "monitorear_cpu"
          echo "  Monitorear el uso de CPU durante un lapso de tiempo determinado"
          echo ""
          echo ""
          echo "uso: monitorear_cpu.sh [OPCIONES]"
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
GAWK_SUM='
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
GAWK_FILTER_USER='
{
  if ($1 == "'"$USUARIO"'") {
    print
  }
}'

# repetimos el numero de iteraciones que el usuario (o el archivo de configuracion) indico
while [ $COUNTER -lt $NUM_ITERACIONES ]; do

  # $1 es el usuario, $3 es CPU%, y $11 es el comando
  PS_OUTPUT=$(ps aux | 
                 tail --lines=+2 | 
                 gawk --field-separator=' ' '{ print $1 " " $3 " " $11 }' | 
                 sort --reverse --field-separator=' ' --numeric-sort --key=2)
  
  # si el usuario nos pidio que filtremos por usuario, usamos el script de GAWK para eliminar
  # las lineas de procesos de otros usuarios
  if [ -n "$USUARIO" ]; then
    PS_OUTPUT=$(echo "$PS_OUTPUT" | gawk "$GAWK_FILTER_USER")
  fi

  # sumamos todos los porcentajes de CPU para obtener el uso total de CPU (dividido entre el numero de procesadores)
  SUMA_CPU=$(echo "$PS_OUTPUT" | gawk "$GAWK_SUM")
  # este comando nos muestra el monitoreo del CPU en el standar output
  echo "CPU%: $SUMA_CPU"
   # este comando redirecciona el standar output a /var/log/monitoreo_cpu
  echo "CPU%: $SUMA_CPU" >> /var/log/monitoreo_cpu

  # si el usuario nos pidio que mostraramos los primeros N procesos, los mostramos aca con head
  if [ -n "$PROCESOS_A_MOSTRAR" ] && [ "$PROCESOS_A_MOSTRAR" -ne 0 ]; then
    echo ""
    echo "USR CPU% CMD"
    PS=$(echo "$PS_OUTPUT" | head -n "$PROCESOS_A_MOSTRAR")
    echo "$PS"
    # redirecciona $PS al archivo /var/log/monitoreo_cpu 
    echo "$PS" >> /var/log/monitoreo_cpu
    echo ""
    echo ""
  fi

  COUNTER=$(( $COUNTER + 1 ))

  # esperamos el numero de segundos indicados por el usuario (o el archivo de configuracion
  sleep $SECS_SLEEP
done

exit 0
