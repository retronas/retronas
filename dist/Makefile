.DEFAULT_GOAL := help
SHELL = /bin/sh

LOCAL_DIR = $(shell pwd)

init: ## Set up the docker container
	docker build -t retronas:retronas .

build-32: ## Build the 32 bit debian image in the docker container
	docker run \
	-it \
	--rm \
	-v $(LOCAL_DIR):/build \
	--workdir=/build \
	retronas \
	build-simple-cdd --force-root --conf /build/retronas-32.conf

build-64: ## Build the 64 bit debian image in the docker container
	docker run \
	-it \
	--rm \
	-v $(LOCAL_DIR):/build \
	--workdir=/build \
	retronas \
	build-simple-cdd --force-root --conf /build/retronas-64.conf

build-all: build-32 build-64 ## Build for all architectures

help: ## Show this help.
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
