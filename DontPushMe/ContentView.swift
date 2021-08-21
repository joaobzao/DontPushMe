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
            VStack(alignment: .leading) {
                HStack {
                    Image("pick-file").onTapGesture {
                        let panel = NSOpenPanel()
                        panel.allowedFileTypes = ["p12"]
                        panel.allowsMultipleSelection = false
                        panel.canChooseDirectories = false
                        panel.canChooseFiles = true
                        fileUrl = panel.runModal() == .OK ? panel.url : nil
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: nil) {
                        TextField("Topic ID", text: $topicId)
                            .font(.body)
                        TextField("Priority", text: $priority)
                            .font(.body)
                        SecureField("Certificate Password", text: $password)
                            .font(.body)
                    }
                    .padding(.trailing, 8)
                    .frame(width: 200, height: nil, alignment: .center)
                }

                Text((self.fileUrl == nil ? "No Cert Selected" : self.fileUrl?.lastPathComponent) ?? "")
                    .font(.body)
                    .padding(.leading, 8)
                    .padding(.bottom, 16)

                Text("Your APNs Token")
                    .font(.title)
                    .padding(.leading, 8)


                TextField("Debug Token", text: $apnsToken)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 4)
                    .cornerRadius(4)
                    .padding(.bottom, 16)
                    .font(.body)

                Text("Payload")
                    .font(.title)
                    .padding(.leading, 8)

                TextField("Payload", text: $payload)
                    .lineLimit(nil)
                    .frame(minWidth: 50, idealWidth: 100, maxWidth: .infinity, minHeight: 20, idealHeight: 80, maxHeight: .infinity, alignment: .center)


                HStack {
                    Spacer()
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
                .padding()
            }
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
