//
//  LocaitonPinView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI
import SwiftData

@Model
class LocationPinItem {
    @Attribute(.unique) var id: String = UUID().uuidString
    var title: String
    var category: String?
    var imageData: Data?
    var createdDate: Date
    var lat: Double
    var lng: Double
    var isFav: Bool = false
    
    init(title: String, category: String?, image: UIImage?, createdDate: Date, lat: Double, lng: Double, isFav: Bool = false) {
        self.title = title
        self.category = category
        self.imageData = image?.jpegData(compressionQuality: 0.8) // Convert UIImage to Data
        self.createdDate = createdDate
        self.lat = lat
        self.lng = lng
        self.isFav = isFav
    }
    
    func getImage() -> UIImage? {
        if let data = imageData {
            return UIImage(data: data) // Convert Data back to UIImage
        }
        return nil
    }
}

struct LocationPinView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var swiftDataManager = SwiftDataManager()
    @Binding var locationItem: LocationPinItem
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 10) {
                Image(uiImage: locationItem.getImage() ?? UIImage(named: "dochiin")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(locationItem.title)
                            .foregroundStyle(.primary)
                            .fontWeight(.bold)
                        Text(locationItem.category ?? "Default")
                            .foregroundStyle(.primary)
                    }
                    Text("Added on \(formattedDate(date: locationItem.createdDate))")
                        .font(.caption)
                }
                Spacer()
                ZStack(alignment: .trailing) {
                    Button {
                        print("isFav Toggle")
                        swiftDataManager.updateItem(for: locationItem, modelContext: modelContext)
                    } label: {
                        Image(systemName: locationItem.isFav ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundStyle(locationItem.isFav ? Color.red : Color.black)
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Format: Jan 15, 2025
        return formatter.string(from: date)
    }
}

#Preview {
    LocationPinView(locationItem: .constant(LocationPinItem(title: "Dummy", category: nil, image: nil, createdDate: Date(), lat: 0.0, lng: 0.0)))
}
