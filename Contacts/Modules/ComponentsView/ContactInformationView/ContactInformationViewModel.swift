import Foundation

protocol ContactInformationViewModelProtocol {
  func changeText(with text: String)
  var didUpdateViewModel: (() -> Void)? { get set }
  var placeholder: String? { get  }
  var text: String? { get }
}

class ContactInformationViewModel: ContactInformationViewModelProtocol {
  // MARK: - Properties
  // output
  var didChangeText: ((String) -> Void)?
  
  var didUpdateViewModel: (() -> Void)?
  var placeholder: String?
  var text: String?
  
  // MARK: - Public Methods
  // input
  func configure(text: String?, placeholder: String?) {
    self.text = text
    self.placeholder = placeholder
    didUpdateViewModel?()
  }
  
  // output
  func changeText(with text: String) {
    didChangeText?(text)
  }
}
