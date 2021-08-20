//
//  NetworkClient.swift
//  DontPushMe
//
//  Created by Joao Zao on 20/08/2021.
//

import Foundation
import ComposableArchitecture

struct Request: Hashable {
    var apnsToken: String
    var fileUrl: URL?
    var topicId: String
    var priority: String
    var password: String
}

enum RequestError: Error, Equatable {
    case failure(String)
}

struct NetworkClient {
    var performRequest: (Request) -> Effect<String, RequestError>
}

// MARK: - API implementation

extension NetworkClient {
    static let pushNotification = NetworkClient { request in
        return Effect(value: "sada")
    }
}
