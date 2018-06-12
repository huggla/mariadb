FROM alpine:edge

RUN apk --no-cache add alpine-sdk subversion \
 && mkdir -p /var/cache/distfiles \
 && /usr/sbin/addgroup root abuild \
 && abuild-keygen -a -i -n \
 && svn export https://github.com/alpinelinux/aports.git/trunk/main/mariadb \
 && cd mariadb \
 && sed -i -e 's/pkgver=10.2.14/pkgver=10.3.7/g' APKBUILD \
 && abuild -r -F
