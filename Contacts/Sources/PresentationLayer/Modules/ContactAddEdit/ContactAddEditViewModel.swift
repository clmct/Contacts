import UIKit

// MARK: - ContactAddViewModelDelegate

protocol ContactAddViewModelDelegate: AnyObject {
  func contactAddViewModelDidRequestShowImagePicker(_ viewModel: ContactAddEditViewModel)
  func contactAddViewModelDidFinish(_ viewModel: ContactAddEditViewModel)
  func contactAddCoordinatorDidFinishAndDeleteContact(_ viewModel: ContactAddEditViewModel)
  func contactAddViewModelDidRequestAppearance(_ viewModel: ContactAddEditViewModel)
}

// MARK: - ContactAddEditViewModelProtocol

protocol ContactAddEditViewModelProtocol {
  var contactCellNotesViewModel: ContactCellNotesViewModelProtocol { get }
  var contactCellRingtoneViewModel: ContactCellInformationViewModelProtocol { get }
  var contactPhotoViewModel: ContactPhotoViewModelProtocol { get }
  var models: [String] { get }
  var isRequiredInformation: Bool? { get }
  var pickerDataSource: PickerDataSource<String> { get }
  var onDidUpdate: (() -> Void)? { get set }
  var stateScreen: StateScreen { get }
  func setRingtone(index: Int)
  func configureViewModels()
  func cancelAction()
  func addContact()
  func deleteContact()
  func changeAppearance()
  func changeFirstName(with text: String)
  func changeLastName(with text: String)
  func changePhoneNumber(with text: String)
  func changeNotes(with text: String)
}

final class ContactAddEditViewModel: NSObject, ContactAddEditViewModelProtocol {
  // MARK: - Types
  
  typealias Dependencies = HasCoreDataService & HasFileManagerService
  
  // MARK: - Properties
  
  let coreDataService: CoreDataServiceProtocol
  let fileManagerService: FileManagerServiceProtocol
  
  weak var delegate: ContactAddViewModelDelegate?
  
  let contactCellNotesViewModel: ContactCellNotesViewModelProtocol = ContactCellNotesViewModel()
  let contactCellRingtoneViewModel: ContactCellInformationViewModelProtocol = ContactCellInformationViewModel()
  var contactPhotoViewModel: ContactPhotoViewModelProtocol = ContactPhotoViewModel()
  
  var pickerDataSource: PickerDataSource<String>
  var models: [String] = RingtoneDataManager.getData()
  let stateScreen: StateScreen
  var isRequiredInformation: Bool?
  var onDidUpdate: (() -> Void)?
  
  var contact: Contact = Contact(id: UUID(), firstName: "", phoneNumber: "", ringtone: R.string.localizable.default())
  
  // MARK: - Init
  
  init(dependencies: Dependencies, stateScreen: StateScreen) {
    coreDataService = dependencies.coreDataService
    fileManagerService = dependencies.fileManagerService
    self.stateScreen = stateScreen
    pickerDataSource = PickerDataSource(models: models)
    super.init()
    
    contactPhotoViewModel.delegate = self
    
    switch stateScreen {
    case .edit(let id):
      fetchContact(id: id)
    default:
      break
    }
  }
  
  // MARK: - Public Methods
  
  func configureViewModels() {
    contactCellNotesViewModel.configure(title: R.string.localizable.notes(),
                                        text: contact.notes ?? "")
    contactCellRingtoneViewModel.configure(title: R.string.localizable.ringtone(),
                                           description: contact.ringtone)
    contactPhotoViewModel.configure(firstName: contact.firstName,
                                    lastName: contact.lastName,
                                    phoneNumber: contact.phoneNumber)
    DispatchQueue.global(qos: .userInteractive).async {
      self.loadImageFromFileSystem(urlString: self.contact.id.uuidString)
      DispatchQueue.main.async {
        if let photo = self.contact.photo {
          self.contactPhotoViewModel.updatePhoto(photo: photo)
        }
      }
    }
  }
  
  // Coordinator input
  func updateImage(image: UIImage) {
    contactPhotoViewModel.updatePhoto(photo: image)
    contact.photo = image
    checkIsRequiredInformation()
  }
  
  func setRingtone(index: Int) {
    contact.ringtone = models[index]
    contactCellRingtoneViewModel.configure(title: R.string.localizable.ringtone(), description: contact.ringtone)
    checkIsRequiredInformation()
  }
  
  func changeFirstName(with text: String) {
    contact.firstName = text
    checkIsRequiredInformation()
  }
  
  func changeLastName(with text: String) {
    contact.lastName = text
    checkIsRequiredInformation()
  }
  
  func changePhoneNumber(with text: String) {
    contact.phoneNumber = text
    checkIsRequiredInformation()
  }
  
  func changeNotes(with text: String) {
    contact.notes = text
    checkIsRequiredInformation()
  }
  
  // MARK: - Delegate
  
  func changeAppearance() {
    delegate?.contactAddViewModelDidRequestAppearance(self)
  }
  
  func addContact() {
    saveContactToDataBase()
    delegate?.contactAddViewModelDidFinish(self)
  }
  
  func cancelAction() {
    delegate?.contactAddViewModelDidFinish(self)
  }
  
  func deleteContact() {
    delegate?.contactAddCoordinatorDidFinishAndDeleteContact(self)
  }
  
  // MARK: - Private Functions
  
  func deleteContactFromDataBase() {
    coreDataService.deleteContact(id: contact.id)
  }
  
  private func saveImageToFileSystem(image: UIImage, urlString: String) {
    fileManagerService.saveImage(image: image, urlString: urlString)
  }
  
  private func loadImageFromFileSystem(urlString: String) {
    contact.photo = fileManagerService.loadImage(urlString: urlString)
  }
  
  private func saveContactToDataBase() {
    if let photo = contact.photo {
      saveImageToFileSystem(image: photo, urlString: contact.id.uuidString)
    }
    coreDataService.addContact(with: contact)
  }
  
  private func fetchContact(id: UUID) {
    coreDataService.getContact(id: id) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let contact):
        self.contact = contact
        self.configureViewModels()
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private func checkIsRequiredInformation() {
    if !contact.firstName.isEmpty && !contact.phoneNumber.isEmpty {
      isRequiredInformation = true
    } else {
      isRequiredInformation = false
    }
    onDidUpdate?()
  }
}

// MARK: - ContactPhotoViewModelDelegate

extension ContactAddEditViewModel: ContactPhotoViewModelDelegate {
  func contactPhotoViewModelDidRequestShowImagePicker(_ viewModel: ContactPhotoViewModel) {
    delegate?.contactAddViewModelDidRequestShowImagePicker(self)
  }
}
