## Changelog

## [Version 2.0.0](https://github.com/yannickl/YLTCPBroadcaster/releases/tag/2.0.0)
*Released on 2015-10-29.*

- [ADD] `YLTCPBroadcasterDelegate` property
- [ADD] `YLTCPSocketStatus` enum
- [ADD] `maxConcurrentConnectionCount` property
- [UPDATE] Rename `networkPrefixWithIp:subnetMask:` to `subnetWithIp:mask:`
- [UPDATE] Rename `broadcastAddressWithIp:subnetMask:` to `broadcastAddressWithIp:mask:`
- [UPDATE] Improve compatibility with Swift 2

## [Version 1.1.0](https://github.com/yannickl/YLTCPBroadcaster/releases/tag/1.1.0)
*Released on 2015-10-29.*

- [ADD] Carthage support

### [Version 1.0.0 (Initial Version)](https://github.com/yannickl/YLTCPBroadcaster/releases/tag/1.0.0)
*Released on 2014-10-28.*

- Scan the local network (ip, subnet mask) in order to locate all hosts with a given TCP port open
- Utilities to retrieve `ip`, `subnet mask`, `broadcast address`, `network prefix`
