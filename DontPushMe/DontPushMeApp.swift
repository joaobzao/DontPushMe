//
//  DontPushMeApp.swift
//  DontPushMe
//
//  Created by Joao Zao on 18/08/2021.
//

import SwiftUI
import ComposableArchitecture

@main
struct DontPushMeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(
                            initialState: DontPushMeState(),
                            reducer: callReducer.debug(),
                            environment: DontPushMeEnvironment(
                                networkClient: NetworkClient.pushNotification,
                                mainQueue: .main
                            )
                )
            )
            .frame(width: 600, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .colorScheme(.dark)
        }
    }
}
