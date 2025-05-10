import { sdk } from './sdk'
import { setDependencies } from './dependencies'
import { setInterfaces } from './interfaces'
import { versions } from './versions'
import { actions } from './actions'
import { resetPassword } from './actions/resetPassword'

// **** Pre Install ****
const preInstall = sdk.setupPreInstall(async ({ effects }) => {})

// **** Install ****
const postInstall = sdk.setupPostInstall(async ({ effects }) => {
  await sdk.action.requestOwn(effects, resetPassword, 'critical')
})

// **** Uninstall ****
const uninstall = sdk.setupUninstall(async ({ effects }) => {})

/**
 * Plumbing. DO NOT EDIT.
 */
export const { packageInit, packageUninit, containerInit } = sdk.setupInit(
  versions,
  preInstall,
  postInstall,
  uninstall,
  setInterfaces,
  setDependencies,
  actions,
)
