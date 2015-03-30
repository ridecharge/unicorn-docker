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

RUN gem install bundler
RUN mkdir /opt/app
ENV RAILS_ENV production

WORKDIR /opt/app
ONBUILD ADD . /opt/app
ONBUILD RUN bundle install --without development test

EXPOSE 8080
ENTRYPOINT ["bundle", "exec", "unicorn", "-c", "./config/unicorn.rb"]