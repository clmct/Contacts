import Foundation

class SectionedTableViewDataSource: NSObject {
  typealias DeleteClosure = (_ section: Int, _ row: Int) -> Void
  
  var dataSources: [UITableViewDataSource]
  private var onDeleteCell: DeleteClosure
  
  func addDataSource(dataSource: UITableViewDataSource) {
    dataSources.append(dataSource)
  }
  
  init(dataSources: [UITableViewDataSource],
       onDeleteCell: @escaping DeleteClosure) {
    self.dataSources = dataSources
    self.onDeleteCell = onDeleteCell
  }
}

// MARK: - UITableViewDataSource

extension SectionedTableViewDataSource: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSources.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let dataSource = dataSources[section]
    return dataSource.tableView?(tableView, titleForHeaderInSection: section)
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    let dataSource = dataSources[section]
    return dataSource.tableView(tableView, numberOfRowsInSection: section)
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dataSource = dataSources[indexPath.section]
    let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
    return dataSource.tableView(tableView, cellForRowAt: indexPath)
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return UILocalizedIndexedCollation.current().sectionIndexTitles
  }
  
  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      onDeleteCell(indexPath.section, indexPath.row)
    }
  }
}
