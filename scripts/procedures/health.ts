import { types as T, checkWebUrl, catchError } from "../deps.ts";

export const health: T.ExpectedExports.health = {
  // deno-lint-ignore require-await
  async "web-ui" (effects, duration) {
    return checkWebUrl("http://lndg.embassy:8889")(effects, duration).catch(catchError(effects))
  }
}