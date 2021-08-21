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
    var performRequest: (Push, SSLModule) -> Effect<HTTPURLResponse, RequestError>
}

// MARK: - API implementation

extension NetworkClient {
    static let pushNotification = NetworkClient { push, sslModule in
        let api = "\(Constants.apiBasePath)\(push.apnsToken)"

        guard let url = URL(string: api) else {
            return Effect(error: .failure("👻 couldn't create api url"))
        }

        let session = URLSession(configuration: .default,
                                 delegate: sslModule,
                                 delegateQueue: nil)

        var request = URLRequest(url: url)
        request.setValue(push.topicId, forHTTPHeaderField: "apns-topic")
        request.setValue(push.priority, forHTTPHeaderField: "apns-priority")
        request.httpMethod = "POST"
        request.httpBody = push.payload.data(using: .utf8)

        return session.dataTaskPublisher(for: request)
            .map { $0.response as! HTTPURLResponse}
            .mapError { error in RequestError.failure("👻 error -> \(error)") }
            .eraseToEffect()
    }
}

enum Constants {
    static let apiBasePath = "https://api.development.push.apple.com/3/device/"
}
