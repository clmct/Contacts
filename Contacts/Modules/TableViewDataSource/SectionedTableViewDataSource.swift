import UIKit

class SectionedTableViewDataSource: NSObject {
  private var dataSources: [UITableViewDataSource]
  
  func addDataSource(dataSource: UITableViewDataSource) {
    dataSources.append(dataSource)
  }
  
  init(dataSources: [UITableViewDataSource]) {
    self.dataSources = dataSources
  }
}

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
    return ["1", "2", "3", "4", "5", "6"]
  }
  
  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    return 1
  }
}
