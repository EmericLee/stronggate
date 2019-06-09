
D_NAME='sroute'

docker rm --force $D_NAME


docker run -it \
      -v $(pwd)/ipsec.conf:/etc/ipsec.conf \
      -v $(pwd)/ipsec.secrets:/etc/ipsec.secrets \
      -v $(pwd)/cacerts:/etc/ipsec.d/cacerts \
      -v $(pwd)/config.json:/etc/shadowsocks-libev/config.json \
      -v $(pwd)/start.sh:/start.sh \
      -v /lib/modules:/lib/modules \
      --name $D_NAME \
      --hostname $D_NAME \
      --privileged \
      strongroute sh -c '/start.sh && sh'


#docker run -it \
#	-v $(pwd)/ipsec.conf:/etc/ipsec.conf \
#	-v $(pwd)/ipsec.secrets:/etc/ipsec.secrets \
#	-v $(pwd)/start.sh:/start.sh \
#	-v /etc/localtime:/etc/localtime \
#	-v /lib/modules:/lib/modules \
#	--privileged \
#     	--cap-add ALL \
#	--hostname $D_NAME \
#	--name $D_NAME \
#	--publish 10005:10005 \
#	--publish 10006:10006 \
#	--rm \
#     	strongroute bash -c '/start.sh && bash'
