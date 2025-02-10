import { sdk } from '../sdk'
import { adminTxtFile } from '../file-helpers/lndg-admin.txt'

export const showCredentials = sdk.Action.withoutInput(
  // id
  'reset-password',

  // metadata
  async ({ effects }) => {
    const hasPassword = await adminTxtFile.read.const(effects)

    return {
      name: 'Show Credentials',
      description: 'Reveal your LNDg username and password',
      warning: null,
      allowedStatuses: 'any',
      group: null,
      visibility: hasPassword ? 'enabled' : 'hidden',
    }
  },

  // the execution function
  async ({ effects }) => {
    // The password must be there because we just checked above
    const password = (await adminTxtFile.read.const(effects))!

    return {
      version: '1',
      title: 'Your LNDg Credentials',
      message: 'Your username and password are below',
      result: {
        type: 'group',
        value: [
          {
            name: 'Username',
            description: null,
            type: 'single',
            value: 'lndg-admin',
            masked: false,
            copyable: true,
            qr: false,
          },
          {
            name: 'Password',
            description: null,
            type: 'single',
            value: password,
            masked: true,
            copyable: true,
            qr: false,
          },
        ],
      },
    }
  },
)
