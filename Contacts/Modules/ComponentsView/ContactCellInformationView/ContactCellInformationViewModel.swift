import UIKit

class ContactCellInformationViewModel {
  // MARK: - Properties
  // output
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
  }
  
  func setText(description: String) {
    self.description = description
    viewModelDidChange?()
  }
}
