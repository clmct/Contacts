import Foundation

protocol ContactsListViewModelProtocol {
  var dataSource: SectionedTableViewDataSource? { get set }
  var didUpdateData: (() -> Void)? { get set }
  func showContact(section: Int, row: Int)
  func addContact()
  func fetchContacts()
  func requestUpdateSearchResults(with text: String)
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
  var dataSource: SectionedTableViewDataSource?
  var coreDataService: CoreDataServiceProtocol
  var didUpdateData: (() -> Void)?
  var sections: [Section<Contact>]?
  var contacts: [Contact] = []
  var filteredContacts: [Contact] = []
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    coreDataService = dependencies.coreDataService
  }
  
  // MARK: - Public Methods
  
  func fetchContacts() {
    coreDataService.fetchContacts { [weak self] result in
      switch result {
      case .success(let contacts):
        self?.contacts = contacts
        self?.filteredContacts = contacts
        self?.updateTableView()
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateTableView() {
    let sections = ContactsDataService.getSectionsFromContacts(contacts: filteredContacts)
    self.sections = sections
    let dataSources = sections.map { section -> TableViewDataSource<Contact, ContactTableViewCell> in
      return TableViewDataSource.make(for: section.items, titleHeader: section.title)
    }
    dataSource = SectionedTableViewDataSource(dataSources: dataSources)
    didUpdateData?()
  }
  
  func requestUpdateSearchResults(with text: String) {
    if text.isEmpty {
      filteredContacts = contacts
      updateTableView()
      return
    }
    filteredContacts = ContactsDataService.sort(with: text, contacts: contacts)
    updateTableView()
  }
  
  func showContact(section: Int, row: Int) {
    guard let id = sections?[section].items[row].id else { return }
    delegate?.contactsListViewModel(self, didRequestShowDetailContact: id)
  }
  
  func addContact() {
    delegate?.contactsListViewModelDidRequestShowAddContact(self)
  }
}
