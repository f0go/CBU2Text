//
//  OCR.swift
//  CBU2Text
//
//  Created by f0go on 19/07/2022.
//

import Foundation
import UIKit
import Vision

final class OCR {
    
    func img2cbu(cgImage: CGImage, completion: @escaping(_ response: String?) -> ()){
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let recognizedStrings = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }
            for text in recognizedStrings {
                if (text.range(of: "\\d{22}", options: .regularExpression) != nil) {
                    let cbu = text[text.range(of: "\\d{22}", options: .regularExpression)!]
                    completion(String(cbu))
                    return
                }
            }
            completion(nil)
        }
        do {
            try requestHandler.perform([request])
        } catch  {
            completion(nil)
        }
    }
}
