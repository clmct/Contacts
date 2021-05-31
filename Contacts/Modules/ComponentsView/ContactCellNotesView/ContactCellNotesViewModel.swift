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
  
  func changeNotes(with text: String) {
    delegate?.contactCellNotesViewModel(viewModel: self, didChangeTextView: text)
  }
}
