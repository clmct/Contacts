import Foundation

protocol ContactInformationViewModelProtocol {
  func changeText(with text: String)
}

class ContactInformationViewModel: ContactInformationViewModelProtocol {
  // MARK: - Properties
  var didChangeText: ((String) -> Void)?
  
  func changeText(with text: String) {
    didChangeText?(text)
  }
}
