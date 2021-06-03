import UIKit

protocol ContactAddViewModelProtocol {
  func requestContact()
  func setRingtone(index: Int)
  func configureViewModels()
  func cancelAction()
  func addContact()
  var models: [String] { get }
  var isRequiredInformation: Bool? { get }
  var pickerDataSource: PickerDataSource<String> { get }
  var onDidUpdate: (() -> Void)? { get set }
  
}

// MARK: - ContactAddViewModelDelegate

protocol ContactAddViewModelDelegate: AnyObject {
  func contactAddViewModelDidRequestShowImagePicker(_ viewModel: ContactAddEditViewModel)
  func contactAddViewModelDidFinish(_ viewModel: ContactAddEditViewModel)
  func contactAddViewModelDidRequestAppearance(_ viewModel: ContactAddEditViewModel)
}

final class ContactAddEditViewModel: ContactAddViewModelProtocol {
  // MARK: - Types
  
  typealias Dependencies = HasCoreDataService & HasFileManagerService
  
  // MARK: - Properties
  
  let coreDataService: CoreDataServiceProtocol
  let fileManagerService: FileManagerServiceProtocol
  
  weak var delegate: ContactAddViewModelDelegate?
  
  let contactCellNotesViewModel = ContactCellNotesViewModel()
  let contactCellRingtoneViewModel = ContactCellInformationViewModel()
  let stateScreen: StateScreen
  let contactPhotoViewModel = ContactPhotoViewModel()
  
  var pickerDataSource: PickerDataSource<String>
  var models: [String] = RingtoneDataManager.getData()
  var onDidUpdate: (() -> Void)?
  var isRequiredInformation: Bool?
  
  var contact: Contact = Contact(id: UUID(), firstName: "", phoneNumber: "", ringtone: R.string.localizable.default())
  
  // MARK: - Init
  
  init(dependencies: Dependencies, stateScreen: StateScreen) {
    coreDataService = dependencies.coreDataService
    fileManagerService = dependencies.fileManagerService
    self.stateScreen = stateScreen
    
    pickerDataSource = PickerDataSource(models: models)
    
    contactPhotoViewModel.delegate = self
    contactCellNotesViewModel.delegate = self
    contactCellRingtoneViewModel.delegate = self
    
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
    
    let model = ContactPhotoViewModelStruct(image: contact.photo,
                                            firstName: contact.firstName,
                                            lastName: contact.lastName,
                                            phoneNumber: contact.phoneNumber)
    contactPhotoViewModel.configure(model: model)
    onDidUpdate?()
  }
  
  func setRingtone(index: Int) {
    contact.ringtone = models[index]
    contactCellRingtoneViewModel.configure(title: R.string.localizable.ringtone(), description: contact.ringtone)
  }
  
  // Coordinator input
  func updateImage(image: UIImage) {
    contactPhotoViewModel.updatePhoto(photo: image)
  }
  
  func requestContact() {
//    didUpdateNewContact?(contact)
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
  
  // MARK: - Private Functions
  
  // For add
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
  
  // For Edit
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
  
  func contactPhotoViewModel(_ viewModel: ContactPhotoViewModel, didChangeData: ContactPhotoViewModelStruct) {
    
    if let firstName = didChangeData.firstName,
       let phoneNumber = didChangeData.phoneNumber {
      contact.firstName = firstName
      contact.phoneNumber = phoneNumber
    }
    contact.lastName = didChangeData.lastName
    contact.photo = didChangeData.image
    
    checkIsRequiredInformation()
  }
}

// MARK: - ContactCellNotesViewModelDelegate

extension ContactAddEditViewModel: ContactCellNotesViewModelDelegate {
  func contactCellNotesViewModel(viewModel: ContactCellNotesViewModel, didChangeTextView: String) {
    contact.notes = didChangeTextView
  }
}

// MARK: - ContactCellInformationViewModelDelegate

extension ContactAddEditViewModel: ContactCellInformationViewModelDelegate {
  func contactCellInformationViewModel(_ viewModel: ContactCellInformationViewModel, didChangeText: String) {
    contact.ringtone = didChangeText
  }
}
