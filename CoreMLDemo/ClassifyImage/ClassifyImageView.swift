//
//  ClassifyImageView.swift
//  CoreMLDemo
//
//  Created by Igor on 8/22/25.
//

import Foundation
import PhotosUI
import SwiftUI

struct ClassifyImageView: View {
    @State private var showCamera = false
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var image: UIImage?

    var body: some View {
        VStack(spacing: 16) {
            Text("Pick an image to classify")
                .font(.headline)
            Button("Take Photo") {
                showCamera = true
            }
            .buttonStyle(.bordered)
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                Text("Camera Roll")
            }
            .buttonStyle(.bordered)
            Spacer()
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker(image: $image).ignoresSafeArea()
        }
        .navigationDestination(item: $image) { image in
            ClassifyImageViewPreview(image: image)
        }
        .onChange(of: photosPickerItem) { oldValue, newValue in
            if let newValue {
                photosPickerItem = nil
                Task {
                    guard let data = try? await newValue.loadTransferable(type: Data.self) else { return }
                    guard let image = UIImage(data: data) else { return }
                    self.image = image
                }
            }
        }
        .padding()
        .navigationTitle("Classify Image")
    }

}
