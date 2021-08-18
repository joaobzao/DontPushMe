//
//  ContentView.swift
//  DontPushMe
//
//  Created by Joao Zao on 18/08/2021.
//

import SwiftUI
import Foundation

struct ContentView: View {
    var body: some View {
        Button(action: { callMeMaybe() }, label: {
            Text("Call me maybe!")
        })

    }

    func callMeMaybe() {
        shell("curl -i -d '{\"com.urbanairship.metadata\":\"eyJ2ZXJzaW9uX2lkIjoxLCJ0aW1lIjoxNjI5MjgzNTQzNDM5LCJwdXNoX2lkIjoiMmM5OWJhMjUtMjdlMC00NmMxLWFjNzAtNmRhZWYzNWQ0NGVlIiwicmV0YXJnZXRpbmciOmZhbHNlfQ==\",\"aps\":{\"alert\":{\"title\":\"Makinghismove!\",\"subtitle\":\"Was4,NOW6\",\"body\":\"Afteranimpressivesem.\"},\"actions\":{\"open\":{\"type\":\"deeplink\",\"content\":\"ppnsportsbooku://homepage\"}}},\"options\":{\"message_name\":\"010821-Men s100mfinal\"}}' -H \"apns-topic:com.paddypower.sportsbook.u.inhouse.wrapper\" \"apns-priority: 10\" --http2 --cert-type P12 --cert /Users/zaoj/Downloads/Certificates.p12:PaddyPower2022! https://api.development.push.apple.com/3/device/fab91e6ce1afb50ab85d4b50da1d416601791c5c4cae8d1b7b0c65aa866481fd")
    }

    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/sh"
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        print(output)

        return output
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
