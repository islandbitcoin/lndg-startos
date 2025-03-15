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
    subcontainer: { imageId: 'lndg' },
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
    mounts: sdk.Mounts.of()
      .addVolume('main', null, '/root', false)
      .addVolume('data', null, '/app/data', false)
      // @TODO watch the macaroon and restart if changes
      .addDependency(
        'lnd',
        'main',
        '/mnt/lnd/',
        '/app/data/mnt/lnd/data/chain/bitcoin/mainnet',
        true,
      ),
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
