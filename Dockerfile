FROM ubuntu:14.04

# Install ruby and unicorn
RUN apt-get update && \	
	apt-get -y upgrade && \
	apt-get install -y software-properties-common && \
	apt-add-repository ppa:brightbox/ruby-ng && \
	apt-get update && \
	apt-get install -y ruby2.2 unicorn build-essential

RUN gem install bundler
RUN mkdir /opt/app
ENV RAILS_ENV prod

WORKDIR /opt/app
ONBUILD ADD . /opt/app
ONBUILD RUN bundle install --without development test
ONBUILD RUN bundle exec rake assets:precompile
