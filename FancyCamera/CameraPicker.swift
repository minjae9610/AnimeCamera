//
//  CameraPicker.swift
//  FancyCamera
//
//  Created by 김민재 on 2022/09/01.
//

import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {

    @Binding var images: [UIImage]
    @Environment(\.presentationMode) var isPresented

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: CameraPicker
    
    init(picker: CameraPicker) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }

        guard let cgimage = selectedImage.cgImage else {
            return
        }

        let imageLength = min(cgimage.width, cgimage.height)
        let xOffset = (cgimage.width - imageLength) / 2
        let yOffset = (cgimage.height - imageLength) / 2

        self.picker.images.removeAll()
        self.picker.images = Array(repeating: UIImage(), count: 1)
        self.picker.images[0] = UIImage(cgImage: (cgimage.cropping(to: CGRect(x: xOffset, y: yOffset, width: imageLength, height: imageLength)))!, scale: selectedImage.scale, orientation: selectedImage.imageOrientation)
        
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}
