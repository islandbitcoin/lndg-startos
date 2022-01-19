ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell toml get lndg/Cargo.toml package.version)
LNDG_SRC := $(shell find ./lndg)
VERSION := $(shell yq e ".version" manifest.yaml)

.DELETE_ON_ERROR:

all: verify

verify: lndg.s9pk
	embassy-sdk verify lndg.s9pk

install: lndg.s9pk
	embassy-cli package install lndg.s9pk

lndg.s9pk: manifest.yaml assets/compat/config_spec.yaml assets/compat/config_rules.yaml image.tar instructions.md
	embassy-sdk pack

Dockerfile: $(LNDG_SRC)
	cp lndg/arm64v8.Dockerfile Dockerfile
	patch -u Dockerfile -i lndg.patch

image.tar: Dockerfile docker_entrypoint.sh
	docker build --tag start9/lndg/main:$(VERSION) .
	docker save -o image.tar start9/lndg/main:$(VERSION)
