//
//  ImageSaver.swift
//  FancyCamera
//
//  Created by 김민재 on 2022/08/31.
//

import SwiftUI

class ImageSaver {
    static func saveTransferImage(transferImage: UIImage?) {
        guard let transferImage = transferImage else {
            return
        }
        print(transferImage.size)
        UIImageWriteToSavedPhotosAlbum(transferImage, nil, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save Finished!")
    }
}
