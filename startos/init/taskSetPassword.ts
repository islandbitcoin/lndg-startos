import { resetPassword } from '../actions/resetPassword'
import { adminTxtFile } from '../fileHelpers/lndg-admin.txt'
import { sdk } from '../sdk'

export const taskSetPassword = sdk.setupOnInit(async (effects) => {
  if (!(await adminTxtFile.read().const(effects))) {
    await sdk.action.createOwnTask(effects, resetPassword, 'critical', {
      reason: 'Set you LNDg password',
    })
  }
})
