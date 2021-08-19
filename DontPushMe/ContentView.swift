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
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
