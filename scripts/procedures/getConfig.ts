import { compat, types as T } from "../deps.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
  "tor-address": {
    "name": "Network Tor Address",
    "description": "The Tor address for the network interface.",
    "type": "pointer",
    "subtype": "package",
    "package-id": "lndg",
    "target": "tor-address",
    "interface": "main"
  },
  "lan-address": {
    "name": "Network LAN Address",
    "description": "The LAN address for the network interface.",
    "type": "pointer",
    "subtype": "package",
    "package-id": "lndg",
    "target": "lan-address",
    "interface": "main"
  },
  "password": {
    "type": "string",
    "name": "Password",
    "description": "Administrator password for LNDg (The username is 'lndg-admin')",
    "nullable": false,
    "copyable": true,
    "masked": true,
    "default": {
      "charset": "a-z,A-Z,0-9",
      "len": 22
    }
  }
});