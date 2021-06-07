import Foundation

protocol ContactsListViewModelDelegate: AnyObject {
  func contactsListViewModel(_ viewModel: ContactsListViewModel, didRequestShowDetailContact id: UUID)
  func contactsListViewModelDidRequestShowAddContact(_ viewModel: ContactsListViewModel)
  func contactsListViewModelDidRequestAppearance(_ viewModel: ContactsListViewModel)
}

protocol ContactsListViewModelProtocol {
  var dataSource: SectionedTableViewDataSource? { get set }
  var didUpdateDataSource: (() -> Void)? { get set }
  func showContact(section: Int, row: Int)
  func addContact()
  func fetchContacts()
  func updateSearchResults(with text: String)
  func changeAppearance()
}

final class ContactsListViewModel: ContactsListViewModelProtocol {
  // MARK: - Types
  
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Properties
  
  weak var delegate: ContactsListViewModelDelegate?
  var dataSource: SectionedTableViewDataSource?
  var coreDataService: CoreDataServiceProtocol
  var didUpdateDataSource: (() -> Void)?
  var sections: [Section<Contact>] = []
  var contacts: [Contact] = []
  var filteredContacts: [Contact] = []
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    coreDataService = dependencies.coreDataService
    initDataSource()
  }
  
  // MARK: - Public Methods
  
  func fetchContacts() {
    coreDataService.fetchContacts { [weak self] result in
      switch result {
      case .success(let contacts):
        self?.contacts = contacts
        self?.filteredContacts = contacts
        self?.updateDataSource()
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateSearchResults(with text: String) {
    if text.isEmpty {
      filteredContacts = contacts
      updateDataSource()
      return
    }
    filteredContacts = ContactsDataService.sort(with: text, contacts: contacts)
    updateDataSource()
  }
  
  // MARK: - Delegate
  
  func changeAppearance() {
    delegate?.contactsListViewModelDidRequestAppearance(self)
  }
  
  func showContact(section: Int, row: Int) {
    let id = sections[section].items[row].id
    delegate?.contactsListViewModel(self, didRequestShowDetailContact: id)
  }
  
  func addContact() {
    delegate?.contactsListViewModelDidRequestShowAddContact(self)
  }
  
  // MARK: - Private Methods
  
  private func initDataSource() {
    let dataSources = sections.map { section -> TableViewDataSource<Contact, ContactTableViewCell> in
      return TableViewDataSourceFabric.createDataSource(for: section.items, titleHeader: section.title)
    }
    dataSource = SectionedTableViewDataSource(dataSources: dataSources) { [weak self] section, row in
      if let id = self?.sections[section].items[row].id {
        self?.coreDataService.deleteContact(id: id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self?.fetchContacts()
          self?.didUpdateDataSource?()
        }
      }
    }
  }
  
  private func updateDataSource() {
    sections = ContactsDataService.getSectionsFromContacts(contacts: filteredContacts)
    let dataSources = sections.map { section -> TableViewDataSource<Contact, ContactTableViewCell> in
      return TableViewDataSourceFabric.createDataSource(for: section.items, titleHeader: section.title)
    }
    
    dataSource?.dataSources = dataSources
    didUpdateDataSource?()
  }
}
