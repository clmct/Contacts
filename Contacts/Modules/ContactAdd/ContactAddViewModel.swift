import UIKit

protocol ContactAddViewModelProtocol {
}

protocol ContactAddViewModelDelegate: class {
}

final class ContactAddViewModel: ContactAddViewModelProtocol {
  // MARK: - Types
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Properties
  weak var delegate: ContactAddViewModelDelegate?
  
  // MARK: - Init
  init(dependencies: Dependencies) {
  }
  
  // MARK: - Public Methods
  
}
