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
    @Published var userLocation: CLLocation?  // Stores the user's current location
    
    private let geocoder = CLGeocoder()
    
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
                continuation.resume(returning: (status == .authorized || status == .limited))
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
    
    func fetchUserLocation() async -> CLLocation? {
        print("Fetching user location")
        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.startUpdatingLocation()
        }
    }
    
    func checkPermissions() {
        cameraAuthorized = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        photoLibraryAuthorized = PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .limited
    }
    
    func fetchAddress(from location: CLLocation) async -> String? {
        return await withCheckedContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first {
                    let address = [
                        placemark.name,
                        placemark.locality,
                        placemark.administrativeArea,
                        placemark.country
                    ]
                        .compactMap { $0 }
                        .joined(separator: ", ")
                    
                    continuation.resume(returning: address)
                } else {
                    continuation.resume(returning: "Address not found")
                }
            }
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.userLocation = locations.last  // Get the most recent location
            print("Got user location")
            self.locationManager.stopUpdatingLocation()
            
            self.locationContinuation?.resume(returning: locations.last)
            self.locationContinuation = nil
        }
    }
}
