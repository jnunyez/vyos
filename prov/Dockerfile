FROM alpine:latest
MAINTAINER Jose Nu√ez <jonunyez@gmail.com>
RUN apk add --no-cache iptables ansible openssh sshpass

WORKDIR /root
COPY run.sh /root/run.sh
ENTRYPOINT ["/bin/sh","/root/run.sh"]
