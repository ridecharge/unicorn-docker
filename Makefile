DOCKER_REPO?=registry.gocurb.internal:80
CONTAINER=$(DOCKER_REPO)/unicorn

all: build push clean

build:
	docker build -t --no-cache $(CONTAINER):latest . 

push:
	docker push $(CONTAINER)

clean:
	docker rmi $(CONTAINER)