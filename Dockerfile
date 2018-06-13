FROM alpine:edge

RUN apk add --virtual .build-dependencies alpine-sdk subversion \
 && adduser -D -G abuild abuilder \
 && mkdir -p /var/cache/distfiles /abuild /mariadb-apk \
 && chgrp abuild /var/cache/distfiles /abuild \
 && chmod g+w /var/cache/distfiles /abuild
 
USER abuilder
 
RUN cd /abuild \
 && abuild-keygen -a -i -n \
 && svn export https://github.com/alpinelinux/aports.git/trunk/main/mariadb \
 && cd mariadb \
 && rm -f ppc-remove-glibc-dep.patch \
 && sed -i -e 's/pkgver=.*/pkgver=10.3.7/g' APKBUILD \
 && sed -i -e '/ppc-remove-glibc-dep\.patch/d' APKBUILD \
 && sed -i -e '/cnf/d' APKBUILD \
 && sed -i -e '/pkgdir"\/etc\/mysql/d' APKBUILD \
 && sed -i -e '/libmysqld\.so\./d' APKBUILD \
 && abuild checksum \
 && abuild -r \
 && abuild clean
 
USER root

RUN apk del .build-dependencies \
 && mv /home/abuilder/packages/abuild/x86_64/* /mariadb-apks/ \
 && deluser --remove-all-files abuilder \
 && rm -rf /abuild /var/cache/distfiles /var/cache/apk/*
