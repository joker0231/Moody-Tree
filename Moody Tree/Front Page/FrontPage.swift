//
//  FrontPage.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/5.
//

import Foundation
import SwiftUI

struct FrontPageView: View {
    @State private var isARViewPresented = false
    @State private var model:String?
    
    func chooseModel(){
        let monthlyData = UserDataManager.shared.getMonthlyData()
        let totalCount = monthlyData["totalCount"]
        let validEmotions = ["happyCount", "excitedCount", "fightingCount", "sadCount", "speechlessCount", "angryCount", "tiredCount", "exhaustedCount"]

        if totalCount! < 4 {
            model = "happy"
            return
        }
        if totalCount! < 7 {
            model = "mid"
            return
        }
        guard let maxMoodKey = validEmotions.max(by: { monthlyData[$0]! < monthlyData[$1]! }) else {
            model = "begin"
            return
        }
        
        let emotions = ["happyCount": "happy", "excitedCount": "excited", "fightingCount": "fighting", "sadCount": "sad", "speechlessCount": "speechless", "angryCount": "angry", "tiredCount": "tired", "exhaustedCount": "exhausted"]
        model = emotions[maxMoodKey] ?? "begin"
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 169/255, green: 196/255, blue: 148/255), .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("MOODY TREE")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 246/255, green: 251/255, blue: 240/255))
                    .padding(.top, 45)

                ModelViewer(modelName: model ?? "begin")
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                
                Button(action: {
                    isARViewPresented.toggle()
                }) {
                    Text("AR Show")
                        .padding()
                        .background(Color(red: 132/255, green: 155/255, blue: 128/255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 16))
                        .frame(height: UIScreen.main.bounds.height * 0.05)
                }
                .sheet(isPresented: $isARViewPresented, content: {
                    ARModelViewer(model: self.$model)
                })
                
                CardView()
                    .padding(.horizontal,30)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(height: UIScreen.main.bounds.height * 0.37)

                PlusButton()
                    .offset(x:10, y:-65)
            }
        }
        .onAppear{
            chooseModel()
        }
    }
}

struct FrontPageView_Previews: PreviewProvider {
    static var previews: some View {
        FrontPageView()
    }
}
