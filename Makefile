CONTAINER=ridecharge/unicorn

all: build push

build:
	docker build -t $(CONTAINER):latest . 

push:
	docker push $(CONTAINER)
