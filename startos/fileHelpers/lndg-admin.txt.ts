import { matches, FileHelper } from '@start9labs/start-sdk'

export const adminTxtFile = FileHelper.raw(
  '/media/startos/volumes/app/data/lndg-admin.txt',
  (a) => a,
  (a) => a,
  matches.string.unsafeCast,
)
