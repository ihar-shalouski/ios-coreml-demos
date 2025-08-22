//
//  ImageClassifier.swift
//  CoreMLDemo
//
//  Created by Igor on 8/23/25.
//

import UIKit
import CoreML
import Vision
import ImageIO

final class ImageClassifier {

    struct Prediction: Identifiable {
        let id = UUID()
        let label: String
        let confidence: Float
    }

    struct Result {
        let predictions: [Prediction]
        let inferenceMS: Int
    }

    enum Error: LocalizedError {
        case modelNotFound(String)
        case cgImageUnavailable
        case noPredictions

        var errorDescription: String? {
            switch self {
            case .modelNotFound(let description):
                return description
            case .noPredictions:
                return "No predictions"
            case .cgImageUnavailable:
                return "Cannot parse the image"
            }
        }
    }

    private let vnModel: VNCoreMLModel

    init(modelName: String = "MobileNetV2") throws {
        let url = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc")
        guard let url else {
            throw Error.modelNotFound("\(modelName).mlmodelc not found in app bundle (this can happen on the first launch, restart the app).")
        }
        let mlModel = try MLModel(contentsOf: url)
        self.vnModel = try VNCoreMLModel(for: mlModel)
        self.vnModel.inputImageFeatureName = "image"
    }

    func classify(_ image: UIImage, topK: Int = 5) throws -> Result {
        guard let cg = image.cgImage ?? image.cgImageFallback() else {
            throw Error.cgImageUnavailable
        }

        let request = VNCoreMLRequest(model: vnModel)
        request.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(cgImage: cg, orientation: image.cgOrientation)
        let start = CACurrentMediaTime()
        try handler.perform([request])

        guard let out = request.results as? [VNClassificationObservation], !out.isEmpty else {
            throw Error.noPredictions
        }

        let preds = Array(out.prefix(topK)).map {
            Prediction(label: $0.identifier, confidence: $0.confidence)
        }
        let elapsed = Int((CACurrentMediaTime() - start) * 1000)
        return Result(predictions: preds, inferenceMS: elapsed)
    }
}
