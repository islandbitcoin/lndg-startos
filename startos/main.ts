import { sdk } from './sdk'
import { T } from '@start9labs/start-sdk'
import { uiPort } from './utils'

export const main = sdk.setupMain(async ({ effects, started }) => {
  /**
   * ======================== Setup (optional) ========================
   *
   * In this section, we fetch any resources or run any desired preliminary commands.
   */
  console.info('Starting LNDg!')

  const depResult = await sdk.checkDependencies(effects)
  depResult.throwIfNotSatisfied()

  /**
   * ======================== Additional Health Checks (optional) ========================
   *
   * In this section, we define *additional* health checks beyond those included with each daemon (below).
   */
  const healthReceipts: T.HealthCheck[] = []

  /**
   * ======================== Daemons ========================
   *
   * In this section, we create one or more daemons that define the service runtime.
   *
   * Each daemon defines its own health check, which can optionally be exposed to the user.
   */
  return sdk.Daemons.of(effects, started, healthReceipts).addDaemon('primary', {
    subcontainer: await sdk.SubContainer.of(
      effects,
      { imageId: 'lndg' },
      sdk.Mounts.of()
        .mountVolume({
          volumeId: 'main',
          subpath: null,
          mountpoint: '/root',
          readonly: false,
        })
        .mountVolume({
          volumeId: 'data',
          subpath: null,
          mountpoint: '/app/data',
          readonly: false,
        })
        // @TODO watch the macaroon and restart if changes
        .mountDependency({
          dependencyId: 'lnd',
          volumeId: 'main',
          subpath: '/mnt/lnd/',
          mountpoint: '/app/data/mnt/lnd/data/chain/bitcoin/mainnet',
          readonly: true,
        }),
      'lndg-sub',
    ),
    command: [
      'initialize.py',
      '-net',
      'mainnet',
      '-rpc',
      '127.0.0.1:10009',
      '-wn',
      '&&',
      'python',
      'controller.py',
      'runserver',
      '0.0.0.0:8889',
      '>',
      '/var/log/lndg-controller.log',
      '1>&1',
    ],
    ready: {
      display: 'Web Interface',
      fn: () =>
        sdk.healthCheck.checkPortListening(effects, uiPort, {
          successMessage: 'The web interface is ready',
          errorMessage: 'The web interface is not ready',
        }),
    },
    requires: [],
  })
})
