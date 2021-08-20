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
    case sendPushNotification(Push)
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
    case let .sendPushNotification(push):
        return environment
            .networkClient
            .performRequest(push)
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

    var body: some View {
        WithViewStore(self.store) { viewStore in
            Button(
                action: {
                    viewStore.send(
                        .sendPushNotification(
                            Push(
                                apnsToken: "yooo",
                                fileUrl: nil,
                                topicId: "",
                                password: "")
                        )
                    )
                },
                label: {
                    Text("Call me maybe!")
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: DontPushMeState(), reducer: callReducer, environment: DontPushMeEnvironment(networkClient: NetworkClient(performRequest: { request in
            Effect(value: "dummy")
        }), mainQueue: .main)))
    }
}
