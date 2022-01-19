#!/bin/bash

source /home/ubuntu/Grupo_1-ARSO-openrc.sh

if ! command -v docker &> /dev/null
then
    echo "Instalando docker"
    sudo apt install -y docker.io
fi


if ! command -v docker-machine &> /dev/null
then
    echo "Instalando docker-machine"
    sudo curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
fi

read -p "¿Cual es el nombre de la red de tu proyecto en OpenStack? " red
read -p "¿Cuantas MV quieres? " num

for i in $(seq 1 $num)
do
  docker-machine create -d openstack --openstack-flavor-name medium --openstack-image-name "Ubuntu 20" --openstack-domain-name default --openstack-net-name $red --openstack-floatingip-pool ext-net --openstack-ssh-user ubuntu --openstack-sec-groups cam-stack --openstack-keypair-name cam-stack --openstack-private-key-file /home/ubuntu/.ssh/cam-stack.pem --openstack-user-data-file /home/ubuntu/script_inicializacion_nodos.sh nodo$i
done

for i in $(seq 1 $num)
do
  sudo docker-machine ssh nodo$i "sudo docker plugin install --grant-all-permissions vieux/sshfs"
  sudo docker-machine ssh nodo$i "sudo docker volume create --driver vieux/sshfs -o sshcmd=ubuntu@$(hostname -I):/home/ubuntu/volumen -o allow_other -o password=ubuntu volumen-web"
done
