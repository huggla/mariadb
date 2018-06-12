FROM alpine:edge

RUN apk --no-cache add alpine-sdk subversion \
 && mkdir -p /var/cache/distfiles \
 && /usr/sbin/addgroup root abuild \
 && svn export https://github.com/alpinelinux/aports.git/trunk/main/mariadb
