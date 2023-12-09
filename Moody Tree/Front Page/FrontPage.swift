//
//  FrontPage.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/5.
//

import Foundation
import SwiftUI

struct FrontPageView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 169/255, green: 196/255, blue: 148/255), .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("MOODY TREE")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 246/255, green: 251/255, blue: 240/255))
                    .padding(.top, 20)

                Spacer().frame(height: 330)  // Placeholder for ARkit tree model

                CardView()
                    .padding(30)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                PlusButton()
                    .offset(x:10, y:-65)
            }
        }
    }
}

struct FrontPageView_Previews: PreviewProvider {
    static var previews: some View {
        FrontPageView()
    }
}
