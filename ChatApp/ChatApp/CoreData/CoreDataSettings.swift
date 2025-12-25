//
//  CoreDataSettings.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import Foundation
import CoreData

class CoreDataSettings: ObservableObject {
    static let shared: CoreDataSettings = {
        let container = NSPersistentContainer(name: "ChatApp")
        
        container.loadPersistentStores { _, error in
            if let error = error {
#if DEBUG
                fatalError("Failed to load Core Data stack: \(error)")
#endif
            }
        }
        return CoreDataSettings(container: container)
    }()
    
    
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func deleteAllEntities(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(deleteRequest)
            saveData()
        } catch {
        }
    }
    
    func fetchEntities<T: NSManagedObject>(_ entity: T.Type) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: entity))
        do {
            return try container.viewContext.fetch(request)
        } catch {
#if DEBUG
            print("fetch error")
#endif
            return []
        }
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
        } catch {
#if DEBUG
            fatalError()
#endif
        }
    }
}
