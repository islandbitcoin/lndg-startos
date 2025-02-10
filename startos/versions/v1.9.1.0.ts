import { VersionInfo, IMPOSSIBLE } from '@start9labs/start-sdk'
import { rmdir } from 'fs/promises'

export const v_1_9_1_1 = VersionInfo.of({
  version: '1.9.1:1',
  releaseNotes: 'Revamped for StartOS 0.3.6',
  migrations: {
    up: async ({ effects }) => {
      await rmdir('/media/startos/volumes/main/start9')
    },
    down: IMPOSSIBLE,
  },
})
