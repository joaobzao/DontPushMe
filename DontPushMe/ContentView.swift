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
    case sendPushNotification
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
    case .sendPushNotification:
        return environment
            .networkClient
            .performRequest(Request(apnsToken: "", fileUrl: nil, topicId: "", priority: "", password: ""))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(DontPushMeAction.showPushResult)
    case .showPushResult:
        return .none
    }
}

struct ContentView: View {
    let store: Store<DontPushMeState, DontPushMeAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            Button(action: { viewStore.send(.sendPushNotification) }, label: {
                Text("Call me maybe!")
            })
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
