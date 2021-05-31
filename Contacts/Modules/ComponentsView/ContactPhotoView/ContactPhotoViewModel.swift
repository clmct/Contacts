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
  let firstNameContactInformationView = ContactInformationViewModel()
  let lastNameContactInformationView = ContactInformationViewModel()
  let phoneNumberContactInformationView = ContactInformationViewModel()
  var image: UIImage?
  var firstName: String?
  var lastName: String?
  var phoneNumber: String?
  
  init() {
    setupViewModels()
  }
  
  private func setupViewModels() {
    firstNameContactInformationView.didChangeText = { text in
      self.firstName = text
      self.changeData()
    }
    
    lastNameContactInformationView.didChangeText = { text in
      self.lastName = text
      self.changeData()
    }
    
    phoneNumberContactInformationView.didChangeText = { text in
      self.phoneNumber = text
      self.changeData()
    }
  }
  
  func changePhoto(with photo: UIImage) {
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
