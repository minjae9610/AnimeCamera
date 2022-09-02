//
//  ShareView.swift
//  FancyCamera
//
//  Created by 김민재 on 2022/09/02.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    let image: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [image], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

struct ShareImage: Identifiable {
    let id = UUID()
    let image: UIImage
}
