FROM alpine:latest
MAINTAINER Yan Grunenberger <yan@grunenberger.net>
RUN apk add --no-cache qemu-system-x86_64 libvirt qemu-img bridge iproute2 dnsmasq iptables

WORKDIR /root
COPY vyos.img /root/vyos.img
COPY startvm.sh /root/startvm.sh
ENTRYPOINT ["/bin/sh","/root/startvm.sh"]
