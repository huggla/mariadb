FROM alpine:edge

RUN apk add --no-cache --virtual .build-dependencies alpine-sdk subversion \
 && /usr/sbin/addgroup root abuild
 
RUN mkdir -p /var/cache/distfiles /mariadb-apks \
 && abuild-keygen -a -i -n \
 && svn export https://github.com/alpinelinux/aports.git/trunk/main/mariadb \
 && cd mariadb \
 && rm -f ppc-remove-glibc-dep.patch \
 && sed -i -e 's/pkgver=.*/pkgver=10.3.7/g' APKBUILD \
 && sed -i -e '/ppc-remove-glibc-dep.patch/d' APKBUILD \
 && abuild -F checksum \
 && apk update \
 && abuild -r -F -p /mariadb-apks \
 && abuild clean \
 && cd / \
 && rm -rf /mariadb \
 && apk del .build-dependencies
