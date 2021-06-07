import Foundation

protocol ContactInformationViewModelDelegate: AnyObject {
  func contactInformationViewModel(_ viewModel: ContactInformationViewModel, textDidChange: String)
}

protocol ContactInformationViewModelProtocol {
  func changeText(with text: String)
  var onDidUpdateViewModel: (() -> Void)? { get set }
  var placeholder: String? { get  }
  var text: String? { get }
}

class ContactInformationViewModel: ContactInformationViewModelProtocol {
  // MARK: - Properties
  
  var placeholder: String?
  var text: String?
  var onDidUpdateViewModel: (() -> Void)?
  weak var delegate: ContactInformationViewModelDelegate?
  
  // MARK: - Public Methods
  
  func configure(text: String?, placeholder: String?) {
    self.text = text
    self.placeholder = placeholder
    onDidUpdateViewModel?()
  }
  
  func changeText(with text: String) {
    delegate?.contactInformationViewModel(self, textDidChange: text)
  }
}
