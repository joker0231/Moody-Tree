//
//  ConfigPage.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/6.
//

import Foundation
import SwiftUI

struct SettingsItem: View {
    var title: String
    var description: String
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 18))
                .onTapGesture {
                    action()
                }
            Text(description)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
    }
}

struct ConfigPageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isNicknameAlertPresented = false
    @State private var isFeedbackAlertPresented = false
    @State private var isAboutAlertPresented = false
    @State private var isPhotoAlertPresented = false
    @State private var newNickname: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 169/255, green: 196/255, blue: 148/255), .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    VStack {
                        HStack{
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrowshape.left.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("F7FBF6")) // 设置箭头颜色
                                    .padding(.leading)
                                
                                Text("设置")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("F7FBF6"))
                                    .padding(.trailing, 20)
                            }

                            Spacer()
                            
                            // 在这里添加其他控件
                        }
                            .padding(.horizontal)
                        
                        VStack{
                            VStack(alignment: .leading, spacing: 20) {
                                SettingsItem(title: "昵称", description: "昵称"){
                                    // 点击昵称的操作
                                    isNicknameAlertPresented.toggle()
                                }
                                    .padding(.top, 5)
                                SettingsItem(title: "反馈", description: "如果您发现任何错误或者其他问题，请告诉小树噢"){
                                    // 点击反馈的操作
                                    isFeedbackAlertPresented.toggle()
                                }
                                SettingsItem(title: "评价小树", description: "如果你喜欢小树，请给小树5颗星🌟"){
                                    // 点击评价的操作
                                }
                                SettingsItem(title: "关于", description: ""){
                                    // 点击关于的操作
                                    isAboutAlertPresented.toggle()
                                }
                                Spacer()
                            }
                                .padding(20)
                                .cornerRadius(10)
                                .background(Color.white.cornerRadius(10))
                                .overlay(
                                    CustomPopup(
                                        title: "新的名字叫什么好呢？",
                                        content:
                                            TextField("小树的名字", text: $newNickname)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .padding()
                                        ,
                                        isPresented: $isNicknameAlertPresented
                                    )
                                    .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
                                )
                                .overlay(
                                    CustomPopup(
                                        title: "反馈",
                                        content: Text("如果有任何问题，请发送邮件到xxxxx@qq.com，开发者会马不停蹄的处理掉一切BUG！"),
                                        isPresented: $isFeedbackAlertPresented
                                    )
                                    .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
                                )
                                .overlay(
                                    CustomPopup(
                                        title: "关于",
                                        content:
                                            VStack(spacing: 5){
                                                Text("🍃你能告诉我更多关于Moody Tree和你的事情吗？")
                                                    .padding(.bottom,5)
                                                Text("👆我的名字是crystal，目前是中国华中师范大学的一名大四学生。Moody Tree作为我的毕业设计诞生于2023年，设计它的初衷是由于在毕业寻找工作的过程中遭受了一些负面情绪的困扰，也因此产生了一些心理问题，我希望能够有这样的一个软件能够帮助到更多和我一样有类似困扰的人们。")
                                                    .padding(.bottom,15)
                                                Text("🍃我喜欢Moody Tree，我能做些什么来支持它？")
                                                    .padding(.bottom,5)
                                                Text("👆首先感谢您的支持，支持小树最棒的方式是与您的朋友，家人或者任何需要帮助的人们分享它，在APP Store中留下五星评价也能够帮助其他用户发现Moody Tree。")
                                                    .padding(.bottom,15)
                                                Text("🍃我想让Moody Tree变得更好，如何告诉你呢？")
                                                    .padding(.bottom,5)
                                                Text("👆您可以发送邮件到xxxxxx@qq.com向我发送反馈噢。")
                                            }
                                                .multilineTextAlignment(.leading),
                                        isPresented: $isAboutAlertPresented
                                    )
                                    .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
                                )
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct ConfigPageView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigPageView()
    }
}
