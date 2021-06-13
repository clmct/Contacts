import Foundation

final class TableViewDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
  typealias CellClosure = (Model, Cell) -> Void
  typealias TitleClosure = () -> String
  
  // MARK: - Properties
  
  private var models: [Model]
  private let reuseIdentifier: String
  private let onUpdateCell: CellClosure
  private let onUpdateTitle: TitleClosure
  
  // MARK: - Init
  
  init(models: [Model],
       reuseIdentifier: String,
       onUpdateCell: @escaping CellClosure,
       onUpdateTitle: @escaping TitleClosure) {
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
    let titleForHeaderInSection = onUpdateTitle()
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
