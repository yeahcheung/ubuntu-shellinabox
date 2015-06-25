#!/bin/bash
set -e

if [ -z "$ROOT_PASSWORD" ]; then
	echo >&2 'error: set ROOT_PASSWORD please'
	exit 1
fi

# set root password and make root loginable
echo "root:$ROOT_PASSWORD" | chpasswd
# create user anton
useradd -d /home/anton -m anton -g root
echo "anton:$ROOT_PASSWORD" | chpasswd

# change shell in a box configure
sed -i 's/SHELLINABOX_DAEMON_START=1/SHELLINABOX_DAEMON_START=0/' /etc/default/shellinabox
sed -i 's/--no-beep/--no-beep  --disable-ssl/' /etc/default/shellinabox
sed -i 's/SHELLINABOX_PORT=4200/SHELLINABOX_PORT=80/' /etc/default/shellinabox

mkdir -p /var/run/sshd
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
echo "export VISIBLE=now" >> /etc/profile
exec "$@"

