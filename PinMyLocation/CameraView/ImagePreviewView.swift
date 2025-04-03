//
//  ImagePreviewView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 03/04/25.
//

import SwiftUI

struct ImagePreviewView: View {
    
    var image: UIImage
    let closeCompletion: () -> Void?
    let doneCompletion: () -> Void?
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.black)
                .ignoresSafeArea()
            VStack{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            VStack {
                HStack {
                    Button {
                        print("Close btn tapped")
                        closeCompletion()
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color.gray)
                                .frame(width: 44)
                            Image(systemName: "xmark")
                                .foregroundStyle(Color.white)
                        }
                    }
                    Spacer()
                    Button {
                        print("Done btn tapped")
                        doneCompletion()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color.blue)
                                .frame(width: 80, height: 44)
                            Text("Done")
                                .foregroundStyle(Color.white)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
    
}

#Preview {
    let image = UIImage(named: "dochiin")
    ImagePreviewView(image: image!, closeCompletion: {}, doneCompletion: {})
}
