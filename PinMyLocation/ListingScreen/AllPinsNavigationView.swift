//
//  AllPinsNavigationView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI

struct AllPinsNavigationView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Saved Pins")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    print("Saved Pins button Pressed!")
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 50)
                            .foregroundStyle(Color.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.red)
                    }
                }
            }
        }.padding(.horizontal, 16)
    }
}

#Preview {
    AllPinsNavigationView()
}
