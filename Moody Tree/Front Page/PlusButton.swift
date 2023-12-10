//
//  PlusButton.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/5.
//

import Foundation
import SwiftUI

struct PlusButton: View {
    @State private var isPopoverPresented = false

    var body: some View {
        HStack(spacing: 17){
            HStack(spacing: 30) {
                NavigationLink(destination: CreatePageView(title: "心情")) {
                    Text("心情")
                }
                Divider()
                    .frame(height: 45)
                    .background(Color(red: 123 / 255, green: 139 / 255, blue: 111 / 255))
                
                NavigationLink(destination: CreatePageView(title: "随笔记")) {
                    Text("随笔记")
                }
            }
            .frame(width: 230, height: 55)
            .background(Color(red: 132/255, green: 155/255, blue: 128/255))
            .foregroundColor(.white)
            .offset(x: isPopoverPresented ? 0 : 230, y: 0)
            .opacity(isPopoverPresented ? 1 : 0)
            .cornerRadius(25)
            
            Button(action: {
                withAnimation {
                    isPopoverPresented.toggle()
                }
            }) {
                VStack {
                    Text("+")
                        .font(.system(size: 50))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                }
                .background(Color(red: 132/255, green: 155/255, blue: 128/255))
                .cornerRadius(25)
            }
            .offset(x: 0, y: 0)
            .zIndex(10)
        }
    }
}

struct PlusButton_Previews: PreviewProvider {
    static var previews: some View {
        PlusButton()
    }
}
