import UIKit

protocol ContactDetailPhotoViewModelProtocol {
  var image: UIImage? { get }
  var firstName: String { get }
  var lastName: String? { get }
}

final class ContactDetailPhotoViewModel: ContactDetailPhotoViewModelProtocol {
  var image: UIImage?
  var firstName: String
  var lastName: String?
  
  init(image: UIImage?, firstName: String, lastName: String?) {
    self.image = image
    self.firstName = firstName
    self.lastName = lastName
  }
  
}
