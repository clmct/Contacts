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
  var isValidity: Bool? { get }
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
  var isValidity: Bool?
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
    
    loadImageFromFileSystem(urlString: self.contact.id.uuidString) { [weak self] in
      if let photo = self?.contact.photo {
        self?.contactPhotoViewModel.updatePhoto(photo: photo)
      }
    }
  }
  
  // Coordinator input
  func updateImage(image: UIImage) {
    contactPhotoViewModel.updatePhoto(photo: image)
    contact.photo = image
    checkValidity()
  }
  
  func setRingtone(index: Int) {
    contact.ringtone = models[index]
    contactCellRingtoneViewModel.configure(title: R.string.localizable.ringtone(), description: contact.ringtone)
    checkValidity()
  }
  
  func changeFirstName(with text: String) {
    contact.firstName = text
    checkValidity()
  }
  
  func changeLastName(with text: String) {
    contact.lastName = text
    checkValidity()
  }
  
  func changePhoneNumber(with text: String) {
    contact.phoneNumber = text
    checkValidity()
  }
  
  func changeNotes(with text: String) {
    contact.notes = text
    checkValidity()
  }
  
  // MARK: - Delegate
  
  func changeAppearance() {
    delegate?.contactAddViewModelDidRequestAppearance(self)
  }
  
  func addContact() {
    saveContactToDataBase { [weak self] in
      guard let self = self else { return }
      self.delegate?.contactAddViewModelDidFinish(self)
    }
  }
  
  func cancelAction() {
    delegate?.contactAddViewModelDidFinish(self)
  }
  
  func deleteContact() {
    delegate?.contactAddCoordinatorDidFinishAndDeleteContact(self)
  }
  
  // MARK: - Private Functions
  
  func deleteContactFromDataBase(completion: @escaping () -> Void) {
    coreDataService.deleteContact(id: contact.id) {
      completion()
    }
  }
  
  private func saveImageToFileSystem(image: UIImage, urlString: String, completion: @escaping () -> Void) {
    fileManagerService.saveImage(image: image, urlString: urlString) {
      completion()
    }
  }
  
  private func loadImageFromFileSystem(urlString: String, completion: @escaping () -> Void) {
    fileManagerService.loadImage(urlString: urlString) { [weak self] image in
      self?.contact.photo = image
      completion()
    }
  }
  
  private func saveContactToDataBase(completion: @escaping () -> Void) {
    guard let photo = contact.photo else {
      coreDataService.addContact(with: self.contact)
      completion()
      return
    }
    saveImageToFileSystem(image: photo, urlString: contact.id.uuidString) { [weak self] in
      guard let self = self else { return }
      self.coreDataService.addContact(with: self.contact)
      completion()
    }
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
  
  private func checkValidity() {
    if !contact.firstName.isEmpty && !contact.phoneNumber.isEmpty {
      isValidity = true
    } else {
      isValidity = false
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
