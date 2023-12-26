//
//  CustomPopup.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/7.
//

import Foundation
import SwiftUI

struct CustomPopup<Content: View>: View {
    var title: String
    var content: Content
    var isPresented: Binding<Bool>
    var onConfirm: (() -> Void)?
    var buttonText: String

    var body: some View {
        ZStack {
            if isPresented.wrappedValue {
                Color.gray.opacity(0.5)
                    .edgesIgnoringSafeArea(.top)
                    .onTapGesture {
                        // 点击灰色部分关闭弹窗
                        isPresented.wrappedValue.toggle()
                    }

                VStack(spacing: 10) {
                    Text(title)
                        .font(.system(size: 20))
                        .padding(.top,20)
                        .foregroundColor(Color.black)
                    
                    content
                    .font(.body)
                    .padding(.horizontal)
                    .foregroundColor(Color.black)
                    

                    Button(buttonText) {
                        // 处理确定按钮点击逻辑
                        onConfirm?() 
                        isPresented.wrappedValue.toggle()
                    }
                    .padding()
                    .cornerRadius(10)
                }
                .frame(width: UIScreen.main.bounds.width - 30)
                .background(Color(red: 246 / 255, green: 251 / 255, blue: 240 / 255))
                .cornerRadius(20)
            }
        }
    }
}

struct CustomPopupView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigPageView()
    }
}
