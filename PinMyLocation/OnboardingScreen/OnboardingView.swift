//
//  OnboardingView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 02/04/25.
//

import SwiftUI

struct OnboardingItem: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var desc: String
    var systemImageName: String
    var enableBtnTitle: String
}

struct OnboardingView: View {
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    @State private var permissionManager = PermissionManager()
    
    private var onboardingItems: [OnboardingItem] = [
        OnboardingItem(title: "Unlock Location\nFeatures", desc: "Never lose a place you love! Enable location services to easily save and revisit your favorite spots with just a tap.", systemImageName: "map.circle.fill", enableBtnTitle: "Allow Location Access"),
        OnboardingItem(title: "Grant Camera\nPermission", desc: "Capture the moment! Enable camera access to snap photos of your favorite spots and save them with your pins.", systemImageName: "camera.circle.fill", enableBtnTitle: "Allow Camera Access"),
        OnboardingItem(title: "Enable Photo\nAccess", desc: "Keep your memories organized! Enable photo access to attach images from your gallery to your saved locations.", systemImageName: "photo.circle.fill", enableBtnTitle: "Enable Photo Library")
    ]
    
    @State var index = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Image(systemName: onboardingItems[index].systemImageName)
                .font(.system(size: 200))
                .foregroundColor(.blue)
            
            Text(onboardingItems[index].title)
                .font(.system(size: 34))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 40) {
                Text(onboardingItems[index].desc)
                    .font(.title3)
                
                VStack(spacing: 20) {
                    Button {
                        print("Requesting Permissions")
                        if index == 0 {
                            Task {
                                let granted = await  permissionManager.requestAuthorisation()
                                print("Granted =", granted)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    index += 1
                                }
                            }
                        } else if index == 1 {
                            Task {
                                let _ = await permissionManager.requestCameraPermissions()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    self.index += 1
                                }
                            }
                        } else {
                            Task {
                                let _ = await permissionManager.requestPhotoLibraryPermissions()
                                hasSeenOnboarding = true
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.blue)
                                .frame(height: 44)
                            
                            Text(onboardingItems[index].enableBtnTitle)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.white)
                        }
                    }
                    
                    Button {
                        if self.index < (onboardingItems.count - 1) {
                            self.index += 1
                        } else {
                            print("Show map screen now!")
                            hasSeenOnboarding = true
                        }
                    } label: {
                        Text("Skip")
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .padding(.all, 20)
        .onAppear {
            permissionManager.checkPermissions()
        }
    }
}

#Preview {
    OnboardingView()
}
