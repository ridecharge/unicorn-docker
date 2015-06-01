#!/bin/bash
sed -i "s:SERVICE_NAME:$HOSTNAME:g" /etc/confd/conf.d/unicorn.toml

/usr/bin/confd -onetime -backend consul -node consul:8500 \
	-debug -verbose -config-file /etc/confd/conf.d/unicorn.toml
export RAILS_ENV=$(curl http://consul.gocurb.internal/v1/kv/cf/config/environment?raw)
exec bundle exec unicorn -c /etc/unicorn/unicorn.rb
