import SwiftUI

import CoreData

struct PersistanceController {
    static let shared = PersistanceController()
    
    static var preview: PersistanceController = {
        let result = PersistanceController(inMemory: true)
        let viewContext = result.container.viewContext
//        for index in 0..<10 {
//            
//        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        
        let clubEntity = NSEntityDescription()
        clubEntity.name = "Club"
        clubEntity.managedObjectClassName = "Club"
        
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.type = .uuid
        clubEntity.properties.append(idAttribute)
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        clubEntity.properties.append(nameAttribute)
        
        let putterAttribute = NSAttributeDescription()
        putterAttribute.name = "putter"
        putterAttribute.type = .boolean
        clubEntity.properties.append(putterAttribute)
        
        let strokesNumAttribute = NSAttributeDescription()
        strokesNumAttribute.name = "strokes"
        strokesNumAttribute.type = .integer32
        clubEntity.properties.append(strokesNumAttribute)
        
        let strokesListAttribute = NSAttributeDescription()
        strokesListAttribute.name = "strokesList"
        strokesListAttribute.type = .transformable
        clubEntity.properties.append(strokesListAttribute)
        
        let hiddenAttribute = NSAttributeDescription()
        hiddenAttribute.name = "hidden"
        hiddenAttribute.type = .boolean
        clubEntity.properties.append(hiddenAttribute)
        
        /////////////////////////////////
        
        let gameEntity = NSEntityDescription()
        gameEntity.name = "Game"
        gameEntity.managedObjectClassName = "Game"
        
        let puttsAttribute = NSAttributeDescription()
        puttsAttribute.name = "putts"
        puttsAttribute.type = .integer32
        gameEntity.properties.append(puttsAttribute)
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.type = .date
        gameEntity.properties.append(dateAttribute)
        
        let scoreAttribute = NSAttributeDescription()
        scoreAttribute.name = "score"
        scoreAttribute.type = .integer32
        gameEntity.properties.append(scoreAttribute)
        
        let golfCourseAttribute = NSAttributeDescription()
        golfCourseAttribute.name = "golfCourse"
        golfCourseAttribute.type = .string
        gameEntity.properties.append(golfCourseAttribute)
        
        gameEntity.properties.append(idAttribute)
        
        
        
        
        let model = NSManagedObjectModel()
        model.entities = [clubEntity, gameEntity]
        
        
        
        container = NSPersistentContainer(name: "ClubToDo", managedObjectModel: model)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext
            .automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
