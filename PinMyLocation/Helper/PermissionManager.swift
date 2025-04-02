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

class PermissionManager: NSObject, ObservableObject {
    
    @Published var cameraAuthorized = false
    @Published var photoLibraryAuthorized = false
    
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?

    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestCameraPermissions() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func requestPhotoLibraryPermissions() async -> Bool {
        return await withCheckedContinuation {
            continuation in
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                DispatchQueue.main.async {
                    self.photoLibraryAuthorized = (status == .authorized || status == .limited)
                }
            }
        }
    }
    
    public func requestAuthorisation(always: Bool = false) async -> CLAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            self.authorizationContinuation = continuation  // Store continuation for later use
            
            if always {
                self.locationManager.requestAlwaysAuthorization()
            } else {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func checkPermissions() {
        cameraAuthorized = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        photoLibraryAuthorized = PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .limited
    }
}

extension PermissionManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorisationStatus = status
            self.authorizationContinuation?.resume(returning: status)
            self.authorizationContinuation = nil
        }
    }
}
