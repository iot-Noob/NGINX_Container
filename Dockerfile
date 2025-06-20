FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    nginx \
    openssl \
    curl wget \
    iputils-ping net-tools iproute2 traceroute dnsutils \
    htop screen \
    lsof\
    nano vim \
    && apt clean

EXPOSE 80 443 8080 3000 4000

CMD ["nginx", "-g", "daemon off;"]
