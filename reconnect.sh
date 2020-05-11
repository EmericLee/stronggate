#!/bin/sh

cat <<EOT
----------------------------------------------
-          Connection helper sctipt          -
----------------------------------------------

 * This script only working with default config.

-------------------- 1 -----------------------

 Auto Ping vpn address list

 Ping all server int the file config/vpn_address_list.
 You can select the  best server according result and 
 modify the config file: config/ipsec.conf.

 * fping can be install by 'apt install fping"

 run.......
 fping -c 10 -q -a -f config/vpn_address_list
 ............................................

EOT

fping -c 10 -q -a -f config/vpn_address_list

cat <<EOT


-------------------- 2 -----------------------

  Try to up (or reup) the vpn connection

  You can run some command in the container:
  docer exec -it stronggate *****
  docer exec -it stronggate ipsec status

  run.....
  docer exec -it stronggate ipsec up pure
  .......................................

EOT


docker exec -it stronggate ipsec up pure


