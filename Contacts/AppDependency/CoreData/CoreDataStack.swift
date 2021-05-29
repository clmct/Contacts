import Foundation
import CoreData

protocol CoreDatasStackProtocol {
  func getContext() -> NSManagedObjectContext
  func saveContext()
}

final class CoreDataStack: CoreDatasStackProtocol {
  // MARK: - Properties
  private var persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "CoreDataModel")
  
  // MARK: - Init
  init() {
    setupPersistentContainer()
  }

  // MARK: - Private Methods
  private func setupPersistentContainer() {
    persistentContainer.viewContext.mergePolicy = NSOverwriteMergePolicy
  }
  
  // MARK: - Public Methods
  func getContext() -> NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func saveContext () {
    if persistentContainer.viewContext.hasChanges {
      do {
        try persistentContainer.viewContext.save()
      } catch {
        print("Error in \(#function)")
      }
    }
  }
}
