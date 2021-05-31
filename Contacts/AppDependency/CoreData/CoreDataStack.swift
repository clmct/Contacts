import Foundation
import CoreData

protocol CoreDatasStackProtocol {
  func getContext() -> NSManagedObjectContext
  func saveContext()
}

final class CoreDataStack: CoreDatasStackProtocol {
  // MARK: - Properties
  private var persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "ContactsModel")
  
  // MARK: - Init
  init() {
    setupPersistentContainer()
  }
  
  // MARK: - Public Methods
  func getContext() -> NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func saveContext () {
    guard persistentContainer.viewContext.hasChanges else {
      print("Error in \(#function)")
      return
    }
    do {
      try persistentContainer.viewContext.save()
    } catch {
      print("Error in \(#function)")
    }
  }
  
  // MARK: - Private Methods
  private func setupPersistentContainer() {
    persistentContainer.viewContext.mergePolicy = NSOverwriteMergePolicy
  }
}
