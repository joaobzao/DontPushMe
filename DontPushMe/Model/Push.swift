//
//  Push.swift
//  DontPushMe
//
//  Created by Joao Zao on 20/08/2021.
//

import Foundation

struct Push: Request {
    let apnsToken: String
    let fileUrl: URL?
    let topicId: String
    let priority: String = "10"
    let password: String
    let payload: String
}

extension Push {
    static let `default` = Push(apnsToken: "fab91e6ce1afb50ab85d4b50da1d416601791c5c4cae8d1b7b0c65aa866481fd",
                                fileUrl: nil,
                                topicId: "com.paddypower.sportsbook.u.inhouse.wrapper",
                                password: "PaddyPower2022!",
                                payload: """
{
    "com.urbanairship.in_app": {
        "actions": {
            "on_click": {
                "^d": "ppnsportsbooku://sport-page/open?eventTypeId=1"
            }
        },
        "display": {
            "alert": "Paddypower! #deeplink",
            "position": "bottom",
            "type": "banner"
        },
        "expiry": "2021-11-17T12:50:44"
    },
    "aps": {
        "alert": {
            "title": "Paddypower! #deeplink🏅",
            "subtitle": "Was4/1,NOW6/1",
            "body": "MaxBet £/€20.",
            "loc-key": "N_MT",
            "loc-args": ["some"]
        },
        "content-available": 1
    },
    "com.urbanairship.metadata": "eyJ2ZXJzaW9uX2lkIjoxLCJ0aW1lIjoxNjI5Mzc3NDQ1MDY2LCJwdXNoX2lkIjoiZDgwMzc1NjgtZDA2Ny00MzUyLTk3M2UtZThiNjFjZWVkNDExIiwicmV0YXJnZXRpbmciOmZhbHNlfQ == ",
    "^d": "ppnsportsbooku://sport-page/open?eventTypeId=1",
    "marketing_url": "ppnsportsbooku://sport-page/open?eventTypeId=1"
}
""")
}
