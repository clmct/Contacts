import Foundation

protocol ContactInformationViewModelProtocol {
  func changeText(with text: String)
  var placeholder: String { get }
}

class ContactInformationViewModel: ContactInformationViewModelProtocol {
  // MARK: - Properties
  var didChangeText: ((String) -> Void)?
  var placeholder: String
  
  init(placeholder: String) {
    self.placeholder = placeholder
  }
  
  func changeText(with text: String) {
    didChangeText?(text)
  }
}
