# Basic instructions for setup of LNDg

`lndg` is a Lite GUI web interface to analyze lnd data and leverage the backend database for automation tools around rebalancing and other basic maintenance tasks. This is considered a Power User LND Tool, and is not officially supported by Start9.

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [toml](https://crates.io/crates/toml-cli)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/blob/master/backend/install-sdk.sh)
- [make](https://www.gnu.org/software/make/)

## Cloning

Clone the project locally. Note the submodule link to the original project(s). 

```
git clone git@github.com:Start9Labs/lndg-wrapper.git
cd lndg-wrapper
git submodule update --init --recursive
docker run --privileged --rm tonistiigi/binfmt --install arm64,riscv64,arm
cargo install --git=https://github.com/Start9Labs/md-packer.git --branch=main
```

## Building

To build the project, run the following commands:

```
make
```

## Installing (on Embassy)

SSH into an Embassy device.
`scp` the `.s9pk` to any directory from your local machine.

```
scp lndg.s9pk root@<LAN ID>:/root
```

Run the following command to determine successful install:

```
embassy-cli auth login
embassy-cli package install lndg.s9pk
```
