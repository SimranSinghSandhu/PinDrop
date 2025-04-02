//
//  LocaitonPinView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI

struct LocationPinView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 10) {
                Image("dochiin")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Dochi")
                            .foregroundStyle(.primary)
                            .fontWeight(.bold)
                        Text("Resturaunt")
                            .foregroundStyle(.primary)
                    }
                    Text("Added on 25th Jan, 2025")
                        .font(.caption)
                }
                Spacer()
                ZStack(alignment: .trailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "heart")
                            .font(.title3)
                            .foregroundStyle(Color.black)
                    }
                    
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color.white) // Ensure a visible background
        .clipShape(RoundedRectangle(cornerRadius: 12)) // Optional: Rounded corners
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    LocationPinView()
}
