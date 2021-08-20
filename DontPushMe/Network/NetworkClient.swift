//
//  NetworkClient.swift
//  DontPushMe
//
//  Created by Joao Zao on 20/08/2021.
//

import Foundation
import ComposableArchitecture

protocol Request: Hashable {}

enum RequestError: Error, Equatable {
    case failure(String)
}

struct NetworkClient {
    var performRequest: (Push) -> Effect<String, RequestError>
}

// MARK: - API implementation

extension NetworkClient {
    static let pushNotification = NetworkClient { request in
        return Effect(value: request.apnsToken)
    }
}
