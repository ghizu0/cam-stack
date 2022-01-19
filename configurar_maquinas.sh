#!/bin/bash

source /home/ubuntu/Grupo_1-ARSO-openrc.sh

if ! command -v docker-machine &> /dev/null
then
    echo "Instalando docker-machine"
    sudo curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
fi

read -p "¿Cual es el nombre de la red de tu proyecto en OpenStack? " red_proyecto
read -p "¿Cual es la IP privada de esta maquina dentro en openstack? " ip_privada
read -p "¿Cuantas MV quieres? " num

for i in $(seq 1 $num)
do
  docker-machine create -d openstack --openstack-flavor-name medium --openstack-image-name "Ubuntu 20" --openstack-domain-name default --openstack-net-name $red_proyecto --openstack-floatingip-pool ext-net --openstack-ssh-user ubuntu --openstack-sec-groups cam-stack --openstack-keypair-name cam-stack --openstack-private-key-file /home/ubuntu/.ssh/cam-stack.pem nodo$i
done

for i in $(seq 1 $num)
do
  echo "Instalando plugin vieux/sshfs en el nodo$i"
  docker-machine ssh nodo$i "sudo docker plugin install --grant-all-permissions vieux/sshfs"
  echo "Creando el volumen de docker en el nodo $i"
  docker-machine ssh nodo$i "sudo docker volume create --driver vieux/sshfs -o sshcmd=ubuntu@$ip_privada:/home/ubuntu/volumen -o allow_other -o password=ubuntu volumen-web"
done

echo "Instalando docker-compose en el nodo 1"
docker-machine ssh nodo1 "sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64\" -o /usr/local/bin/docker-compose"
docker-machine ssh nodo1 "sudo chmod +x /usr/local/bin/docker-compose"
