//
//  ClassifyImageViewPreview.swift
//  CoreMLDemo
//
//  Created by Igor on 8/23/25.
//

import Foundation
import SwiftUI

struct ClassifyImageViewPreview: View {
    let image: UIImage
    @State var label = "Classifying..."
    @State var modelName = ""
    private let models = ["MobileNetV2", "MobileNetV2FP16", "MobileNetV2Int8LUT"]

    var body: some View {
        VStack(spacing: 16) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
            Spacer()
            Text(label)
            Spacer()
        }
        .onChange(of: modelName) { oldValue, newValue in
            Task {
                do {
                    let classifier = try ImageClassifier(modelName: modelName)
                    let result = try classifier.classify(image)
                    label = result
                        .predictions
                        .enumerated()
                        .map { (idx, prediction) in
                            "\(idx + 1). \(prediction.label) - \(prediction.confidence)"
                        }.joined(separator: "\n")
                } catch let error {
                    label = error.localizedDescription
                }
            }
        }
        .onAppear() {
            modelName = "MobileNetV2"
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(models, id: \.self, content: modelButton)
                } label: {
                    Label("", systemImage: "cube")
                }
            }
        }
        .padding()
        .navigationTitle("Preview")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func modelButton(_ name: String) -> some View {
        Button {
            modelName = name
        } label: {
            if modelName == name {
                Label(name, systemImage: "checkmark")
            } else {
                Text(name)
            }
        }
    }
}

