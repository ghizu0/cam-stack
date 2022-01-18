#!/bin/bash

source /home/ubuntu/Grupo_1-ARSO-openrc.sh

read -p "¿Cuantas MV quieres? " num

for i in $(seq 1 $num)
do
  docker-machine create -d openstack --openstack-flavor-name medium --openstack-image-name "Ubuntu 20" --openstack-domain-name default --openstack-net-name grupo1-net --openstack-floatingip-pool ext-net --openstack-ssh-user ubuntu --openstack-sec-groups cam-stack --openstack-keypair-name cam-stack --openstack-private-key-file /home/ubuntu/.ssh/cam-stack.pem --openstack-user-data-file /home/ubuntu/cam-stack/scripts/script_inicializacion_nodos.sh nodes$i
done

for i in $(seq 1 $num)
do
  #sudo docker-machine ssh nodes$i "sudo apt install -y docker.io"
  sudo docker-machine ssh nodes$i "sudo docker plugin install --grant-all-permissions vieux/sshfs"
  sudo docker-machine ssh nodes$i "sudo docker volume create --driver vieux/sshfs -o sshcmd=ubuntu@:/home/ubuntu/volumen -o allow_other -o password=ubuntu volumen-web"
done
