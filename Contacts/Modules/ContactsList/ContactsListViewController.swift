import UIKit
import SnapKit

final class ContactsListViewController: UIViewController {
  // MARK: - Properties
  private let viewModel: ContactsListViewModelProtocol
  
  private let tableView = UITableView()
  private let searchController = UISearchController()
  private var dataSource: TableViewDataSource<Contact, ContactTableViewCell>?
  
  // MARK: - Init
  init(viewModel: ContactsListViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    bindToViewModel()
  }
  
  // MARK: - Public Methods
  
  // MARK: - Actions
  
  // MARK: - Private Methods
  private func bindToViewModel() {
  }
  
  private func setupLayout() {
    view.backgroundColor = .red
    title = "Contacts"
    setupTableView()
    setupNavigationItem()
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(view.snp.top)
      make.bottom.equalTo(view.snp.bottom)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
    }
    
    tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
    
//    let contacts: [[Contact]]
//    let identifier = ContactTableViewCell.identifier
//    let dataSource = TableViewDataSource<Contact, ContactTableViewCell>(models: contacts,
//                                                                        reuseIdentifier: identifier) { contact, cell in
//      cell.configure(with: contact)
//    } titleConfigurator: { models, title  in
//    }
//    self.dataSource = dataSource
//    tableView.dataSource = dataSource
//    tableView.delegate = self
  }
  
  private func setupNavigationItem() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
  }
  
}

extension ContactsListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
  }
}

extension ContactsListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    44
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}
