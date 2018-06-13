FROM alpine:edge

RUN apk add --virtual .build-dependencies alpine-sdk subversion \
 && adduser -D -G abuild abuilder \
 && mkdir -p /var/cache/distfiles /mariadb-apks /abuild \
 && chgrp abuild /var/cache/distfiles /mariadb-apks /abuild \
 && chmod g+w /var/cache/distfiles /mariadb-apks /abuild
 
USER abuilder
 
RUN cd /abuild \
 && abuild-keygen -a -i -n \
 && svn export https://github.com/alpinelinux/aports.git/trunk/main/mariadb \
 && cd mariadb \
 && rm -f ppc-remove-glibc-dep.patch \
 && sed -i -e 's/pkgver=.*/pkgver=10.3.7/g' APKBUILD \
 && sed -i -e '/ppc-remove-glibc-dep.patch/d' APKBUILD \
 && sed -i -e '/cnf/d' APKBUILD \
 && abuild checksum \
 && abuild -r -p /mariadb-apks \
 && abuild clean
 
USER root
WORKDIR /mariadb-apks

RUN apk del .build-dependencies \
 && chown root:root /mariadb-apks
# && deluser --remove-all-files abuilder \
# && rm -rf /abuild /var/cache/distfiles /var/cache/apk/*
