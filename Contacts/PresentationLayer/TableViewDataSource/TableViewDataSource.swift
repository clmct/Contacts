import Foundation

final class TableViewDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
  typealias CellConfigurator = (Model, Cell) -> Void
  typealias TitleConfigurator = (inout String) -> Void
  
  // MARK: - Properties
  
  private var models: [Model]
  private let reuseIdentifier: String
  private let onUpdateCell: CellConfigurator
  private let onUpdateTitle: TitleConfigurator
  
  // MARK: - Init
  
  init(models: [Model],
       reuseIdentifier: String,
       onUpdateCell: @escaping CellConfigurator,
       onUpdateTitle: @escaping TitleConfigurator) {
    self.models = models
    self.reuseIdentifier = reuseIdentifier
    self.onUpdateCell = onUpdateCell
    self.onUpdateTitle = onUpdateTitle
  }
  
  // MARK: - UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var titleForHeaderInSection = ""
    onUpdateTitle(&titleForHeaderInSection)
    return titleForHeaderInSection
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Cell else {
      let cell = UITableViewCell()
      return cell
    }
    onUpdateCell(model, cell)
    return cell
  }
}
