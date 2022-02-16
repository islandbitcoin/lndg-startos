VERSION := $(shell cat ./Dockerfile | head -n 1 | sed -e 's/^.*://')
EMVER := $(shell yq e ".version" manifest.yaml)
LNDG_SRC := $(shell find ./lndg)
S9PK_PATH=$(shell find . -name lndg.s9pk -print)

.DELETE_ON_ERROR:

all: verify

verify: lndg.s9pk $(S9PK_PATH)
	embassy-sdk verify $(S9PK_PATH)

install: lndg.s9pk 
	embassy-cli package install lndg.s9pk

lndg.s9pk: manifest.yaml assets/compat/* image.tar doc/instructions.md LICENSE icon.png
	embassy-sdk pack

Dockerfile: $(LNDG_SRC)
	cp lndg/arm64v8.Dockerfile Dockerfile
	patch -u Dockerfile -i lndg.patch

image.tar: Dockerfile docker_entrypoint.sh
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/lndg/main:${EMVER} --platform=linux/arm64/v8 -f Dockerfile -o type=docker,dest=image.tar .