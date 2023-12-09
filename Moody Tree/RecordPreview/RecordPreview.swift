//
//  RecordPreview.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/8.
//

import Foundation
import SwiftUI

struct RecordPreviewView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var deleteRecord = false
    var date: String
    var emotionDescription: String
    var title: String
    var description: String
    var imageName: String?
    
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
                                
                                Text("返回")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("F7FBF6"))
                                    .padding(.trailing, 20)
                            }

                            Spacer()
                        }
                            .padding(.horizontal)
                        
                        VStack{
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(date)
                                        .font(.system(size: 14))
                                        .frame(width: 50, alignment: .topLeading)

                                    Spacer()
                                    
                                    VStack{
                                        Text(emotionDescription)
                                            .font(.system(size: 14))
                                            .padding(2)
                                    }
                                    .border(Color.black, width: 1)
                                    .cornerRadius(4)
                                    
                                    Spacer()

                                    HStack{
                                        Button(action: {
                                            deleteRecord.toggle()
                                        }) {
                                            Image(systemName: "trash.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(Color("414F3F"))
                                        }
                                    }
                                    .frame(width: 50)
                                }
                                .padding(.top,20)

                                Text(title)
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .topLeading)
                                    .multilineTextAlignment(.leading)

                                Text(description)
                                    .font(.system(size: 16))
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6, alignment: .topLeading)
                                    .lineLimit(nil)
                                    .overlay(
                                        imageName.map {
                                            Image($0)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 300, height: 200)
                                        }
                                    )
                                    .cornerRadius(5)
                                
                                Spacer()
                            }
                            .padding(20)
                            .cornerRadius(10)
                            .background(Color.white.cornerRadius(10))
                        }
                        .padding(.horizontal)
                        .frame(height: UIScreen.main.bounds.height * 0.9)
                        .overlay(
                            CustomPopup(
                                title: "🌱",
                                content: Text("确定要删除这条记录吗？"),
                                isPresented: $deleteRecord
                            )
                            .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
                        )
                    }
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct RecordPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPreviewView(
            date: "12-15",
            emotionDescription: "Happy",
            title: "Sample Title",
            description: "This is a sample description. It can be a long text that users input, and it should support line breaks and scrolling if the content is too long. Also, it may contain an image.",
            imageName: "sampleImage"
        )
    }
}
