DOCKER_REPO?=registry.gocurb.internal:80
CONTAINER=$(DOCKER_REPO)/unicorn

all: build push

build:
	sudo docker build -t $(CONTAINER):latest . 

push:
	sudo docker push $(CONTAINER)
