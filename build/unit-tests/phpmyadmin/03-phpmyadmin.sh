#!/bin/bash
# Created on 2020-03-11T15:12:51+1100, using template:01-base.sh.tmpl and json:2.2.34.json

p_info "phpmyadmin" "Release test started."

for RETRY in 1 2 3 4
do
	WGET="$(wget -qO/dev/null http://localhost/ 2>&1)"
	if [ "${WGET}" == "" ]
	then
		c_ok "phpmyadmin HTTP running."
		OK="1"
		break
	else
		c_warn "phpmyadmin HTTP NOT running. (RETRY:${RETRY})"
		OK="0"
	fi

	sleep 2
done

if [ "${OK}" == "0" ]
then
	c_err "phpmyadmin HTTP NOT running."
fi


#WGET="$(wget -qO/dev/null https://localhost/ 2>&1)"
#if [ "${WGET}" == "" ]
#then
#	c_ok "phpmyadmin HTTP running."
#else
#	c_err "phpmyadmin HTTP NOT running."
#fi

p_info "phpmyadmin" "Release test finished."

