import Foundation

protocol HasCoreDataService {
  var coreDataService: CoreDataServiceProtocol { get }
}

final class AppDependency: HasCoreDataService {
  var coreDataService: CoreDataServiceProtocol = CoreDataService()
  
}
