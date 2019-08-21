# stronggate

A prxoy gate docker that provide squid http proxy & v2ray Server through a ikev2 vpn connection powered by strongswan.

By emericlee@gmail.com


## Quick EXAMPLE

### Example A.Run image manually and enter command shell

    docker run -it --rm --name vpnpure --privileged --cap-add ALL -v /lib/modules:/lib/modules  emericlee/stronggate sh

### Example B.Run image manually with full service
Modify the following command line as needed and run it.  `abspath-to-stronggate-config-files` is the directory for aggregation of config files , see `config files` .  

    docker run -dt \
        --restart unless-stopped \
        --name vpnpure \
        --privileged \
        --cap-add ALL \
        -v /lib/modules:/lib/modules \
        -p 20005:3128 \
        -p 10005:10005 \
        -v /abspath-to-stronggate-config-files:/etc/stronggate \
        emericlee/stronggate

### Example C Run image by docker-compose
Create a compose file like below and up it.

    #example:docker-compose for stronggate
    
    version: '3'
    services:
      vpnname:
        image: emericlee\stronggate
        hostname: vpnname
        container_name: vpnname
        volumes:
          - /lib/modules:/lib/modules
          - ./config:/etc/stronggate        #config is the directory for aggregation of config files.  see `config files`
        privileged: true
        cap_add:
          - ALL
        restart: always
        ports:
          - "20005:3128"   #squid http proxy
          - "20006:1080"   #v2ray Server
        #entrypoint: /entrypoint.sh         #can overwrite by you own entry script


## Reference

### Ports
The follow port should publish as needed.

    ports:
    - "xxxx:3128"   #http proxy(squid http)
    - "xxxx:1080"   #v2ray Server

### Config files
The follow files are config files for strongswan & squid & shadowsocks. They was aggregated at /etc/stronggate in container and map(link) to the location where each service will load by default . 
Each profile can be edited according to the corresponding documentation.You can modify them in container directly or overwrite them by seting up volume map from host.

    [aggregation location]       <== ln ==>     [actul location]
    /etc/stronggate/ipsec.conf                  /etc/ipsec.conf
    /etc/stronggate/ipsec.secrets               /etc/ipsec.secrets
    /etc/stronggate/cacerts/*                    /etc/ipsec.d/cacerts/*
    /etc/stronggate/squid.conf                  /etc/squid/squid.conf
    /etc/stronggate/v2ray.json                  /etc/v2ray/config.json
