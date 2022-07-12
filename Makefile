EMVER := $(shell yq e ".version" manifest.yaml)
COMPAT_ASSET_PATHS := $(shell find ./assets/compat/*)
UTILS_ASSET_PATHS := $(shell find ./assets/utils/*)
LNDG_SRC := $(shell find ./lndg)
DOC_ASSETS := $(shell find ./docs/assets)
S9PK_PATH=$(shell find . -name lndg.s9pk -print)

.DELETE_ON_ERROR:

all: verify

clean:
	rm -f lndg.s9pk
	rm -f image.tar
	rm -f scripts/*.js

verify: lndg.s9pk $(S9PK_PATH)
	embassy-sdk verify s9pk $(S9PK_PATH)

lndg.s9pk: manifest.yaml image.tar instructions.md LICENSE icon.png scripts/embassy.js $(COMPAT_ASSET_PATHS)
	embassy-sdk pack

image.tar: docker_entrypoint.sh Dockerfile ${LNDG_SRC} $(UTILS_ASSET_PATHS)
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/lndg/main:${EMVER}	--platform=linux/arm64/v8 -f ./Dockerfile -o type=docker,dest=image.tar .

instructions.md: docs/instructions.md $(DOC_ASSETS)
	cd docs && md-packer < instructions.md > ../instructions.md

scripts/embassy.js: scripts/**/*.ts
	deno cache --reload scripts/embassy.ts
	deno bundle scripts/embassy.ts scripts/embassy.js