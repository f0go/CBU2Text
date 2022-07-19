//
//  ViewController.swift
//  CBU2Text
//
//  Created by f0go on 24/05/2021.
//

import UIKit
import MobileCoreServices
import StoreKit

class MainViewController: UIViewController {

    private var cameraUI = UIImagePickerController()
    private let mainViewModel = MainViewModel()

    @IBAction func selectImage(_ sender: UIButton) {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.mediaTypes = [kUTTypeImage as String]
        cameraUI.allowsEditing = false
        present(cameraUI, animated: true, completion: nil)
    }
    
    func processImage(cgImage: CGImage) {
        self.mainViewModel.processImage(image: cgImage) { [weak self] cbu, rateApp in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            if let cbu = cbu {
                alert.title = "✅"
                alert.message = "El CBU \(cbu) ya esta copiado"
                let accept = UIAlertAction(title: "Aceptar", style: .default) { _ in
                    if rateApp {
                        SKStoreReviewController.requestReview()
                    }
                }
                alert.addAction(accept)
            } else {
                alert.title = "❌"
                alert.message = "No se pudo encontrar el CBU"
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            }
            self?.present(alert, animated: true)
        }
    }
    
    func showImageErrorMessage() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        let alert = UIAlertController(title: "❌", message: "Se produjo un error al procesar la imagen", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let cgImage = image.cgImage {
                self.processImage(cgImage: cgImage)
            }
            else {
                self.showImageErrorMessage()
            }
        }
    }
}
