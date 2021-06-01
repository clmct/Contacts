import UIKit

protocol ContactAddViewModelProtocol {
  func requestContact()
  func setRingtone(index: Int)
  func configureViewModels()
  func cancelAction()
  func addContact()
  var didUpdateNewContact: ((Contact) -> Void)? { get set }
  var models: [String] { get }
  var pickerDataSource: PickerDataSource<String> { get }
  
}

// MARK: - ContactAddViewModelDelegate

protocol ContactAddViewModelDelegate: AnyObject {
  func contactAddViewModelDidRequestShowImagePicker(_ viewModel: ContactAddViewModel)
  func contactAddViewModelDidFinish(_ viewModel: ContactAddViewModel)
  func contactAddViewModelDidRequestAppearance(_ viewModel: ContactAddViewModel)
}

final class ContactAddViewModel: ContactAddViewModelProtocol {
  // MARK: - Types
  
  typealias Dependencies = HasCoreDataService & HasFileManagerService
  
  // MARK: - Properties
  
  weak var delegate: ContactAddViewModelDelegate?
  
  var pickerDataSource: PickerDataSource<String>
  let coreDataService: CoreDataServiceProtocol
  let fileManagerService: FileManagerServiceProtocol
  
  let contactCellNotesViewModel = ContactCellNotesViewModel()
  let contactCellRingtoneViewModel = ContactCellInformationViewModel()
  let contactPhotoViewModel = ContactPhotoViewModel()
  var didUpdateNewContact: ((Contact) -> Void)?
  var contact: Contact = Contact(id: UUID(), firstName: "", phoneNumber: "")
  var models: [String] = RingtoneDataManager.getData()
  
  // MARK: - Init
  init(dependencies: Dependencies) {
    coreDataService = dependencies.coreDataService
    fileManagerService = dependencies.fileManagerService
    pickerDataSource = PickerDataSource(models: models)
    contactPhotoViewModel.delegate = self
    contactCellNotesViewModel.delegate = self
  }
  
  // MARK: - Public Methods
  func configureViewModels() {
    contactCellRingtoneViewModel.didChangeText = { text in
      self.contact.ringtone = text
    }
    
    contactCellNotesViewModel.configure(title: R.string.localizable.notes(), text: "")
    contactCellRingtoneViewModel.configure(title: R.string.localizable.ringtone(),
                                           description: R.string.localizable.default())
    
    let model = ContactPhotoViewModelStruct(image: nil,
                                            firstName: "",
                                            lastName: "",
                                            phoneNumber: "")
    contactPhotoViewModel.configure(model: model) // doing
  }
  
  func setRingtone(index: Int) {
    contact.ringtone = models[index]
    guard let text = contact.ringtone else { return }
    contactCellRingtoneViewModel.configure(title: R.string.localizable.ringtone(), description: text)
  }
  
  // Coordinator input
  func updateImage(image: UIImage) {
    contactPhotoViewModel.updatePhoto(photo: image)
  }
  
  func requestContact() {
    didUpdateNewContact?(contact)
  }
  
  // MARK: - Delegate
  func viewWillAppear() {
    delegate?.contactAddViewModelDidRequestAppearance(self)
  }
  
  func addContact() {
    saveContactToDataBase()
    delegate?.contactAddViewModelDidFinish(self)
  }
  
  func cancelAction() {
    delegate?.contactAddViewModelDidFinish(self)
  }
  
  // MARK: - Services
  private func saveImageToFileSystem(image: UIImage, urlString: String) {
    fileManagerService.saveImage(image: image, urlString: urlString)
  }
  
  private func saveContactToDataBase() {
    if let photo = contact.photo {
      saveImageToFileSystem(image: photo, urlString: contact.id.uuidString)
    }
    print(contact)
    coreDataService.addContact(with: contact)
  }
}

// MARK: - ContactPhotoViewModelDelegate
extension ContactAddViewModel: ContactPhotoViewModelDelegate {
  func contactPhotoViewModelDidRequestShowImagePicker(_ viewModel: ContactPhotoViewModel) {
    delegate?.contactAddViewModelDidRequestShowImagePicker(self)
  }
  
  func contactPhotoViewModel(_ viewModel: ContactPhotoViewModel, didChangeData: ContactPhotoViewModelStruct) {
    print(didChangeData)
    if let firstName = didChangeData.firstName,
       let phoneNumber = didChangeData.phoneNumber {
      contact.firstName = firstName
      contact.phoneNumber = phoneNumber
    }
    contact.lastName = didChangeData.lastName
    contact.photo = didChangeData.image
    print(contact)
  }
}

// MARK: - ContactCellNotesViewModelDelegate
extension ContactAddViewModel: ContactCellNotesViewModelDelegate {
  func contactCellNotesViewModel(viewModel: ContactCellNotesViewModel, didChangeTextView: String) {
    contact.notes = didChangeTextView
  }
}
