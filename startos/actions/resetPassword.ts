import { utils } from '@start9labs/start-sdk'
import { sdk } from '../sdk'
import { adminTxtFile } from '../fileHelpers/lndg-admin.txt'

export const resetPassword = sdk.Action.withoutInput(
  // id
  'reset-password',

  // metadata
  async ({ effects }) => {
    const hasPass = await adminTxtFile.read().const(effects)
    const desc = 'your LNDg password'

    return {
      name: hasPass ? 'Reset Password' : 'Create Password',
      description: hasPass ? `Reset ${desc}` : `Create ${desc}`,
      warning: null,
      allowedStatuses: 'any',
      group: null,
      visibility: 'enabled',
    }
  },

  // the execution function
  async ({ effects }) => {
    const password = utils.getDefaultString({
      charset: 'a-z,A-Z,1-9,!,@,$,%,&,*',
      len: 22,
    })

    await adminTxtFile.write(effects, password)

    return {
      version: '1',
      title: 'Success',
      message: 'Your password is below. Your username is lndg-admin',
      result: {
        type: 'single',
        value: password,
        masked: true,
        copyable: true,
        qr: false,
      },
    }
  },
)
