//
//  UIImage+Extensions.swift
//  CoreMLDemo
//
//  Created by Igor on 8/23/25.
//

import CoreImage
import UIKit

extension UIImage {
    var cgOrientation: CGImagePropertyOrientation {
        switch imageOrientation {
        case .up: return .up
        case .upMirrored: return .upMirrored
        case .down: return .down
        case .downMirrored: return .downMirrored
        case .left: return .left
        case .leftMirrored: return .leftMirrored
        case .right: return .right
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }

    func cgImageFallback() -> CGImage? {
        if let cgImage {
            return cgImage
        }
        guard let ci = CIImage(image: self) else { return nil }
        return CIContext().createCGImage(ci, from: ci.extent)
    }
}
