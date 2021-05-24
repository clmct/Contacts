import Foundation

protocol ContactsListViewModelProtocol {
  var contactsSection: [Section<Contact>] { get set }
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
  var contactsSection: [Section<Contact>]
  
  // MARK: - Init
  init(dependencies: Dependencies) {
    let contact1 = Contact(photo: nil,
                           firstName: "Alex - 1",
                           lastName: "Martin",
                           phoneNumber: "44-66-77",
                           ringtone: "ring",
                           notes: "notes")
    let contact2 = Contact(photo: nil,
                           firstName: "Alex - 2",
                           lastName: "Martin",
                           phoneNumber: "44-66-77",
                           ringtone: "ring",
                           notes: "notes")
    let contact3 = Contact(photo: nil,
                           firstName: "Alex - 3",
                           lastName: "Martin",
                           phoneNumber: "44-66-77",
                           ringtone: "ring",
                           notes: "notes")
    contactsSection = [Section<Contact>(title: "", items: [contact1, contact2]),
                       Section<Contact>(title: "", items: [contact3])]
    
    let contacts1 = contactsSection[0].items
    let contacts2 = contactsSection[1].items
    
    dataSource = SectionedTableViewDataSource(dataSources: [
      TableViewDataSource.make(for: contacts1, titleHeader: "A"),
      TableViewDataSource.make(for: contacts2, titleHeader: "B"),
      TableViewDataSource.make(for: contacts2, titleHeader: "C"),
      TableViewDataSource.make(for: contacts2, titleHeader: "D"),
      TableViewDataSource.make(for: contacts1, titleHeader: "E")
    ])
    
//    for section in contactsSection {
//      let dataSource = TableViewDataSource.make(for: section.items, titleHeader: section.title)
//      sectionedTableViewDataSource.addDataSource(dataSource: dataSource)
//    }
//    sectionedTableViewDataSource = SectionedTableViewDataSource(dataSources: [])

  }
  
  // MARK: - Public Methods
  func showContact(section: Int, row: Int) {
    delegate?.contactsListViewModel(self, didRequestShowContact: "id")
  }
  // MARK: - Actions
  
  // MARK: - Private Methods
}
