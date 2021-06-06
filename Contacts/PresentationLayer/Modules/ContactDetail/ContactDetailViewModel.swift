import UIKit

protocol ContactDetailViewModelProtocol {
  var contactDetailPhotoViewModel: ContactDetailPhotoViewModel { get }
  var phoneViewModel: ContactCellInformationViewModel { get }
  var ringtoneViewModel: ContactCellInformationViewModel { get }
  var notesViewModel: ContactCellNotesViewModel { get }
  var contact: Contact? { get }
  func fetchContact()
  func showEditContact()
  func changeAppearance()
}

protocol ContactDetailViewModelDelegate: AnyObject {
  func contactsDetailViewModel(_ viewModel: ContactDetailViewModel, didRequestShowEditContact contact: UUID)
  func contactDetailViewModelDidRequestAppearance(_ viewModel: ContactDetailViewModel)
}

final class ContactDetailViewModel: ContactDetailViewModelProtocol {
  // MARK: - Types
  
  typealias Dependencies = HasCoreDataService & HasFileManagerService
  
  // MARK: - Properties
  
  private let coreDataService: CoreDataServiceProtocol
  private let fileManagerService: FileManagerServiceProtocol
  private let id: UUID
  
  weak var delegate: ContactDetailViewModelDelegate?
  
  var contactDetailPhotoViewModel = ContactDetailPhotoViewModel()
  var phoneViewModel = ContactCellInformationViewModel()
  var ringtoneViewModel = ContactCellInformationViewModel()
  var notesViewModel = ContactCellNotesViewModel()
  
  var contact: Contact?
  
  // MARK: - Init
  
  init(dependencies: Dependencies, id: UUID) {
    coreDataService = dependencies.coreDataService
    fileManagerService = dependencies.fileManagerService
    self.id = id
  }
  
  // MARK: - Public Methods
  
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
  
  // MARK: - Delegate
  
  func changeAppearance() {
    delegate?.contactDetailViewModelDidRequestAppearance(self)
  }
  
  func showEditContact() {
    delegate?.contactsDetailViewModel(self, didRequestShowEditContact: id)
  }
  
  // MARK: - Private Methods
  func configure() {
    guard let contact = contact else { return }
    
    let image: UIImage?
    if let imageFromDataBase = fileManagerService.loadImage(urlString: id.uuidString) {
      image = imageFromDataBase
    } else {
      image = ImageCreator.imageInitials(name: contact.firstName + " " + (contact.lastName ?? ""))
    }
    
    contactDetailPhotoViewModel.configure(image: image, firstName: contact.firstName, lastName: contact.lastName)
    phoneViewModel.configure(title: R.string.localizable.phone(),
                             description: contact.phoneNumber)
    ringtoneViewModel.configure(title: R.string.localizable.ringtone(),
                                description: contact.ringtone)
    notesViewModel.configure(title: R.string.localizable.notes(),
                             text: contact.notes ?? "")
  }
}
