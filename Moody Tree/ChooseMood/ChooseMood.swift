//
//  ChooseMood.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/8.
//

import Foundation
import SwiftUI

struct ChooseMoodView: View {
    @State private var isSheetPresented = false
    @Binding var selectedMood: String?

    init(selectedMood: Binding<String?>) {
        _selectedMood = selectedMood
    }

    var body: some View {
        VStack {
            Button(action: {
                // 升起弹窗
                isSheetPresented.toggle()
            }) {
                Text(selectedMood != nil ? "今天是\(selectedMood!)的🌲" : "为今天选择心情吧")
                    .font(.system(size: 14))
                    .foregroundColor(Color("F7FBF6"))
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            // 这里放你的底部弹窗的内容
            BottomSheetView(isSheetPresented: $isSheetPresented, selectedMood: $selectedMood)
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.5)])
        }
    }
}

struct BottomSheetView: View {
    @Binding var isSheetPresented: Bool
    @Binding var selectedMood: String?
    @Environment(\.presentationMode) var presentationMode
    let moodOptions = ["棒极了", "美滋滋", "无语", "生气", "焦虑", "冲冲冲", "好难过", "累死了"]

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrowshape.left.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("144805"))
                        .padding(.leading)

                    Text("请选择你的心情")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("144805"))
                        .padding(.trailing, 10)
                }
                Spacer()
            }
            .padding()

            LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 20) {
                ForEach(moodOptions, id: \.self) { mood in
                    Button(action: {
                        selectedMood = mood
                        self.presentationMode.wrappedValue.dismiss()
                        // 在这里处理点击事件
                        print("Selected Mood: \(mood)")
                    }) {
                        VStack {
                            Image(mood)
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width / 4 - 30, height: UIScreen.main.bounds.width / 4 - 30)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            Text(mood.localizedCapitalized)
                                .font(.system(size: 14))
                                .padding(.top, 5)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .cornerRadius(10)
    }


}
