#!/bin/sh
#enterpoint for stronggate

##########
#A gate docker provide http proxy & socket proxy & shadowsocks with connect to a ikev2 vpn.  
##########


echo '
----------------------------
A gate docker provide http proxy & socket proxy & shadowsocks with connect to a ikev2 vpn.
	As default the ipsec & squid & v2ray will start with config at default location   
	<Detail see readme.md>

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

    #Start v2ray config /etc/v2ray/config.json
    v2ray

    #Call shell
    sh 

else

    echo ">>> Run user command"

    exec "$@"

fi
