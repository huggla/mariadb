FROM alpine:edge

RUN apk --no-cache add alpine-sdk subversion \
 && mkdir -p /var/cache/distfiles \
 && /usr/sbin/addgroup root abuild \
 && abuild-keygen -a -i -n \
 && svn export https://github.com/alpinelinux/aports.git/trunk/main/mariadb
 
RUN cd mariadb \
 && rm -f ppc-remove-glibc-dep.patch \
 && sed -i -e 's/pkgver=.*/pkgver=10.3.7/g' APKBUILD \
 && sed -i -e '/ppc-remove-glibc-dep.patch/d' APKBUILD \
 && abuild -F checksum \
 && apk update \
 && abuild -r -F
