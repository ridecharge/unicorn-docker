FROM registry.gocurb.internal:80/confd

RUN apt-get install -y software-properties-common && \
	apt-add-repository ppa:brightbox/ruby-ng && \
	apt-get update && \
	apt-get install -y ruby2.2 ruby2.2-dev unicorn build-essential \
	git git-core libv8-dev \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev

RUN adduser --uid 2200 unicorn

RUN mkdir /etc/unicorn
RUN chown unicorn:unicorn /etc/unicorn
RUN chmod 0700 /etc/unicorn

RUN chown -R unicorn:unicorn /etc/confd
RUN chmod -R 0700 /etc/confd
RUN chown unicorn:unicorn /usr/bin/confd

COPY unicorn-wrapper.sh /tmp/unicorn-wrapper.sh
RUN chown unicorn:unicorn /tmp/unicorn-wrapper.sh
RUN chmod 0500 /tmp/unicorn-wrapper.sh

RUN gem install bundler
ONBUILD RUN mkdir -p /opt/app
ONBUILD WORKDIR /opt/app
ONBUILD COPY . /opt/app
ONBUILD ENV RAILS_ENV test
ONBUILD RUN bundle install --without development
ONBUILD RUN bundle exec bundle-audit update
ONBUILD RUN bundle exec bundle-audit
ONBUILD RUN bundle exec rubocop
ONBUILD RUN bundle exec brakeman -z -w2
ONBUILD RUN bundle exec rake rspec SPEC_OPTS="-f d -c"
ONBUILD RUN chown -R unicorn:unicorn /opt/app
ONBUILD RUN chmod -R 0770 /opt/app
ONBUILD USER unicorn

EXPOSE 8080
ENTRYPOINT ["/tmp/unicorn-wrapper.sh"]
