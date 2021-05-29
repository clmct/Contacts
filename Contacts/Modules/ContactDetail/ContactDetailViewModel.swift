import UIKit

protocol ContactDetailViewModelProtocol {
  func showEditContact()
}

protocol ContactDetailViewModelDelegate: AnyObject {
  func contactsDetailViewModel(_ viewModel: ContactDetailViewModel, didRequestShowEditContact contact: String)
}

final class ContactDetailViewModel: ContactDetailViewModelProtocol {
  // MARK: - Types
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Properties
  weak var delegate: ContactDetailViewModelDelegate?
  
  // MARK: - Init
  init(dependencies: Dependencies) {
  }
  
  // MARK: - Public Methods
  func showEditContact() {
    delegate?.contactsDetailViewModel(self, didRequestShowEditContact: "")
  }
}
