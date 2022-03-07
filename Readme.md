# WIP: DontPushMe

A simple tool to test iOS push notifications.

## Disclaimer

Attention please, just dumped some quick and dirty code..
I just made it public because some fellas asked me to access the tool.. It is working but needs a lot of care.

## Motivation

The [pusher app](https://github.com/noodlewerk/NWPusher) seems to be legacy and apparently stopped working, as per [this issue](https://github.com/noodlewerk/NWPusher/issues/80#issue-864880443)
So this is just a tool to fulfill the gap pusher left.

> APNs will not support legacy binary protocol as of March 31, 2021.
https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/sending_notification_requests_to_apns/

## Requirements

* p12 certificate and password
* device token
* bundle identifier

## Technical approach

* TCAs - The Composable Architecture
* SwiftUI
