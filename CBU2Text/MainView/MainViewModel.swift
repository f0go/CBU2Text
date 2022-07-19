//
//  MainViewModel.swift
//  CBU2Text
//
//  Created by f0go on 19/07/2022.
//

import Foundation
import UIKit

class MainViewModel {
    
    private let ocr = OCR()
    
    func processImage(image: CGImage, completion: @escaping(_ cbu: String?,_ showRateApp: Bool) -> ()) {
        ocr.img2cbu(cgImage: image) { [weak self] response in
            guard let self = self else { return }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            var rateApp = false
            if let cbu = response {
                UIPasteboard.general.string = cbu
                rateApp = self.addToHistory(cbu: cbu)
            }
            completion(response, rateApp)
        }
    }
    
    private func addToHistory(cbu: String) -> Bool {
        if var list = UserDefaults.standard.value(forKey: "cbuList") as? [String] {
            list = list.filter {$0 != cbu}
            list.insert(cbu, at: 0)
            UserDefaults.standard.setValue(list, forKey: "cbuList")
            return false
        }
        else {
            UserDefaults.standard.setValue([cbu], forKey: "cbuList")
            return true
        }
    }
    
}
