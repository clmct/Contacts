import Foundation

final class TableViewDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
  typealias CellClosure = (Model, Cell) -> Void
  typealias TitleClosure = (inout String) -> Void
  
  // MARK: - Properties
  
  private var models: [Model]
  private let reuseIdentifier: String
  private let onDidUpdateCell: CellClosure
  private let onDidUpdateTitle: TitleClosure
  
  // MARK: - Init
  
  init(models: [Model],
       reuseIdentifier: String,
       onDidUpdateCell: @escaping CellClosure,
       onDidUpdateTitle: @escaping TitleClosure) {
    self.models = models
    self.reuseIdentifier = reuseIdentifier
    self.onDidUpdateCell = onDidUpdateCell
    self.onDidUpdateTitle = onDidUpdateTitle
  }
  
  // MARK: - UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var titleForHeaderInSection = ""
    onDidUpdateTitle(&titleForHeaderInSection)
    return titleForHeaderInSection
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Cell else {
      let cell = UITableViewCell()
      return cell
    }
    onDidUpdateCell(model, cell)
    return cell
  }
}
