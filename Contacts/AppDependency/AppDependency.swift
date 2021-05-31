import Foundation

protocol HasCoreDataService {
  var coreDataService: CoreDataServiceProtocol { get }
}

protocol HasFileManagerService {
  var fileManagerService: FileManagerServiceProtocol { get }
}

final class AppDependency: HasCoreDataService, HasFileManagerService {
  var coreDataService: CoreDataServiceProtocol = CoreDataService()
  var fileManagerService: FileManagerServiceProtocol = FileManagerService()
}
