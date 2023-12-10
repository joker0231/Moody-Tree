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
                }
        }
    }
}
