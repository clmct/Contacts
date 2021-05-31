import UIKit

protocol ContactAddViewModelProtocol {
  var didUpdateNewContact: ((Contact) -> Void)? { get set }
  func requestContact()
  func setRingtone(index: Int)
  var models: [String] { get }
  var pickerDataSource: PickerDataSource<String> { get }
}

final class ContactAddViewModel: ContactAddViewModelProtocol {
  var pickerDataSource: PickerDataSource<String>
  
  // MARK: - Types
  typealias Dependencies = HasCoreDataService & HasFileManagerService
  
  // MARK: - Properties
  let coreDataService: CoreDataServiceProtocol
  let fileManagerService: FileManagerServiceProtocol
  
  let contactCellNotesViewModel = ContactCellNotesViewModel()
  let contactCellRingtoneViewModel = ContactCellInformationViewModel(title: "Ringtone", description: "default")
  let contactPhotoViewModel = ContactPhotoViewModel()
  var didUpdateNewContact: ((Contact) -> Void)?
  var contact: Contact
  var models: [String] = []
  var ringtone: String = "default"
  
  // MARK: - Init
  init(dependencies: Dependencies) {
    coreDataService = dependencies.coreDataService
    fileManagerService = dependencies.fileManagerService
    
    contact = Contact(id: UUID(),
                      photo: nil,
                      firstName: "",
                      lastName: "",
                      phoneNumber: "",
                      ringtone: "",
                      notes: "")
    models = ["Default", "Old Phone", "Beacon", "Radar", "Signal", "Waves"]
    pickerDataSource = PickerDataSource(models: models)
    contactPhotoViewModel.delegate = self
    contactCellNotesViewModel.delegate = self
    
    contactCellRingtoneViewModel.didChangeText = { text in
      self.contact.ringtone = text
      self.printData()
    }
  }
  
  func setRingtone(index: Int) {
    contact.ringtone = models[index]
    self.printData()
    guard let text = contact.ringtone else { return }
    contactCellRingtoneViewModel.setText(description: text)
  }
  
  // MARK: - Public Methods
  func requestContact() {
    didUpdateNewContact?(contact)
  }
  
  //
  func printData() {
    print("----")
    print(contact.firstName)
    print(contact.lastName)
    print(contact.photo)
    print(contact.phoneNumber)
    print(contact.notes)
    print(contact.ringtone)
  }
  
  func addContact() {
    saveContactToDataBase()
  }
  // MARK: - Services
  private func saveImageToFileSystem(image: UIImage, urlString: String) {
    fileManagerService.saveImage(image: image, urlString: urlString)
  }
  
  private func saveContactToDataBase() {
    if let photo = contact.photo {
      saveImageToFileSystem(image: photo, urlString: contact.id.uuidString)
    }
    coreDataService.addContact(with: contact)
  }
}

extension ContactAddViewModel: ContactPhotoViewModelDelegate {
  func contactPhotoViewModel(_ viewModel: ContactPhotoViewModel, didChangeData: ContactPhotoViewModelStruct) {
    if let firstName = didChangeData.firstName,
       let phoneNumber = didChangeData.phoneNumber {
      contact.firstName = firstName
      contact.phoneNumber = phoneNumber
    }
    contact.lastName = didChangeData.lastName
    contact.photo = didChangeData.image
    printData()
  }
}

extension ContactAddViewModel: ContactCellNotesViewModelDelegate {
  func contactCellNotesViewModel(viewModel: ContactCellNotesViewModel, didChangeTextView: String) {
    contact.notes = didChangeTextView
    printData()
  }
}
