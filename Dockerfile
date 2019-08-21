#
# Dockerfile for strongroute.
# Include Strongswan (As client to a vpn server) & squid(proxy for http) & shadowsocks(server for shadowsocks)
#

FROM v2ray/official  
## or alpine
MAINTAINER emeric <kometo@gmail.com>

USER root

RUN set -xe \
    && apk add --no-cache strongswan squid

RUN mkdir /var/spool/squid \
 && chown squid:squid /var/spool/squid \
 && mkdir -p /var/lib/strongswan/ \
 && touch /var/lib/strongswan/ipsec.conf.inc

COPY config /etc/stronggate
RUN ln -sf /etc/stronggate/ipsec.conf /etc/ipsec.conf \
 && ln -sf /etc/stronggate/ipsec.secrets /etc/ipsec.secrets \
 && ln -sf /etc/stronggate/cacerts/* /etc/ipsec.d/cacerts \
 && ln -sf /etc/stronggate/squid.conf /etc/squid/squid.conf \
 && ln -sf /etc/stronggate/v2ray.json /etc/v2ray/config.json

COPY entrypoint.sh /
COPY README.md /

ENTRYPOINT ["/entrypoint.sh"]
CMD []

