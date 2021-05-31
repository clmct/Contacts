import UIKit

protocol ContactDetailViewModelProtocol {
  var contactDetailPhotoViewModel: ContactDetailPhotoViewModel? { get }
  var phoneViewModel: ContactCellInformationViewModel? { get }
  var ringtoneViewModel: ContactCellInformationViewModel? { get }
  var notesViewModel: ContactCellInformationViewModel? { get }
  var contact: Contact? { get }
  func fetchContact()
  func showEditContact()
}

protocol ContactDetailViewModelDelegate: AnyObject {
  func contactsDetailViewModel(_ viewModel: ContactDetailViewModel, didRequestShowEditContact contact: String)
}

final class ContactDetailViewModel: ContactDetailViewModelProtocol {
  // MARK: - Types
  typealias Dependencies = HasCoreDataService & HasFileManagerService
  
  // MARK: - Properties
  private let coreDataService: CoreDataServiceProtocol
  private let fileManagerService: FileManagerServiceProtocol
  private let id: UUID
  
  weak var delegate: ContactDetailViewModelDelegate?
  
  var contactDetailPhotoViewModel: ContactDetailPhotoViewModel?
  var phoneViewModel: ContactCellInformationViewModel?
  var ringtoneViewModel: ContactCellInformationViewModel?
  var notesViewModel: ContactCellInformationViewModel?
  
  var contact: Contact?
  
  // MARK: - Init
  init(dependencies: Dependencies, id: UUID) {
    coreDataService = dependencies.coreDataService
    fileManagerService = dependencies.fileManagerService
    self.id = id
  }
  
  // MARK: - Public Methods
  func showEditContact() {
    delegate?.contactsDetailViewModel(self, didRequestShowEditContact: "")
  }
  
  func fetchContact() {
    coreDataService.getContact(id: id) { result in
      switch result {
      case .success(let contact):
        self.contact = contact
        self.configure()
      case .failure(let error):
        print(error)
      }
    }
  }
  
  // MARK: - Private Methods
  func configure() {
    guard let contact = contact else { return }
    contactDetailPhotoViewModel = ContactDetailPhotoViewModel(image: contact.photo,
                                                              firstName: contact.firstName,
                                                              lastName: contact.lastName)
    phoneViewModel = ContactCellInformationViewModel(title: R.string.localizable.phone(),
                                                     description: contact.phoneNumber)
    ringtoneViewModel = ContactCellInformationViewModel(title: R.string.localizable.ringtone(),
                                                        description: contact.ringtone ?? "")
    notesViewModel = ContactCellInformationViewModel(title: R.string.localizable.notes(),
                                                     description: contact.notes ?? "")
  }
}
