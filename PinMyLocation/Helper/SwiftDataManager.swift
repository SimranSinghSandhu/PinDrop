//
//  SwiftDataManager.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 04/04/25.
//

import SwiftUI
import SwiftData

struct SwiftDataManager {
    
    func saveItem(for item: LocationPinItem, modelContext: ModelContext) {
        modelContext.insert(item)
        print("Pin Saved!")
        
        // 🛠 Debug: Check if items exist
        let allPins = try? modelContext.fetch(FetchDescriptor<LocationPinItem>())
        print("All Pins:", allPins?.count ?? "No Pins Found")
    }
    
    func deleteItem(for item: LocationPinItem, modelContext: ModelContext) {
        modelContext.delete(item)
    }
    
    func updateItem(for item: LocationPinItem, modelContext: ModelContext) {
        item.isFav.toggle()
        try? modelContext.save()
    }
}
