import UIKit

protocol ContactEditViewModelProtocol {
}

protocol ContactEditViewModelDelegate: class {
}

final class ContactEditViewModel: ContactEditViewModelProtocol {
  // MARK: - Types
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Properties
  weak var delegate: ContactEditViewModelDelegate?
  
  // MARK: - Init
  init(dependencies: Dependencies) {
  }
  
  // MARK: - Public Methods
  
  // MARK: - Actions
  
  // MARK: - Private Methods
}
