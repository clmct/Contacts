import Foundation

protocol ContactsListViewModelProtocol {
  var dataSource: SectionedTableViewDataSource { get set }
  func showContact(section: Int, row: Int)
}

protocol ContactsListViewModelDelegate: AnyObject {
  func contactsListViewModel(_ viewModel: ContactsListViewModel, didRequestShowContact contact: String)
}

final class ContactsListViewModel: ContactsListViewModelProtocol {
  // MARK: - Types
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Properties
  weak var delegate: ContactsListViewModelDelegate?
  var dataSource: SectionedTableViewDataSource
  
  // MARK: - Init
  init(dependencies: Dependencies) {
    let contacts = ContactsDataService.getFakeContacts()
    var result: [[Contact]] = []
    var prevInitial: Character?
    for contact in contacts {
      let initial = contact.firstName.first
      if initial != prevInitial {  // We're starting a new letter
        result.append([])
        prevInitial = initial
      }
      result[result.endIndex - 1].append(contact)
    }
    
    var sections = [Section<Contact>]()
    for section in result {
      let section = Section<Contact>(title: section.first?.firstName.first?.uppercased() ?? "#", items: section)
      sections.append(section)
    }
    let dataSources = sections.map { section -> TableViewDataSource<Contact, ContactTableViewCell> in
      return TableViewDataSource.make(for: section.items, titleHeader: section.title)
    }
    dataSource = SectionedTableViewDataSource(dataSources: dataSources)
  }
  
  // MARK: - Public Methods
  func showContact(section: Int, row: Int) {
    delegate?.contactsListViewModel(self, didRequestShowContact: "id")
  }
  // MARK: - Actions
  
  // MARK: - Private Methods
}
