PROJECT_ROOT:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJECT_PACKAGE=github.com/dump247/ec2metaproxy

DOCKER_IMAGE=docker.strava.com/dump247/ec2metaproxy:15min

GO15VENDOREXPERIMENT=1

SRC_DIRS=${PROJECT_PACKAGE}
CMD_DIRS=${PROJECT_PACKAGE}

.PHONY: clean build test compile fmt docker-image

build: fmt test compile

compile:
	go install ${CMD_DIRS}

test:
	go test ${SRC_DIRS}

lint:
	golint ${SRC_DIRS}

fmt:
	go fmt ${SRC_DIRS}

clean:
	go clean -i ${SRC_DIRS}

docker-image: clean
	docker build -t dump247/ec2metaproxy-build -f Dockerfile.build .
	docker run --rm -v ${GOPATH}:/go -w=/go/src/${PROJECT_PACKAGE} dump247/ec2metaproxy-build make
	@cp ${PROJECT_ROOT}/Dockerfile ${GOPATH}/bin/
	docker build -t ${DOCKER_IMAGE} ${GOPATH}/bin/

push-docker-image: docker-image
	docker push ${DOCKER_IMAGE}
