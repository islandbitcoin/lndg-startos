import { matches, FileHelper } from '@start9labs/start-sdk'

const { object, boolean } = matches

const shape = object({
  hasPass: boolean,
})

export const store = FileHelper.json(
  { volumeId: 'main', subpath: '/store.json' },
  shape,
)
