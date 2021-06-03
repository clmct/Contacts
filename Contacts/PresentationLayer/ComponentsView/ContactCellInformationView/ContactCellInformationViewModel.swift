import UIKit

protocol ContactCellInformationViewModelDelegate: AnyObject {
  func contactCellInformationViewModel(_ viewModel: ContactCellInformationViewModel, didChangeText: String)
}

class ContactCellInformationViewModel {
  // MARK: - Properties
  weak var delegate: ContactCellInformationViewModelDelegate?
  
  // Foe detail
  var didChangeText: ((String) -> Void)?
  
  var title: String?
  var description: String?
  var viewModelDidChange: (() -> Void)?
  
  // MARK: - Public Methods
  
  func configure(title: String, description: String) {
    self.title = title
    self.description = description
    viewModelDidChange?()
  }
  
  func changeText(with text: String) {
    didChangeText?(text)
    delegate?.contactCellInformationViewModel(self, didChangeText: text)
  }
  
  func setText(description: String) {
    self.description = description
    viewModelDidChange?()
  }
}
