import UIKit

class ContactCellInformationViewModel {
  // MARK: - Properties
  var didChangeText: ((String) -> Void)?
  var title: String
  var description: String
  var descriptionDidChange: (() -> Void)?
  
  init(title: String, description: String) {
    self.title = title
    self.description = description
  }
  
  func changeText(with text: String) {
    didChangeText?(text)
  }
  
  func setText(description: String) {
    self.description = description
    descriptionDidChange?()
  }
}
