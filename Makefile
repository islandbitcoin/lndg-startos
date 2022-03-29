EMVER := $(shell yq e ".version" manifest.yaml)
LNDG_SRC := $(shell find ./lndg)
S9PK_PATH=$(shell find . -name lndg.s9pk -print)
LND_IP=$(shell docker network inspect lnd.embassy --format '{{.NetworkSettings.Networks.start9.IPAddress}}')

.DELETE_ON_ERROR:

all: verify

verify: lndg.s9pk $(S9PK_PATH)
	embassy-sdk verify s9pk $(S9PK_PATH)

install: lndg.s9pk 
	embassy-cli package install lndg.s9pk

lndg.s9pk: manifest.yaml assets/* image.tar docs/instructions.md LICENSE icon.png
	embassy-sdk pack

image.tar: Dockerfile docker_entrypoint.sh assets/utils/* ${LNDG_SRC}
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/lndg/main:${EMVER} \
	--build-arg LND_HOST=${LND_IP} --platform=linux/arm64/v8 -f Dockerfile -o type=docker,dest=image.tar .

clean:
	rm -f lndg.s9pk
	rm -f image.tar