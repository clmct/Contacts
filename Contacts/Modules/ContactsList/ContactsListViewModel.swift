import UIKit

protocol ContactsListViewModelProtocol {
}

protocol ContactsListViewModelDelegate: class {
}

final class ContactsListViewModel: ContactsListViewModelProtocol {
  // MARK: - Types
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Properties
  weak var delegate: ContactsListViewModelDelegate?
  
  // MARK: - Init
  init(dependencies: Dependencies) {
  }
  
  // MARK: - Public Methods
  
  // MARK: - Actions
  
  // MARK: - Private Methods
}
