//
//  ImagePicker.swift
//  vennu
//
//  Created by Ina Statkic on 01/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {
    func picked(_ image: UIImage)
}

class ImagePicker: NSObject {
    let imagePickerController: UIImagePickerController
    private weak var delegate: ImagePickerDelegate?
    
    init(vc: UIViewController, delegate: ImagePickerDelegate) {
        self.imagePickerController = UIImagePickerController()
        super.init()
        self.delegate = delegate
        self.imagePickerController.delegate = self
        self.imagePickerController.view.tintColor = .coralRed
        self.imagePickerController.modalPresentationStyle = .overFullScreen
        self.imagePickerController.mediaTypes = ["public.image"]
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.delegate?.picked(image)
        self.imagePickerController.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
