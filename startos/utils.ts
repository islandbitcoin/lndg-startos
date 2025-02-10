export const uiPort = 80

export function randomPassword() {
  return {
    charset: 'a-z,A-Z,1-9,!,@,$,%,&,*',
    len: 22,
  }
}
