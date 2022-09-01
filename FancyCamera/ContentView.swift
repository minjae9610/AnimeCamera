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
    @State private var selectedModel: StyleModel = .필터
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

            Picker("필터 선택", selection: $selectedModel) {
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

                Button("사진 찍기") {
                    self.isCameraPickerShow.toggle()
                }

                Spacer()

                Button("이미지 선택") {
                    self.isImagePickerShow.toggle()
                }

                Spacer()

                if !images.isEmpty {

                    Button("이미지 저장") {
                        ImageSaver.saveTransferImage(transferImage: transferImage)
                        self.showsAlert.toggle()
                    }
                    .disabled(transferImage == nil)
                    .alert(isPresented: self.$showsAlert) {
                        Alert(title: Text("이미지가 앨범에 저장되었습니다."))
                    }

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
                        selectedModel = .필터
                    }
                }
        })
        .sheet(isPresented: $isImagePickerShow) {
            ImagePicker(images: $images, selectionLimit: 1)
                .onDisappear() {
                    withAnimation{
                        transferImage = nil
                        selectedModel = .필터
                    }
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
