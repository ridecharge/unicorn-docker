#!/bin/bash
echo $HOSTNAME
sed -i "s:SERVICE_NAME:$HOSTNAME:g" /etc/confd/conf.d/unicorn.toml

/usr/bin/confd -onetime -backend consul -node consul:8500 \
	-debug -verbose -config-file /etc/confd/conf.d/unicorn.toml

exec bundle exec unicorn -c /etc/unicorn/unicorn.rb
