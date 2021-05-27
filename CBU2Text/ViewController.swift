//
//  ViewController.swift
//  CBU2Text
//
//  Created by f0go on 24/05/2021.
//

import UIKit
import MobileCoreServices
import Vision
import StoreKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var cameraUI = UIImagePickerController()
    var request: VNRecognizeTextRequest!

    @IBAction func selectImage(_ sender: UIButton) {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.mediaTypes = [kUTTypeImage as String]
        cameraUI.allowsEditing = false
        self.present(cameraUI, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let cgImage = image.cgImage {
                self.processImage(cgImage: cgImage)
            }
            else {
                self.showErrorMessage()
            }
        }
    }
    
    func processImage(cgImage: CGImage) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        do {
            try requestHandler.perform([request])
        } catch {
            showErrorMessage()
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        for text in recognizedStrings {
            if (text.range(of: "\\d{22}", options: .regularExpression) != nil) {
                let cbu = text.substring(with: text.range(of: "\\d{22}", options: .regularExpression)!)
                UIPasteboard.general.string = cbu
                var showRateApp = false
                if var list = UserDefaults.standard.value(forKey: "cbuList") as? [String] {
                    list = list.filter {$0 != cbu}
                    list.insert(cbu, at: 0)
                    UserDefaults.standard.setValue(list, forKey: "cbuList")
                }
                else {
                    showRateApp = true
                    UserDefaults.standard.setValue([cbu], forKey: "cbuList")
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                let alert = UIAlertController(title: "✅", message: "El CBU \(cbu) ya esta copiado", preferredStyle: .alert)
                let accept = UIAlertAction(title: "Aceptar", style: .default) { _ in
                    if showRateApp {
                        SKStoreReviewController.requestReview()
                    }
                }
                alert.addAction(accept)
                return present(alert, animated: true, completion: nil)
            }
        }
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        let alert = UIAlertController(title: "❌", message: "No se pudo encontrar el CBU", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        return present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        let alert = UIAlertController(title: "❌", message: "Se produjo un error al procesar la imagen", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

