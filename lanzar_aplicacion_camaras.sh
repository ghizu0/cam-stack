#!/bin/bash

read -p "Introduce c (muestra imagenes), p (muestra poses) o f (toma imagenes de fondo): " Opcion
read -p "¿Cuantas horas va a estar en modo c o p? " Tiempo



if [[ $Tiempo =~ ^[\-0-9]+$ ]] && (( Tiempo > 0)); then
  echo ""
else
  echo "Las horas tienen que ser un número mayor que cero"
  exit
fi

if [ $Opcion = "c" ] || [ $Opcion = "p" ] || [ $Opcion = "f" ]
then
  echo ""
else
  echo "La opción tiene que ser c, p, o f"
  exit
fi

docker-machine ssh nodo1 "/home/ubuntu/cam-app/start_stack.sh $Tiempo $Opcion"

echo "El stack se esta iniciando, accede a el por la IP publica del nodo1"
