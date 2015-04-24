DOCKER_REPO?=registry.gocurb.internal:80
CONTAINER=$(DOCKER_REPO)/unicorn

all: build push

build:
	docker build -t $(CONTAINER):latest . 

push:
	docker push $(CONTAINER)

clean:
	docker rmi $(CONTAINER)