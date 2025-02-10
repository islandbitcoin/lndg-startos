import { sdk } from './sdk'

export const setDependencies = sdk.setupDependencies(async ({ effects }) => {
  return {
    lnd: {
      kind: 'running',
      versionRange: '>=18.4',
      healthChecks: ['primary'], // @TODO make sure this is the correct health check ID
    },
  }
})
