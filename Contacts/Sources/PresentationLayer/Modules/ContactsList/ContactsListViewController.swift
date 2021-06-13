import UIKit
import SnapKit

final class ContactsListViewController: UIViewController {
  // MARK: - Properties
  
  private var viewModel: ContactsListViewModelProtocol
  
  private let tableView = UITableView()
  private let searchController = UISearchController()
  private let refreshControl = UIRefreshControl()
  private let loader = UIActivityIndicatorView(style: .medium)
  
  lazy var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                target: self ,
                                                action: #selector(addContact))
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.changeAppearance()
    viewModel.fetchContacts()
  }
  // MARK: - Private Actions
  
  @objc
  private func addContact() {
    viewModel.addContact()
  }
  
  // MARK: - Private Methods
  
  private func bindToViewModel() {
    viewModel.didUpdateDataSource = { [weak self] in
      guard let self = self else { return }
      self.tableView.dataSource = self.viewModel.dataSource
      self.tableView.reloadData()
    }
    
    viewModel.didRequestStart = { [weak self] in
      guard let self = self else { return }
      self.loader.startAnimating()
    }
    
    viewModel.didRequestEnd = { [weak self] in
      guard let self = self else { return }
      self.loader.stopAnimating()
    }
  }
  
  private func setupLayout() {
    title = R.string.localizable.contacts()
    
    setupTableView()
    setupNavigationItem()
    setupLoader()
  }
  
  private func setupLoader() {
    view.addSubview(loader)
    view.bringSubviewToFront(loader)
    loader.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }
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
