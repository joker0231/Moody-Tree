//
//  chooseMood.swift
//  MoodyTree watch Watch App
//
//  Created by 王雨晨 on 2023/12/14.
//

import Foundation
import SwiftUI
import WatchKit
import WatchConnectivity

struct MoodSelectionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let moodOptions = ["棒极了", "美滋滋", "无语", "生气", "焦虑", "冲冲冲", "好难过", "累死了"]
    @State var selectedMood: String?
    @State private var showAlert = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Text("已选择心情：\(selectedMood ?? "暂无")")
                .font(.system(size: 15))
                .foregroundColor(.white)
                .padding(.top, 40)
            ScrollView {
                moodItems
            }
            .frame(width: watchWidth,height: watchHeight * 0.55)

            Button(action: {
                // 处理保存按钮点击逻辑
                saveButtonTapped()
            }) {
                Text("保存")
                    .font(.system(size: 17))
                    .foregroundColor(.white)
            }
            .frame(width: watchWidth * 0.8 ,height: watchHeight * 0.2)
        }
        .background(Color(red: 132/255, green: 155/255, blue: 128/255))
        .frame(width: watchWidth, height: watchHeight)
        .padding(.vertical,40)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("🔔"), message: Text(errorMessage ?? "网络错误，请稍后重试").font(.system(size: 16)), dismissButton: .default(Text("好的")))
        }
    }

    var moodItems: some View {
        // 这里根据你的实际需求生成八个心情选项的 Item
        ForEach(moodOptions, id: \.self) { mood in
            Button(action: {
                selectedMood = mood
                // 在这里处理点击事件
                print("watch Selected Mood: \(mood)")
            }) {
                VStack {
                    Image(mood)
                        .resizable()
                        .scaledToFit()
                        .frame(width: watchHeight * 0.55, height: watchHeight * 0.55)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    Text(mood.localizedCapitalized)
                        .font(.system(size: 17))
                        .padding(.top, 5)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    var watchHeight: CGFloat {
        return WKInterfaceDevice.current().screenBounds.size.height
    }

    var watchWidth: CGFloat {
        return WKInterfaceDevice.current().screenBounds.size.width
    }

    func saveButtonTapped() {
        let msg = Connectivity.shared.send(selectedMood: selectedMood ?? "")
        if msg != "发送成功" {
            self.showAlert = true
            self.errorMessage = msg
            return
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}
