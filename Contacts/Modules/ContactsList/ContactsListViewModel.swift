import Foundation

protocol ContactsListViewModelProtocol {
  var dataSource: SectionedTableViewDataSource { get set }
  var didUpdateData: (() -> Void)? { get set }
  func showContact(section: Int, row: Int)
  func addContact()
  func fetchContacts()
}

protocol ContactsListViewModelDelegate: AnyObject {
  func contactsListViewModel(_ viewModel: ContactsListViewModel, didRequestShowDetailContact id: UUID)
  func contactsListViewModelDidRequestShowAddContact(_ viewModel: ContactsListViewModel)
}

final class ContactsListViewModel: ContactsListViewModelProtocol {
  // MARK: - Types
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Properties
  weak var delegate: ContactsListViewModelDelegate?
  var dataSource: SectionedTableViewDataSource
  var coreDataService: CoreDataServiceProtocol
  var didUpdateData: (() -> Void)?
  var sections: [Section<Contact>]?
  
  // MARK: - Init
  init(dependencies: Dependencies) {
    coreDataService = dependencies.coreDataService
    
    let sections = ContactsDataService.getFakeContacts()
    let dataSources = sections.map { section -> TableViewDataSource<Contact, ContactTableViewCell> in
      return TableViewDataSource.make(for: section.items, titleHeader: section.title)
    }
    dataSource = SectionedTableViewDataSource(dataSources: dataSources)
  }
  
  func fetchContacts() {
    coreDataService.fetchContacts { [weak self] result in
      switch result {
      case .success(let contacts):
        
        let sections = ContactsDataService.getSectionsFromContacts(contacts: contacts)
        self?.sections = sections
        let dataSources = sections.map { section -> TableViewDataSource<Contact, ContactTableViewCell> in
          return TableViewDataSource.make(for: section.items, titleHeader: section.title)
        }
        self?.dataSource = SectionedTableViewDataSource(dataSources: dataSources)
        self?.didUpdateData?()
      case .failure(let error):
        print(error)
      }
    }
  }
  
  // MARK: - Public Methods
  func showContact(section: Int, row: Int) {
    print("show")
    guard let id = sections?[section].items[row].id else { return }
    delegate?.contactsListViewModel(self, didRequestShowDetailContact: id)
  }
  
  func addContact() {
    delegate?.contactsListViewModelDidRequestShowAddContact(self)
  }
}
