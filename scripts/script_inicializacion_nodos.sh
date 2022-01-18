#!/bin/sh
/bin/echo "Actualizar repositorios"
sudo /usr/bin/apt -y update
sudo /usr/bin/apt -y upgrade
/bin/echo "Cambiar password"
/bin/echo 'ubuntu:ubuntu' | sudo chpasswd
/bin/echo "Modificar sshd_config"
sudo /bin/sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo /bin/systemctl restart ssh
