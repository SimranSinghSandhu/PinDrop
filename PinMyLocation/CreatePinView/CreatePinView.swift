//
//  CreatePinView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI
import CoreLocation

struct PinCategory: Identifiable {
    var id: String
    let title: String
    var isSelected: Bool = false
}

struct CreatePinView: View {
    
    @FocusState private var isFocused: Bool
    @State private var title: String = ""
    
    @State private var categories: [PinCategory] = []
    
    @State private var selectedCategoryId: String?
    
    @Binding var myLocation: PinLocation?
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            VStack(spacing: 15) {
                TextField("", text: $title, prompt:
                            Text("Title").foregroundStyle(Color.black)
                    .font(.title)
                    .fontWeight(.medium)
                )
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(Color.black)
                .padding(.horizontal, 16)
                .focused($isFocused)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories) { category in
                            Button {
                                selectedCategoryId = category.id
                            } label:{
                                Text(category.title)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .foregroundStyle(selectedCategoryId == category.id ? Color.black : Color.black)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(selectedCategoryId == category.id ? Color.blue.opacity(0.25) : Color.gray.opacity(0.25))
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Add Image")
                        .foregroundStyle(Color.blue)
                        .font(.title3)
                        .fontWeight(.medium)
                    HStack(alignment: .top, spacing: 20) {
                        Button {
                            print("Adding Image button Tapped")
                        } label: {
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(style: StrokeStyle(lineWidth: 1.0))
                                        .foregroundStyle(Color.gray.opacity(0.7))
                                        .frame(width: 150, height: 150)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.title)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.gray.opacity(0.7))
                                }
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(myLocation?.address ?? "N/A")
                            .foregroundStyle(Color.black)
                            .font(.body)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        Text("\(myLocation?.coordinate.coordinate.latitude ?? 0.0), \(myLocation?.coordinate.coordinate.longitude ?? 0.0)")
                            .foregroundStyle(Color.black)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    Button {
                        print("Save pin button pressed!")
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.blue)
                                .frame(height: 44)
                            Text("Save")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.white)
                        }
                    }
                }
            }.padding(.horizontal, 16)
        }
        .padding(.bottom,20)
        .onAppear() {
            categories = addedCategories()
            isFocused = true
        }
    }
    
    private func addedCategories() -> [PinCategory] {
        return [PinCategory(id: UUID().uuidString, title: "Travel"),
                PinCategory(id: UUID().uuidString, title: "Food"),
                PinCategory(id: UUID().uuidString, title: "Art"),
                PinCategory(id: UUID().uuidString, title: "Sports"),
                PinCategory(id: UUID().uuidString, title: "Cafes"),
                PinCategory(id: UUID().uuidString, title: "Shops"),
                PinCategory(id: UUID().uuidString, title: "Restaurants"),
                PinCategory(id: UUID().uuidString, title: "Gyms/Fitness Centers")]
    }
}

#Preview {
    @Previewable @State var myLocation: PinLocation?
    CreatePinView(myLocation: $myLocation)
}
