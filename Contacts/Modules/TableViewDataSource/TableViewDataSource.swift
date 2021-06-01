import UIKit

final class TableViewDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
  typealias CellConfigurator = (Model, Cell) -> Void
  typealias TitleConfigurator = (inout String) -> Void
  
  // MARK: Properties
  
  private var models: [Model]
  private let reuseIdentifier: String
  private let cellConfigurator: CellConfigurator
  private let titleConfigurator: TitleConfigurator
  
  // MARK: Init
  
  init(models: [Model],
       reuseIdentifier: String,
       cellConfigurator: @escaping CellConfigurator,
       titleConfigurator: @escaping TitleConfigurator) {
    self.models = models
    self.reuseIdentifier = reuseIdentifier
    self.cellConfigurator = cellConfigurator
    self.titleConfigurator = titleConfigurator
  }
  
  // MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var titleForHeaderInSection = ""
    titleConfigurator(&titleForHeaderInSection)
    return titleForHeaderInSection
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Cell else {
      let cell = UITableViewCell()
      return cell
    }
    cellConfigurator(model, cell)
    return cell
  }
}

// MARK: Make

extension TableViewDataSource where Model == Contact, Cell == ContactTableViewCell {
  static func make(for contacts: [Contact],
                   reuseIdentifier: String = Cell.identifier,
                   titleHeader: String) -> TableViewDataSource {
    
    let dataSource = TableViewDataSource<Contact, ContactTableViewCell>(models: contacts,
                                                                        reuseIdentifier: reuseIdentifier) { contact, cell in
      cell.configure(with: contact)
    } titleConfigurator: { titleForHeader  in
      titleForHeader = titleHeader
    }
    return dataSource
  }
}
