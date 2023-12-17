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
    
    func chooseModel() -> String {
        let monthlyData = UserDataManager.shared.getMonthlyData()
        let totalCount = monthlyData["totalCount"]
        let validEmotions = ["happyCount", "excitedCount", "fightingCount", "sadCount", "speechlessCount", "angryCount", "tiredCount", "exhaustedCount"]

        if totalCount! < 5 { return "begin" }
        guard let maxMoodKey = validEmotions.max(by: { monthlyData[$0]! < monthlyData[$1]! }) else {
            return "begin"
        }
        
        let emotions = ["happyCount": "happy", "excitedCount": "excited", "fightingCount": "fighting", "sadCount": "sad", "speechlessCount": "speechless", "angryCount": "angry", "tiredCount": "tired", "exhaustedCount": "exhausted"]
        
        return emotions[maxMoodKey] ?? "begin"
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 169/255, green: 196/255, blue: 148/255), .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("MOODY TREE")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 246/255, green: 251/255, blue: 240/255))
                    .padding(.top, 20)

                ModelViewer(modelName: chooseModel())
                    .frame(height: UIScreen.main.bounds.height * 0.35)
                    .navigationBarTitle("3D Model Viewer", displayMode: .inline)
                
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
                    ARModelViewer(modelName: chooseModel())
                })
                
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
