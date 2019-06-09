#
# Dockerfile for strongroute.
# Include Strongswan (As client to a vpn server) & squid(proxy for http) & shadowsocks(server for shadowsocks)
#

FROM shadowsocks/shadowsocks-libev 
## or alpine
MAINTAINER emeric <kometo@gmail.com>

USER root

RUN set -xe \
    && apk add --no-cache strongswan squid

EXPOSE  8388 3128 1080

RUN mkdir /var/spool/squid \
 && chown squid:squid /var/spool/squid \
 && mkdir -p /etc/shadowsocks-libev/ \
 && mkdir -p /var/lib/strongswan/ \
 && touch /var/lib/strongswan/ipsec.conf.inc

COPY config /etc/stronggate
RUN ln -sf /etc/stronggate/ipsec.conf /etc/ipsec.conf \
 && ln -sf /etc/stronggate/ipsec.secrets /etc/ipsec.secrets \
 && ln -sf /etc/stronggate/cacerts/* /etc/ipsec.d/cacerts \
 && ln -sf /etc/stronggate/squid.conf /etc/squid/squid.conf \
 && ln -sf /etc/stronggate/shadowsocks.config.json /etc/shadowsocks-libev/config.json 

COPY entrypoint.sh /
COPY README.md /

ENTRYPOINT ["/entrypoint.sh"]
CMD []

