//
//  CameraView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 03/04/25.
//

import SwiftUI

struct CameraView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var cameraManager = CameraManager()
    @State private var capturedImage: UIImage? = nil
    @State private var isShowingPreviewImage = false
    
    @State private var dragOffset: CGSize = .zero
    @State private var dragOpacity: Double = 1.0

    @Binding var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            CameraPreview(cameraManager: cameraManager)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Button {
                    cameraManager.capturePhoto { image in
                        if let image = image {
                            DispatchQueue.main.async {
                                self.capturedImage = image
                                self.isShowingPreviewImage = true
                                self.dragOffset = .zero  // Reset drag offset
                                self.dragOpacity = 1.0  // Reset opacity
                                self.cameraManager.stopSession()
                            }
                        }
                    }
                } label: {
                    Circle()
                        .foregroundStyle(Color.white)
                        .frame(width: 80)
                        .overlay {
                            Circle()
                            .stroke(style: StrokeStyle(lineWidth: 6))
                            .foregroundStyle(Color.black)
                            .padding(6)
                        }
                }
            }
            VStack {
                HStack {
                    Button {
                        print("close btn tapped")
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color.gray)
                                .frame(width: 44)
                            Image(systemName: "xmark")
                                .foregroundStyle(Color.white)
                        }
                    }
                    Spacer()
                }.padding(.leading, 16)
                Spacer()
            }
            
            if let image = capturedImage {
                ZStack {
//                    Rectangle()
//                        .foregroundStyle(Color.black)
                    ImagePreviewView(image: image) {
                        self.capturedImage = nil  // Dismiss
                        self.cameraManager.startSession()
                    } doneCompletion: {
                        self.selectedImage = self.capturedImage
                        self.capturedImage = nil  // Dismiss
                        self.cameraManager.startSession()
                        self.dismiss()
                    }
                    .offset(y: dragOffset.height)
                    .animation(.interactiveSpring(), value: dragOffset)
                    .opacity(dragOpacity)
                    .animation(.linear(duration: 0.1), value: dragOpacity)
                }
//                .edgesIgnoringSafeArea(.all)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translation = value.translation.height
                            if translation > 0 { // Only drag down
                                dragOffset = CGSize(width: 0, height: translation)
                                dragOpacity = max(1.0 - (translation / 300), 0.5)
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 150 { // If dragged far enough
                                capturedImage = nil  // Dismiss
                                cameraManager.startSession()
                            } else {
                                // Reset animation if not dragged far enough
                                withAnimation(.spring()) {
                                    dragOffset = .zero
                                    dragOpacity = 1.0
                                }
                            }
                        }
                )
            }
        }
        .onDisappear() {
            cameraManager.stopSession()
        }
    }
}

#Preview {
    CameraView(selectedImage: .constant(nil))
}
