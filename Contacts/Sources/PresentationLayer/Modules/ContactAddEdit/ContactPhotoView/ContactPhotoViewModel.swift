import UIKit

protocol ContactPhotoViewModelDelegate: AnyObject {
  func contactPhotoViewModelDidRequestShowImagePicker(_ viewModel: ContactPhotoViewModel)
}

protocol ContactPhotoViewModelProtocol {
  var delegate: ContactPhotoViewModelDelegate? { get set }
  var onDidUpdateViewModel: (() -> Void)? { get set }
  var photo: UIImage? { get }
  var firstNameContactInformationViewModel: ContactInformationViewModelProtocol { get }
  var lastNameContactInformationViewModel: ContactInformationViewModelProtocol { get }
  var phoneNumberContactInformationViewModel: ContactInformationViewModelProtocol { get }
  func showImagePicker()
  func configure(firstName: String?, lastName: String?, phoneNumber: String?)
  func updatePhoto(photo: UIImage)
}

final class ContactPhotoViewModel: ContactPhotoViewModelProtocol {
  // MARK: - Properties
  
  weak var delegate: ContactPhotoViewModelDelegate?
  var onDidUpdateViewModel: (() -> Void)?
  var photo: UIImage?
  var firstNameContactInformationViewModel: ContactInformationViewModelProtocol = ContactInformationViewModel()
  var lastNameContactInformationViewModel: ContactInformationViewModelProtocol = ContactInformationViewModel()
  var phoneNumberContactInformationViewModel: ContactInformationViewModelProtocol = ContactInformationViewModel()
  
  // MARK: - Public Methods
  
  func configure(firstName: String?, lastName: String?, phoneNumber: String?) {
    firstNameContactInformationViewModel.configure(text: firstName,
                                                   placeholder: R.string.localizable.firstNamePlaceholder())
    lastNameContactInformationViewModel.configure(text: lastName,
                                                  placeholder: R.string.localizable.lastNamePlaceholder())
    phoneNumberContactInformationViewModel.configure(text: phoneNumber,
                                                     placeholder: R.string.localizable.phoneNumberPlaceholder())
    onDidUpdateViewModel?()
  }
  
  // input
  func updatePhoto(photo: UIImage) {
    self.photo = photo
    onDidUpdateViewModel?()
  }
  
  func showImagePicker() {
    delegate?.contactPhotoViewModelDidRequestShowImagePicker(self)
  }
}
