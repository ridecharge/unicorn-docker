FROM ubuntu:14.04

# Install ruby and unicorn
RUN apt-get update && \	
	apt-get -y upgrade && \
	apt-get install -y software-properties-common && \
	apt-add-repository ppa:brightbox/ruby-ng && \
	apt-get update && \
	apt-get install -y ruby2.2 ruby2.2-dev unicorn build-essential \
	git git-core \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev

# Install confd
ADD https://github.com/kelseyhightower/confd/releases/download/v0.7.1/confd-0.7.1-linux-amd64 /usr/bin/confd
RUN chmod 0500 /usr/bin/confd
RUN mkdir -p /etc/confd/conf.d
RUN mkdir -p /etc/confd/templates

# Unicorn and Confd config files
RUN mkdir /etc/unicorn
COPY unicorn.toml /etc/confd/conf.d/unicorn.toml
COPY unicorn.rb.tmpl /etc/confd/templates/unicorn.rb.tmpl
COPY unicorn-wrapper.sh /tmp/unicorn-wrapper.sh
RUN chmod 0500 /tmp/unicorn-wrapper.sh

# Setup app and unicorn
RUN gem install bundler
RUN mkdir /opt/app
ENV RAILS_ENV production

WORKDIR /opt/app
ONBUILD COPY . /opt/app
ONBUILD RUN bundle install --without development test

EXPOSE 8080
ENTRYPOINT ["/tmp/unicorn-wrapper.sh"]