//
//  CoreDataStack.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/9.
//

import Foundation
import CoreData
import PhotosUI

class CoreDataStack: ObservableObject  {
    private var persistentContainer: NSPersistentContainer
    let localDate = Date().addingTimeInterval(TimeInterval(TimeZone(identifier: "Asia/Shanghai")?.secondsFromGMT(for: Date()) ?? 0))
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(modelName: String){
        persistentContainer = {
            let container = NSPersistentContainer(name: modelName)
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
    }
    
    func save() {
        guard managedObjectContext.hasChanges else {return}
        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func insertQuote(content: String, author: String,source: String) {
        let quote = Quote(context: managedObjectContext)
        quote.content = content
        quote.author = author
        quote.source = source
    }
    
    func saveUserMood(title: String, descriptionText: String, mood: String, selectedImages: [UIImage]) {
        let userMood = UserMood(context: managedObjectContext)
        userMood.title = title
        userMood.descriptionText = descriptionText
        userMood.timestamp = localDate
        userMood.mood = mood
        let imageDataArray = selectedImages.map { $0.jpegData(compressionQuality: 1.0) }
        if !imageDataArray.isEmpty {
            userMood.images = imageDataArray as NSObject
        }
        // 生成并设置 UUID
        userMood.id = UUID()
    }
    
    func saveUserNote(title: String, descriptionText: String, selectedImages: [UIImage]) {
        let userNote = UserNote(context: managedObjectContext)
        userNote.title = title
        userNote.descriptionText = descriptionText
        userNote.timestamp = localDate
        let imageDataArray = selectedImages.map { $0.jpegData(compressionQuality: 1.0) }
        if !imageDataArray.isEmpty {
            userNote.images = imageDataArray as NSObject
        }
        // 生成并设置 UUID
        userNote.id = UUID()
    }
}
 
