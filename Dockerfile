FROM registry.gocurb.internal:80/confd

RUN apt-get install -y software-properties-common  
RUN apt-add-repository ppa:brightbox/ruby-ng 
RUN apt-get update
RUN apt-get install -y \
		ruby2.2 \
		ruby2.2-dev \
		unicorn \
		build-essential \
		git \
		git-core \
		libv8-dev \
	    zlib1g-dev \
	    libssl-dev \
	    libreadline-dev \
	    libyaml-dev \
	    libxml2-dev \
	    libxslt1-dev \
	    curl

RUN mkdir /etc/unicorn
COPY unicorn-wrapper.sh /tmp/unicorn-wrapper.sh
RUN chmod 0500 /tmp/unicorn-wrapper.sh

RUN gem install bundler
ONBUILD RUN mkdir -p /opt/app
ONBUILD WORKDIR /opt/app
ONBUILD COPY . /opt/app
ONBUILD ENV RAILS_ENV test
ONBUILD RUN bundle install
ONBUILD RUN bundle exec bundle-audit update
ONBUILD RUN bundle exec bundle-audit
ONBUILD RUN bundle exec rubocop
ONBUILD RUN bundle exec brakeman -z -w2

EXPOSE 8080
ENTRYPOINT ["/tmp/unicorn-wrapper.sh"]
