#
# Dockerfile for chinadns
# Soha Jin https://sohaj.in
#

FROM debian:jessie
MAINTAINER Soha Jin <soha@lohu.info>

ENV CFD_URL https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.tgz
ENV CFD_FILE cloudflared.tar.gz
ENV CDL_URL https://github.com/felixonmars/dnsmasq-china-list/archive/master.tar.gz
ENV CDL_FILE chinalist.tar.gz

ENV CHINA_DNS_SERVER 114.114.115.115

# replace source for apt
#RUN sed -i -e "s/deb.debian.org/mirrors4.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list && sed -i -e "s/security.debian.org/mirrors4.tuna.tsinghua.edu.cn\\/debian-security/g" /etc/apt/sources.list
RUN apt-get update \
	&& apt-get install -y curl dnsmasq supervisor \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app
# CloudFlare DNS over HTTPS
RUN curl -SL ${CFD_URL} -o ${CFD_FILE} && tar zxvf ${CFD_FILE} && rm -rf ${CFD_FILE} && cp ./cloudflared /bin/
# get China Domain List
RUN mkdir chinalist && cd chinalist \
	&& curl -SL ${CDL_URL} -o ${CDL_FILE} && tar zxvf ${CDL_FILE} --strip 1 && rm -rf ${CDL_FILE} \
	&& sed -e "s/114.114.114.114/$CHINA_DNS_SERVER/g" accelerated-domains.china.conf > accelerated-domains.china.dnsmasq.conf \
	&& cp -v accelerated-domains.china.dnsmasq.conf /etc/dnsmasq.d/ \
	&& cd /

ADD ./services.conf /etc/supervisor/conf.d/

EXPOSE 53/tcp 53/udp

CMD supervisord -n -c /etc/supervisor/supervisord.conf
