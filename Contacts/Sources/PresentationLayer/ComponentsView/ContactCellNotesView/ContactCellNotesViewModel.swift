import UIKit

protocol ContactCellNotesViewModelDelegate: AnyObject {
  func contactCellNotesViewModel(viewModel: ContactCellNotesViewModel, didChangeTextView: String)
}

protocol ContactCellNotesViewModelProtocol {
  var onDidUpdateViewModel: (() -> Void)? { get set }
  var text: String? { get }
  var title: String? { get }
  func configure(title: String, text: String)
}

class ContactCellNotesViewModel: ContactCellNotesViewModelProtocol {
  // MARK: - Properties
  
  weak var delegate: ContactCellNotesViewModelDelegate?
  var onDidUpdateViewModel: (() -> Void)?
  var text: String?
  var title: String?
  
  // MARK: - Public Methods
  
  func configure(title: String, text: String) {
    self.title = title
    self.text = text
    onDidUpdateViewModel?()
  }
}
