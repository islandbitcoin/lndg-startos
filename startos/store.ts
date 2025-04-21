import { setupExposeStore } from '@start9labs/start-sdk'

export type Store = {
  hasPass: boolean
}

export const initStore: Store = {
  hasPass: false,
}

export const exposedStore = setupExposeStore<Store>(() => [])
