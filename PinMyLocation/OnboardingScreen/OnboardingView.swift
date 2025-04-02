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
    
    private var onboardingItems: [OnboardingItem] = [
        OnboardingItem(title: "Enable Location \nServices", desc: "Never lose a place you love! Enable location services to easily save and revisit your favorite spots with just a tap.", systemImageName: "map.circle.fill", enableBtnTitle: "Allow Location Access"),
        OnboardingItem(title: "Enable Camera \nPermissions", desc: "Capture the moment! Enable camera access to snap photos of your favorite spots and save them with your pins.", systemImageName: "camera.circle.fill", enableBtnTitle: "Allow Camera Access"),
        OnboardingItem(title: "Enable Photo Gallery \nPermissions", desc: "Keep your memories organized! Enable photo access to attach images from your gallery to your saved locations.", systemImageName: "photo.circle.fill", enableBtnTitle: "Enable Photo Library")
    ]
    
    @State var index = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Image(systemName: onboardingItems[index].systemImageName)
                .font(.system(size: 220))
                .foregroundColor(.blue)
            
            Text(onboardingItems[index].title)
                .font(.system(size: 38))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            VStack(spacing: 40) {
                Text(onboardingItems[index].desc)
                    .font(.title3)
                
                VStack(spacing: 20) {
                    Button {
                        print("Enable location services!")
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.blue)
                                .frame(height: 54)
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
                        }
                    } label: {
                        Text("Skip")
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .padding(.all, 20)
    }
}

#Preview {
    OnboardingView()
}
