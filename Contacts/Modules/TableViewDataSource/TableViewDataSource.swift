import UIKit

/*
    Проблема - класс не похож на универсальный, так как имеет определенную конфигурацию.
    Если заменить Model на протокол, то тогда можно избавиться от двумерного массива.
    Тогда получится, что я просто вынес логику определенного DataSource(это ли требовалось)
    Как можно сделать универсальную обертку над UITableViewDataSource?
    P.S: NSDiffableDataSource)
*/
final class TableViewDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
  typealias CellConfigurator = (Model, Cell) -> Void
  typealias TitleConfigurator = ([Model], inout String) -> Void
  
  private var models: [[Model]]
  private let reuseIdentifier: String
  private let cellConfigurator: CellConfigurator
  private let titleConfigurator: TitleConfigurator
  
  init(models: [[Model]],
       reuseIdentifier: String,
       cellConfigurator: @escaping CellConfigurator,
       titleConfigurator: @escaping TitleConfigurator) {
    self.models = models
    self.reuseIdentifier = reuseIdentifier
    self.cellConfigurator = cellConfigurator
    self.titleConfigurator = titleConfigurator
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models[section].count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let model = models[section]
    var titleForHeaderInSection = "titleForHeaderInSection"
    titleConfigurator(model, &titleForHeaderInSection)
    return titleForHeaderInSection
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.section][indexPath.row]
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Cell else {
      let cell = UITableViewCell()
      return cell
    }
    cellConfigurator(model, cell)
    return cell
  }
}
