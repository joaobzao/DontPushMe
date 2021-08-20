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
