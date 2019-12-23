#!/bin/bash
chown redis:redis /var/lib/redis/dump.rdb
chmod 660 /var/lib/redis/dump.rdb
/etc/init.d/redis-server start
cd /root/xen-orchestra/packages/xo-server && yarn start 
