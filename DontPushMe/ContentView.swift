//
//  ContentView.swift
//  DontPushMe
//
//  Created by Joao Zao on 18/08/2021.
//

import SwiftUI
import Foundation
import ComposableArchitecture

struct DontPushMeState: Equatable {
    var pushesSent: [String] = []
}

enum DontPushMeAction: Equatable {
    case sendPushNotification(Push, SSLModule)
    case showPushResult(Result<String, RequestError>)
}

struct DontPushMeEnvironment {
    var networkClient: NetworkClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - DontPushMe feature reducer

let callReducer = Reducer<DontPushMeState, DontPushMeAction, DontPushMeEnvironment> {
    state, action, environment in
    switch action {
    case let .sendPushNotification(push, sslModule):
        return environment
            .networkClient
            .performRequest(push, sslModule)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(DontPushMeAction.showPushResult)
    case let .showPushResult(result):
        switch result {
        case let .success(result):
            print(result)
        case let .failure(error):
            print(error)
        }
        return .none
    }
}

struct ContentView: View {
    let store: Store<DontPushMeState, DontPushMeAction>
    let sslModule = SSLModule()

    @State var payload: String = ""
    @State var apnsToken: String = ""
    @State var fileUrl: URL? = nil
    @State var topicId: String = ""
    @State var priority: String = "10"
    @State var password: String = ""

    var body: some View {
        WithViewStore(self.store) { viewStore in
            Button(action: {
                    sslModule.delegate = self
                    viewStore.send(.sendPushNotification(Push(apnsToken: apnsToken,
                                                              fileUrl: fileUrl,
                                                              topicId: topicId,
                                                              password: password,
                                                              payload: payload),
                                                         sslModule))},
                   label: { Text("Call me maybe!") })
        }
    }
}

extension ContentView: SSLModuleDelegate {
    var push: Push {
        Push(apnsToken: apnsToken,
             fileUrl: fileUrl,
             topicId: topicId,
             password: password,
             payload: payload)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: DontPushMeState(), reducer: callReducer, environment: DontPushMeEnvironment(networkClient: NetworkClient(performRequest: { request, sslModule  in
            Effect(value: "dummy")
        }), mainQueue: .main)))
    }
}

extension ContentView_Previews: SSLModuleDelegate {
    var push: Push {
        Push(apnsToken: "", fileUrl: nil, topicId: "", password: "", payload: "")
    }
}
