import UIKit

struct ContactPhotoViewModelStruct {
  let image: UIImage?
  let firstName: String?
  let lastName: String?
  let phoneNumber: String?
}

protocol ContactPhotoViewModelDelegate: AnyObject {
  func contactPhotoViewModel(_ viewModel: ContactPhotoViewModel, didChangeData: ContactPhotoViewModelStruct)
}

final class ContactPhotoViewModel {
  // MARK: - Properties
  weak var delegate: ContactPhotoViewModelDelegate?
  let firstNameContactInformationViewModel = ContactInformationViewModel(placeholder: "First name")
  let lastNameContactInformationViewModel = ContactInformationViewModel(placeholder: "Last name")
  let phoneNumberContactInformationViewModel = ContactInformationViewModel(placeholder: "Phone number")
  var image: UIImage?
  var firstName: String?
  var lastName: String?
  var phoneNumber: String?
  
  init() {
    setupViewModels()
  }
  
  func updateImage(with image: UIImage) {
    self.image = image
    self.changeData()
  }
  
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
