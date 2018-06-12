FROM alpine:edge

RUN apk add --virtual .build-dependencies alpine-sdk subversion \
 && adduser builder \
 && /usr/sbin/addgroup builder abuild \
 && mkdir -p /var/cache/distfiles /mariadb-apks /mariadb \
 && chgrp abuild /var/cache/distfiles /mariadb-apks /mariadb \
 && chmod g+w /var/cache/distfiles /mariadb-apks /mariadb

USER builder
 
RUN abuild-keygen -a -i -n \
 && svn export https://github.com/alpinelinux/aports.git/trunk/main/mariadb \
 && cd mariadb \
 && rm -f ppc-remove-glibc-dep.patch \
 && sed -i -e 's/pkgver=.*/pkgver=10.3.7/g' APKBUILD \
 && sed -i -e '/ppc-remove-glibc-dep.patch/d' APKBUILD \
 && abuild checksum \
 && abuild -r -p /mariadb-apks \
 && abuild clean
 
USER root
WORKDIR /mariadb-apks

RUN apk del .build-dependencies
# && rm -rf /mariadb /var/cache/distfiles /var/cache/apk/*
