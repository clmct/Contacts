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
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Properties
  var didUpdateNewContact: ((Contact) -> Void)?
  let contactCellNotesViewModel = ContactCellNotesViewModel()
  var contact: Contact
  let contactPhotoView = ContactPhotoViewModel()
  var models: [String] = []
  var ringtone: String = "default"
  // MARK: - Init
  init(dependencies: Dependencies) {
    contact = Contact(id: UUID(),
                      photo: nil,
                      firstName: "Мама",
                      lastName: "",
                      phoneNumber: "34-45-56",
                      ringtone: "",
                      notes: "")
    models = ["default", "wefwefefw", "wewef", "fgfgfg", "dfdfdfd"]
    pickerDataSource = PickerDataSource(models: models)
    contactPhotoView.delegate = self
  }
  
  func setRingtone(index: Int) {
    ringtone = models[index]
  }
  
  // MARK: - Public Methods
  func configureSubViews() {
    contactCellNotesViewModel.delegate = self
  }
  
  func requestContact() {
    didUpdateNewContact?(contact)
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
  }
}

extension ContactAddViewModel: ContactCellNotesViewModelDelegate {
  func contactCellNotesViewModel(viewModel: ContactCellNotesViewModel, didChangeTextView: String) {
    contact.notes = didChangeTextView
  }
}
