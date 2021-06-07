import Foundation

protocol ContactInformationViewModelDelegate: AnyObject {
  func contactInformationViewModel(_ viewModel: ContactInformationViewModel, textDidChange: String)
}

protocol ContactInformationViewModelProtocol {
  var onDidUpdateViewModel: (() -> Void)? { get set }
  var placeholder: String? { get  }
  var text: String? { get }
  func configure(text: String?, placeholder: String?)
}

class ContactInformationViewModel: ContactInformationViewModelProtocol {
  // MARK: - Properties
  
  weak var delegate: ContactInformationViewModelDelegate?
  var onDidUpdateViewModel: (() -> Void)?
  var placeholder: String?
  var text: String?
  
  // MARK: - Public Methods
  
  func configure(text: String?, placeholder: String?) {
    self.text = text
    self.placeholder = placeholder
    onDidUpdateViewModel?()
  }
}
