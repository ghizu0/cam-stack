#!/bin/bash

echo "source /home/ubuntu/Grupo_1-ARSO-openrc.sh"

ip_privada=$(hostname -I)
echo $ip_privada

if ! command -v docker &> /dev/null
then
    echo "Instalando docker"
    echo "sudo apt install -y docker.io"
fi


if ! command -v docker-machine &> /dev/null
then
    echo "Instalando docker-machine"
    echo "sudo curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine"
fi

echo "read -p \"¿Cuantas MV quieres?\" num"

for i in $(seq 1 $num)
do
  echo "docker-machine create -d openstack --openstack-flavor-name medium --openstack-image-name "Ubuntu 20" --openstack-domain-name default --openstack-net-name grupo1-net --openstack-floatingip-pool ext-net --openstack-ssh-user ubuntu --openstack-sec-groups cam-stack --openstack-keypair-name cam-stack --openstack-private-key-file /home/ubuntu/.ssh/cam-stack.pem --openstack-user-data-file /home/ubuntu/script_inicializacion_nodos.sh node$i"
done

for i in $(seq 1 $num)
do
  echo "sudo docker-machine ssh node$i \"sudo docker plugin install --grant-all-permissions vieux/sshfs\""
  echo "sudo docker-machine ssh node$i \"sudo docker volume create --driver vieux/sshfs -o sshcmd=ubuntu@$ip_privada:/home/ubuntu/volumen -o allow_other -o password=ubuntu volumen-web\""
done
