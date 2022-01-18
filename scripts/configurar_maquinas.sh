#!/bin/bash

source /home/ubuntu/Grupo_1-ARSO-openrc.sh

read -p "¿Cuantas MV quieres? " num

for i in $(seq 1 $num)
do
  docker-machine create -d openstack --openstack-flavor-name medium --openstack-image-name "Ubuntu 20" --openstack-domain-name default --openstack-net-name grupo1-net --openstack-floatingip-pool ext-net --openstack-ssh-user ubuntu --openstack-sec-groups cam-stack --openstack-keypair-name cam-stack --openstack-private-key-file /home/ubuntu/.ssh/cam-stack.pem --openstack-user-data-file /home/ubuntu/cam-stack/scripts/script_inicializacion_nodos.sh nodo$i
done

for i in $(seq 1 $num)
do
  # Asegurarse de que docker esta instalado, ya que docker-machine falla a veces
  sudo docker-machine ssh nodes$i "sudo apt install -y docker.io"
  sudo docker-machine ssh nodo$i "sudo docker plugin install --grant-all-permissions vieux/sshfs"
  sudo docker-machine ssh nodo$i "sudo docker volume create --driver vieux/sshfs -o sshcmd=ubuntu@:/home/ubuntu/volumen -o allow_other -o password=ubuntu volumen-web"
done

# Asegurarse de que docker-compose esta instalado, ya que docker-machine falla a veces
sudo docker-machine ssh nodo1 "sudo curl -L \"https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose"
sudo docker-machine ssh nodo1 "sudo chmod +x /usr/local/bin/docker-compose"
