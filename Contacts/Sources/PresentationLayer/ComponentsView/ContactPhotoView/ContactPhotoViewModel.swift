import UIKit

struct ContactPhotoViewModelStruct {
  var image: UIImage?
  var firstName: String?
  var lastName: String?
  var phoneNumber: String?
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
  
  var model: ContactPhotoViewModelStruct = ContactPhotoViewModelStruct()
  var onDidUpdateViewModel: (() -> Void)?
  
  // MARK: - Init
  
  init() {
    setupViewModels()
  }
  
  // MARK: - Public Methods
  
  func configure(model: ContactPhotoViewModelStruct) {
    self.model = model
    
    firstNameContactInformationViewModel.configure(text: model.firstName,
                                                   placeholder: R.string.localizable.firstNamePlaceholder())
    lastNameContactInformationViewModel.configure(text: model.lastName,
                                                  placeholder: R.string.localizable.lastNamePlaceholder())
    phoneNumberContactInformationViewModel.configure(text: model.phoneNumber,
                                                     placeholder: R.string.localizable.phoneNumberPlaceholder())
    onDidUpdateViewModel?()
  }
  
  // input
  func updatePhoto(photo: UIImage) {
    model.image = photo
    onDidUpdateViewModel?()
    changeData()
  }
  
  // delegate
  func showImagePicker() {
    delegate?.contactPhotoViewModelDidRequestShowImagePicker(self)
  }
  
  // MARK: - Private Methods
  
  private func setupViewModels() {
    firstNameContactInformationViewModel.delegate = self
    lastNameContactInformationViewModel.delegate = self
    phoneNumberContactInformationViewModel.delegate = self
  }
  
  private func changePhoto(with photo: UIImage) {
    model.image = photo
    changeData()
  }
  
  private func changeData() {
    delegate?.contactPhotoViewModel(self, didChangeData: model)
  }
}

extension ContactPhotoViewModel: ContactInformationViewModelDelegate {
  func contactInformationViewModel(_ viewModel: ContactInformationViewModel, textDidChange: String) {
    if viewModel === firstNameContactInformationViewModel {
      model.firstName = textDidChange
      changeData()
    }
    
    if viewModel === lastNameContactInformationViewModel {
      model.lastName = textDidChange
      changeData()
    }
    
    if viewModel === phoneNumberContactInformationViewModel {
      model.phoneNumber = textDidChange
      changeData()
    }
  }
}