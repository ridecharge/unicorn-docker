# unicorn-docker
This is the primary container for the unicorn web server.

It configures itself from the consul service and has confd writing configs. We do not auto reload on key change for the app server and require a deployment.

It uses the containers `$HOSTNAME` passed in by docker to do configure key lookups in consul.
Its intended to be linked/proxyed by the [nginx-docker](https://github.com/ridecharge/nginx-docker).

We write all logs to stdout to allow docker's logging driver to handle log output.
