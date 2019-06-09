#!/bin/sh
#enterpoint for stronggate

##########
#A gate docker provide http proxy & socket proxy & shadowsocks with connect to a ikev2 vpn.  
##########


echo '
----------------------------
A gate docker provide http proxy & socket proxy & shadowsocks with connect to a ikev2 vpn.

Quick start EXAMPLE

    docker run -it --rm --name vpnpure --privileged --cap-add ALL -v /lib/modules:/lib/modules stronggate sh

    or

    docker run -it --rm --name vpnpure --privileged --cap-add ALL \
	   -v /lib/modules:/lib/modules \
	   #fllow lines is optional
           -v /abspath-to-stronggate-config-files/:/etc/stronggate \
	   -p 20005:3128 \
	   -p 20006:1080 \
	   -p 20001:8388 \
	   stronggate

The follow port should publish as needed.
    ports:
    - "xxxx:3128"   #http proxy(squid http)
    - "xxxx:8388"   #Shadowsocks Server
    - "xxxx:1080"   #socket proxy(Shadowscoks client to Local)

The follow files are config files for vpn & squid & shadowsocks. 
the directions (/etc/stronggate/) is aggregation of this config. It can easy modify(overwrite) by 'volume in'.
    [aggregation location]       <== ln ==>     [actul location]
    /etc/stronggate/ipsec.conf   		/etc/ipsec.conf 
    /etc/stronggate/ipsec.secrets 		/etc/ipsec.secrets 
    /etc/stronggate/cacerts                     /etc/ipsec.d/cacerts
    /etc/stronggate/squid.conf                  /etc/squid/squid.conf
    /etc/stronggate/shadowsocks.config.json     /etc/shadowsocks-libev/config.json

----------------------------
'

#make resolv.conf standlonge,for docker host
umount /etc/resolv.conf
echo 'nameserver 8.8.8.8
nameserver 8.8.4.4
options ndots:0' > /etc/resolv.conf


if [ $# == 0 ]
then

    #There isn't any cmd(params) to run. doing default load
    echo ">>> Start default actions::"
    echo ">>> load vpn & squid & shadowsocks with default config files. The files can be modify by 'volume in'. "
    
    #Start ipsec (strongswan ikev2)
    ipsec start --debug

    #Start Squid prox
    #mkdir /var/spool/squid
    #chown squid:squid /var/spool/squid
    squid -z --foreground
    squid -d 1

    #Start Shadowsocks
    #ss-server -s 0.0.0.0 -p 10006 -k "$(hostname)" -m aes-256-gcm -t 300 --fast-open -d "8.8.8.8,8.8.4.4" -u 
    ss-local -c /etc/shadowsocks-libev/config.json -f sslocal
    ss-server -c /etc/shadowsocks-libev/config.json -f ssserver

    #Call shell
    sh 

else

    echo ">>> Run user command"

    exec "$@"

fi
