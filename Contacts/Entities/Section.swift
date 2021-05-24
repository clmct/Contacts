import UIKit

struct Section<Item> {
  var title: String
  var items: [Item]
}

struct DataSource<Item> {
  var sections: [Section<Item>]
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItems(in section: Int) -> Int {
    guard section < sections.count else { return 0 }
    return sections[section].items.count
  }
  
  func item(at indexPath: IndexPath) -> Item {
    return sections[indexPath.section].items[indexPath.row]
  }
}

protocol ConfiguratorType {
  associatedtype Item
  associatedtype Cell: UITableViewCell
  
  func reuseIdentifier(for item: Item, indexPath: IndexPath) -> String
  func configuredCell(for item: Item, tableView: UITableView, indexPath: IndexPath) -> Cell
  func registerCells(in tableView: UITableView)
}
