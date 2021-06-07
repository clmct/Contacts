import UIKit

protocol ContactCellNotesViewModelDelegate: AnyObject {
  func contactCellNotesViewModel(viewModel: ContactCellNotesViewModel, didChangeTextView: String)
}

protocol ContactCellNotesViewModelProtocol {
  func changeNotes(with text: String)
}

class ContactCellNotesViewModel: ContactCellNotesViewModelProtocol {
  // MARK: - Properties
  
  weak var delegate: ContactCellNotesViewModelDelegate?
  var onDidUpdateViewModel: (() -> Void)?
  var text: String?
  var title: String?
  
  // MARK: - Public Methods
  // input
  func configure(title: String, text: String) {
    self.title = title
    self.text = text
    onDidUpdateViewModel?()
  }
  
  // delegate
  func changeNotes(with text: String) {
    delegate?.contactCellNotesViewModel(viewModel: self, didChangeTextView: text)
  }
}
