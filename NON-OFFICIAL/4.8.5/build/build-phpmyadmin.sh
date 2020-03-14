#!/bin/sh

# See gearboxworks/gearbox-base for details.
test -f /build/include-me.sh && . /build/include-me.sh

c_ok "Started."

BUILDDIR="/build"


if [ ! -d ${BUILDDIR} ]
then
	c_err "${BUILDDIR} doesn't exist."
	exit 1
fi


COMPILEDIR="${BUILDDIR}/compile"
OUTPUTDIR="${BUILDDIR}/output"
if [ ! -d ${COMPILEDIR} ]
then
	mkdir -p ${COMPILEDIR}
fi


apk add --no-cache nginx supervisor; checkExit

APKS="bzip2-dev freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libxpm-dev"
apk add --no-cache --virtual .build-deps $APKS; checkExit

# docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-webp-dir=/usr --with-png-dir=/usr --with-xpm-dir=/usr; checkExit
# docker-php-ext-install bz2 gd mysqli opcache zip; checkExit

runDeps="$( scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' )"
apk add --virtual .phpmyadmin-phpexts-rundeps $runDeps; checkExit
apk del .build-deps; checkExit

chmod u+rwx /usr/local/bin/run.sh

# Download tarball, verify it using gpg and extract
cd ${COMPILEDIR}
wget --no-check-certificate -Y off -O phpMyAdmin.tar.gz ${GEARBOX_CONTAINER_URL}; checkExit
tar xzf phpMyAdmin.tar.gz; checkExit
rm -f phpMyAdmin.tar.gz phpMyAdmin.tar.gz.asc; checkExit
mv phpMyAdmin-$VERSION-all-languages /www; checkExit
rm -rf /www/setup/ /www/examples/ /www/test/ /www/po/ /www/composer.json /www/RELEASE-DATE-$VERSION; checkExit
# mv /www /var; checkExit
sed -i "s@define('CONFIG_DIR'.*@define('CONFIG_DIR', '/etc/phpmyadmin/');@" /www/libraries/vendor_config.php; checkExit
chown -R root:nobody /www; checkExit
find /www -type d -exec chmod 750 {} \; ; checkExit
find /www -type f -exec chmod 640 {} \; ; checkExit

# Add directory for sessions to allow session persistence
mkdir /sessions && mkdir -p /www/tmp && chmod -R 777 /www/tmp


c_ok "Finished."
