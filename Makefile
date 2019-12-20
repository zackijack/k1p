SHELL         = /bin/bash
APP_NAME      = k1p
VERSION      := $(shell git describe --always --tags)
GIT_COMMIT    = $(shell git rev-parse HEAD)
GIT_STATE     = $(shell test -n "`git status --porcelain`" && echo "dirty" || "clean")
DOCKER_REGISTRY  = zackijack

.PHONY: default
default: help

.PHONY: help
help:
	@echo 'Make commands for ${APP_NAME}:'
	@echo
	@echo 'Usage:'
	@echo '    make build            Compile the project.'
	@echo '    make package          Build final Docker image with just the Go binary inside.'
	@echo '    make tag              Tag image created by package with latest, Git commit and version.'
	@echo '    make push             Push tagged images to registry.'
	@echo '    make run ARGS=        Run with supplied arguments.'
	@echo '    make test             Run tests on a compiled project.'
	@echo '    make clean            Clean the directory tree.'

	@echo

.PHONY: build
build:
	@echo "Building ${APP_NAME} ${VERSION}"
	go build -ldflags "-w -X github.com/zackijack/k1p/internal/version.Version=${VERSION} -X github.com/zackijack/k1p/internal/version.GitCommit=${GIT_COMMIT} -X github.com/zackijack/k1p/internal/version.GitTreeState=${GIT_STATE}" -o bin/${APP_NAME}

.PHONY: package
package:
	@echo "Building image ${APP_NAME} ${VERSION} ${GIT_COMMIT}"
	docker build --build-arg VERSION=${VERSION} --build-arg GIT_COMMIT=${GIT_COMMIT}${GIT_DIRTY} -t ${DOCKER_REGISTRY}/${APP_NAME}:local .

.PHONY: tag
tag: package
	@echo "Tagging: latest ${VERSION} ${GIT_COMMIT}"
	docker tag ${DOCKER_REGISTRY}/${APP_NAME}:local ${DOCKER_REGISTRY}/${APP_NAME}:${GIT_COMMIT}
	docker tag ${DOCKER_REGISTRY}/${APP_NAME}:local ${DOCKER_REGISTRY}/${APP_NAME}:${VERSION}
	docker tag ${DOCKER_REGISTRY}/${APP_NAME}:local ${DOCKER_REGISTRY}/${APP_NAME}:latest

.PHONY: push
push: tag
	@echo "Pushing Docker image to registry: latest ${VERSION} ${GIT_COMMIT}"
	docker push ${DOCKER_REGISTRY}/${APP_NAME}:${GIT_COMMIT}
	docker push ${DOCKER_REGISTRY}/${APP_NAME}:${VERSION}
	docker push ${DOCKER_REGISTRY}/${APP_NAME}:latest

.PHONY: run
run: build
	@echo "Running ${APP_NAME} ${VERSION}"
	bin/${APP_NAME} ${ARGS}

.PHONY: test
test:
	@echo "Testing ${APP_NAME} ${VERSION}"
	go test ./...

.PHONY: clean
clean:
	@echo "Removing ${APP_NAME} ${VERSION}"
	@test ! -e bin/${APP_NAME} || rm bin/${APP_NAME}
