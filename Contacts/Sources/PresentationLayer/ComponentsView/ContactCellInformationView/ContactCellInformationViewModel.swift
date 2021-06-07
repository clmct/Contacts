import UIKit

protocol ContactCellInformationViewModelDelegate: AnyObject {
  func contactCellInformationViewModel(_ viewModel: ContactCellInformationViewModel, didChangeText: String)
}

protocol ContactCellInformationViewModelProtocol {
  var title: String? { get }
  var description: String? { get }
  var onDidUpdateViewModel: (() -> Void)? { get set }
  func configure(title: String, description: String)
}

class ContactCellInformationViewModel: ContactCellInformationViewModelProtocol {
  // MARK: - Properties
  
  weak var delegate: ContactCellInformationViewModelDelegate?
  var onDidUpdateViewModel: (() -> Void)?
  var title: String?
  var description: String?
  
  // MARK: - Public Methods
  
  func configure(title: String, description: String) {
    self.title = title
    self.description = description
    onDidUpdateViewModel?()
  }
  
  func setText(description: String) {
    self.description = description
    onDidUpdateViewModel?()
  }
}
