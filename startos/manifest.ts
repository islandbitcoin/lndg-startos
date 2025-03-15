import { setupManifest } from '@start9labs/start-sdk'

export const manifest = setupManifest({
  id: 'lndg',
  title: 'LNDg',
  license: 'mit',
  wrapperRepo: 'https://github.com/islandbitcoin/lndg-startos',
  upstreamRepo: 'https://github.com/cryptosharks131/lndg',
  supportSite: 'https://t.me/+cPi5nRCg_1g1MTNh',
  marketingSite: 'https://twitter.com/cryptosharks131',
  donationUrl: null,
  description: {
    short:
      'Web UI for LND developed specifically for LND Routing Node Operators',
    long: 'Powerful web interface to analyze lnd data and leverage the backend database for automation tools around rebalancing and other basic maintenance tasks.',
  },
  volumes: ['main', 'data'],
  images: {
    lndg: {
      source: {
        dockerTag: 'ghcr.io/cryptosharks131/lndg:v1.9.1',
      },
    },
  },
  hardwareRequirements: {},
  alerts: {
    install: null,
    update: null,
    uninstall: null,
    restore: null,
    start: null,
    stop: null,
  },
  dependencies: {
    lnd: {
      description: 'provides the underlying node for LNDg to manage',
      optional: false,
      s9pk: '../hello-world-startos/hello-world.s9pk',
    },
  },
})
