//
//  PermissionManager.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 02/04/25.
//

import Photos
import SwiftUI
import AVFoundation
import CoreLocation

class PermissionManager: ObservableObject {
    
    @Published var cameraAutherized = false
    @Published var photoLibraryAutherized = false
    @Published var locationAutherized = false
    
    func requestCameraPermissions() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraAutherized = granted
            }
        }
    }
    
    func requestPhotoLibraryPermissions() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                self.photoLibraryAutherized = (status == .authorized || status == .limited)
            }
        }
    }
    
    func checkPermissions() {
        cameraAutherized = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        photoLibraryAutherized = PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .limited
    }
}
