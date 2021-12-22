ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell cat ./Dockerfile | head -n 1 | sed -e 's/^.*://')

.DELETE_ON_ERROR:

all: lndg.s9pk

install: lndg.s9pk
        embassy-cli package install lndg.s9pk

lndg.s9pk: manifest.yaml config_spec.yaml config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
        embassy-sdk pack

instructions.md: README.md
        cp README.md instructions.md

Dockerfile: Dockerfile
        patch -u Dockerfile -i lndg.patch

image.tar: Dockerfile docker_entrypoint.sh
        docker build --tag start9/lndg/main:$(VERSION) .
        docker save -o image.tar start9/lndg/main:$(VERSION)