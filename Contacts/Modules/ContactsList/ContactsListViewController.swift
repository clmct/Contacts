import UIKit
import SnapKit

final class ContactsListViewController: UIViewController {
  // MARK: - Properties
  
  private var viewModel: ContactsListViewModelProtocol
  
  private let tableView = UITableView()
  private let searchController = UISearchController()
  private var refreshControl = UIRefreshControl()
  
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
    viewModel.fetchContacts()
  }
  
  // Appearance change
  
  /*
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }
  */
  
  // MARK: - Private Actions
  
  @objc
  private func addContact() {
    viewModel.addContact()
  }
  
  // MARK: - Private Methods
  
  private func bindToViewModel() {
    viewModel.didUpdateDataSource = { [weak self] in
      self?.tableView.dataSource = self?.viewModel.dataSource
      self?.tableView.reloadData()
    }
  }
  
  private func setupLayout() {
    view.backgroundColor = .red
    title = R.string.localizable.contacts()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self ,
                                                        action: #selector(addContact))
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
    tableView.delegate = self
  }
  
  private func setupNavigationItem() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    
  }
}

// MARK: - UISearchResultsUpdating

extension ContactsListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    viewModel.updateSearchResults(with: text)
  }
}

// MARK: - UITableViewDelegate

extension ContactsListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.showContact(section: indexPath.section, row: indexPath.row)
  }
}
