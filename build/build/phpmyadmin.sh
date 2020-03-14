#!/bin/bash
# Created on 2020-03-14T10:45:22+1100, using template:phpmyadmin.sh.tmpl and json:gearbox.json

test -f /etc/gearbox/bin/colors.sh && . /etc/gearbox/bin/colors.sh

c_ok "Started."

c_ok "Installing packages."
if [ -f /etc/gearbox/build/phpmyadmin.apks ]
then
	APKS="$(cat /etc/gearbox/build/phpmyadmin.apks)"
	apk update && apk add --no-cache ${APKS}; checkExit
fi

if [ -f /etc/gearbox/build/phpmyadmin.env ]
then
	. /etc/gearbox/build/phpmyadmin.env
fi

if [ ! -d /usr/local/bin ]
then
	mkdir -p /usr/local/bin; checkExit
fi

c_ok "Finished."
