//
//  Moody_TreeApp.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/5.
//

import SwiftUI

@main
struct Moody_TreeApp: App {
    @Environment(\.scenePhase) var scenePhase
    private let coreDataStack = CoreDataStack(modelName: "Model")
    private var moodArray: [String] = []
    
    var body: some Scene {
        WindowGroup { 
            ContentView()
                .environmentObject(coreDataStack)
                .environment(\.managedObjectContext, coreDataStack.managedObjectContext)
                .onChange(of: scenePhase) { _ in
                    coreDataStack.save()
                }
                .onAppear(){
                    addQuetes(to: coreDataStack)
                    UserDataManager.shared.resetMonthlyData()
                    Connectivity.shared.$selectedMood
                        .receive(on: DispatchQueue.main)
                        .sink { selectedMood in
                            // 处理接收到的 selectedMood 值
                            // 存储到 UserDefaults 中
                            UserDefaults.standard.setValue(selectedMood, forKey: "todayMood")
                            UserDataManager.shared.updateEmotionCounts(selectedMood: selectedMood)
                        }
                }
        }
    }
}
