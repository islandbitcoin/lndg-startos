import { matches, FileHelper } from '@start9labs/start-sdk'

export const adminTxtFile = FileHelper.raw(
  {
    volumeId: 'data',
    subpath: '/lndg-admin.txt',
  },
  (a) => a,
  (a) => a,
  matches.string.unsafeCast,
)
