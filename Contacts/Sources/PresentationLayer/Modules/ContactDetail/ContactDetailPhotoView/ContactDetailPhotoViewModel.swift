import UIKit

protocol ContactDetailPhotoViewModelProtocol {
  var image: UIImage? { get }
  var firstName: String? { get }
  var lastName: String? { get }
  var onDidUpdateViewModel: (() -> Void)? { get set }
}

final class ContactDetailPhotoViewModel: ContactDetailPhotoViewModelProtocol {
  // MARK: - Properties
  
  var image: UIImage?
  var firstName: String?
  var lastName: String?
  var onDidUpdateViewModel: (() -> Void)?

  func configure(image: UIImage?, firstName: String?, lastName: String?) {
    self.image = image
    self.firstName = firstName
    self.lastName = lastName
    onDidUpdateViewModel?()
  }
  
}
