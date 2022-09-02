//
//  ContentView.swift
//  FancyCamera
//
//  Created by 김민재 on 2022/08/30.
//

import SwiftUI

struct ContentView: View {
    @State var isCameraPickerShow = false
    @State var isImagePickerShow = false
    @State private var isFilterSelected = false
    @State private var showsAlert = false

    @State var images: [UIImage] = []
    @State var shareImage: ShareImage?
    @State private var selectedModel: StyleModel = .Filter
    @State private var transferImage: UIImage?
    
    var body: some View {
        VStack {
            Spacer()

            if !images.isEmpty {
                if let selectedImage = images[0] {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.width * 0.7)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                }

                if isFilterSelected {
                    Image(systemName: "x.square")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.width * 0.7)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                } else if let transferImage = transferImage {
                    Image(uiImage: transferImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.width * 0.7)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                }
            }

            Spacer()

            Picker("Select Filter", selection: $selectedModel) {
                ForEach(StyleModel.allCases, id: \.self) { model in
                    Text(model.rawValue)
                }
            }
            .pickerStyle(.automatic)
            .padding()
            .onChange(of: selectedModel, perform: { tag in
                if !images.isEmpty {
                    self.isFilterSelected = true
                    DispatchQueue.global(qos: .userInteractive).async {
                        transferImageStyle(selectedImage: images[0], transferImage: &transferImage, selectedModel: tag)
                        self.isFilterSelected = false
                    }
                }
            })

            HStack {
                Spacer()

                Button(action: {
                        self.isCameraPickerShow.toggle()
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }

                Spacer()

                Button(action: {
                    self.isImagePickerShow.toggle()
                }) {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }

                Spacer()

                if !images.isEmpty {

                    Button(action: {
                        ImageSaver.saveTransferImage(transferImage: transferImage)
                        self.showsAlert.toggle()
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    }
                    .disabled(transferImage == nil)
                    .alert(isPresented: self.$showsAlert) {
                        Alert(title: Text("Image Saved"))
                    }

                    Spacer()

                    Button(action: {
                        self.shareImage = ShareImage(image: transferImage!)
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    }
                    .disabled(transferImage == nil)

                    Spacer()
                }
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isCameraPickerShow, content: {
            CameraPicker(images: $images)
                .ignoresSafeArea()
                .onDisappear() {
                    withAnimation{
                        transferImage = nil
                        selectedModel = .Filter
                    }
                }
        })
        .sheet(isPresented: $isImagePickerShow) {
            ImagePicker(images: $images, selectionLimit: 1)
                .onDisappear() {
                    withAnimation{
                        transferImage = nil
                        selectedModel = .Filter
                    }
                }
        }
        .sheet(item: $shareImage) { shareImage in
            ActivityView(image: shareImage.image)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
