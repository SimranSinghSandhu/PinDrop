//
//  CameraManager.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 03/04/25.
//

import AVFoundation
import SwiftUI

class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    private let session = AVCaptureSession()

    @Published var previewLayer: AVCaptureVideoPreviewLayer?
        
    private var photoOutput = AVCapturePhotoOutput() // ✅ Photo output
    @Published var capturedImage: UIImage? // ✅ Store captured image
    var photoCaptureCompletion: ((UIImage?) -> Void)?

    override init() {
        super.init()
        setupCamera()
    }
    
    func setupCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            print("📷 Setting up Camera")
            
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device) else {
                print("❌ No available back camera")
                return
            }
            
            // Remove old inputs
            for oldInput in self.session.inputs {
                self.session.removeInput(oldInput)
            }
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
                print("✅ Camera input added")
            }
            
            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput)
                print("✅ Photo output added")
            }
            
            self.session.commitConfiguration()
            
            // Start session
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
                print("🚀 Camera session started")
                
                DispatchQueue.main.async {
                    let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    previewLayer.videoGravity = .resizeAspectFill
                    self.previewLayer = previewLayer  // 🔥 This will trigger a SwiftUI update
                    print("✅ Preview Layer Set")
                }
            }
        }
    }

    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return previewLayer
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        photoOutput.capturePhoto(with: settings, delegate: self)
        print("📸 Capturing photo...")

        self.photoCaptureCompletion = completion
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            print("❌ Error capturing photo: \(error?.localizedDescription ?? "Unknown error")")
            photoCaptureCompletion?(nil)
            return
        }

        DispatchQueue.main.async {
            print("✅ Photo captured successfully")
            self.photoCaptureCompletion?(image)
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let previewLayer = cameraManager.previewLayer else {
                print("⏳ Waiting for preview layer to be set...")
                return
            }

            if previewLayer.superlayer !== uiView.layer {
                previewLayer.frame = uiView.bounds
                uiView.layer.addSublayer(previewLayer)
                print("🎥 Preview Layer Added to View")
            } else {
                print("⚠️ Preview Layer already exists in View, skipping duplicate add")
            }
        }
    }
}
