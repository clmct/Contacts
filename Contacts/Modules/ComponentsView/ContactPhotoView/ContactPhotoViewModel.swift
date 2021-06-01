import UIKit

struct ContactPhotoViewModelStruct {
  let image: UIImage?
  let firstName: String?
  let lastName: String?
  let phoneNumber: String?
}

protocol ContactPhotoViewModelDelegate: AnyObject {
  func contactPhotoViewModel(_ viewModel: ContactPhotoViewModel, didChangeData: ContactPhotoViewModelStruct)
  func contactPhotoViewModelDidRequestShowImagePicker(_ viewModel: ContactPhotoViewModel)
}

final class ContactPhotoViewModel {
  // MARK: - Properties
  
  weak var delegate: ContactPhotoViewModelDelegate?
  let firstNameContactInformationViewModel = ContactInformationViewModel()
  let lastNameContactInformationViewModel = ContactInformationViewModel()
  let phoneNumberContactInformationViewModel = ContactInformationViewModel()
  var didUpdateViewModel: (() -> Void)?
  var image: UIImage?
  var firstName: String?
  var lastName: String?
  var phoneNumber: String?
  
  // MARK: - Init
  
  init() {
    setupViewModels()
  }
  
  // MARK: - Public Methods
  
  func configure(model: ContactPhotoViewModelStruct) {
    firstNameContactInformationViewModel.configure(text: model.firstName,
                                                   placeholder: R.string.localizable.firstNamePlaceholder())
    lastNameContactInformationViewModel.configure(text: model.lastName,
                                                  placeholder: R.string.localizable.lastNamePlaceholder())
    phoneNumberContactInformationViewModel.configure(text: model.phoneNumber,
                                                     placeholder: R.string.localizable.phoneNumberPlaceholder())
  }
  
  // input
  func updatePhoto(photo: UIImage) {
    image = photo
    didUpdateViewModel?()
  }
  
  func showImagePicker() {
    delegate?.contactPhotoViewModelDidRequestShowImagePicker(self)
  }
  
  // MARK: - Private Methods
  
  private func setupViewModels() {
    firstNameContactInformationViewModel.didChangeText = { text in
      self.firstName = text
      self.changeData()
    }
    
    lastNameContactInformationViewModel.didChangeText = { text in
      self.lastName = text
      self.changeData()
    }
    
    phoneNumberContactInformationViewModel.didChangeText = { text in
      self.phoneNumber = text
      self.changeData()
    }
  }
  
  private func changePhoto(with photo: UIImage) {
    image = photo
    changeData()
  }
  
  private func changeData() {
    let model = ContactPhotoViewModelStruct(image: image,
                                            firstName: firstName,
                                            lastName: lastName,
                                            phoneNumber: phoneNumber)
    delegate?.contactPhotoViewModel(self, didChangeData: model)
  }
}
