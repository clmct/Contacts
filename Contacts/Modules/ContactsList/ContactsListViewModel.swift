import Foundation

protocol ContactsListViewModelProtocol {
  var dataSource: SectionedTableViewDataSource { get set }
  func showContact(section: Int, row: Int)
  func addContact()
}

protocol ContactsListViewModelDelegate: AnyObject {
  func contactsListViewModel(_ viewModel: ContactsListViewModel, didRequestShowDetailContact contact: String)
  func contactsListViewModelDidRequestShowAddContact(_ viewModel: ContactsListViewModel)
}

final class ContactsListViewModel: ContactsListViewModelProtocol {
  // MARK: - Types
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Properties
  weak var delegate: ContactsListViewModelDelegate?
  var dataSource: SectionedTableViewDataSource
  
  // MARK: - Init
  init(dependencies: Dependencies) {
    let sections = ContactsDataService.getFakeContacts()
    let dataSources = sections.map { section -> TableViewDataSource<Contact, ContactTableViewCell> in
      return TableViewDataSource.make(for: section.items, titleHeader: section.title)
    }
    dataSource = SectionedTableViewDataSource(dataSources: dataSources)
  }
  
  // MARK: - Public Methods
  func showContact(section: Int, row: Int) {
    delegate?.contactsListViewModel(self, didRequestShowDetailContact: "id")
  }
  
  func addContact() {
    delegate?.contactsListViewModelDidRequestShowAddContact(self)
  }
}
