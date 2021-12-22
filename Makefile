ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))

.DELETE_ON_ERROR:

all: lndg.s9pk

install: lndg.s9pk
        appmgr install lndg.s9pk

lndg.s9pk: manifest.yaml config_spec.yaml config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
        appmgr -vv pack $(shell pwd) -o lndg.s9pk
        appmgr -vv verify lndg.s9pk

instructions.md: README.md
        cp README.md instructions.md

Dockerfile: Dockerfile
        patch -u Dockerfile -i lndg.patch

image.tar: Dockerfile docker_entrypoint.sh
        docker build --tag start9/lndg .
        docker save -o image.tar start9/lndg:latest