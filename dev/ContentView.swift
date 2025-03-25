//
//  ContentView.swift
//  dev
//
//  Created by Elie Abi Char on 18/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingView = false
    @State private var isShowingObjectiveC = false

    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                            .imageScale(.large)
//                            .foregroundStyle(.tint)
//
//            Text("Hello, world!")
//            
            Button("Open pdf editor") {
                isShowingObjectiveC = true
            }
            .padding()
            .fullScreenCover(isPresented: $isShowingObjectiveC) {
                ObjectiveCViewControllerWrapper()
            }
        }
    }
}

#Preview {
    ContentView()
}
