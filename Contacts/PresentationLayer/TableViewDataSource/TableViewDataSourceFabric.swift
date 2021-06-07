import Foundation

final class TableViewDataSourceFabric { }

extension TableViewDataSourceFabric {
  static func createDataSource(for contacts: [Contact],
                               reuseIdentifier: String = ContactTableViewCell.identifier,
                               titleHeader: String) -> TableViewDataSource<Contact, ContactTableViewCell> {
    let dataSource = TableViewDataSource<Contact, ContactTableViewCell>(models: contacts,
                                                                        reuseIdentifier: reuseIdentifier) { contact, cell in
      cell.configure(with: contact)
    } onDidUpdateTitle: { titleForHeader  in
      titleForHeader = titleHeader
    }
    return dataSource
  }
}
