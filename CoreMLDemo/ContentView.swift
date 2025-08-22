//
//  ContentView.swift
//  CoreMLDemo
//
//  Created by Igor on 8/22/25.
//

import SwiftUI

enum Route: Hashable {
    case classifyImage
}

struct ContentView: View {
    var body: some View {
            NavigationStack {
                List {
                    // 2) Переходим по значению маршрута
                    NavigationLink("Classify image", value: Route.classifyImage)
                }
                .navigationTitle("CoreML Demos")
                // 3) Описываем, на какую вьюху вести для каждого маршрута
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .classifyImage:
                        ClassifyImageView()
                    }
                }
            }
        }
}

#Preview {
    ContentView()
}
