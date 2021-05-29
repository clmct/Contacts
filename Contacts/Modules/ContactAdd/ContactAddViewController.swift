import UIKit

final class ContactAddViewController: UIViewController {
  // MARK: - Properties
  private let viewModel: ContactAddViewModelProtocol
  
  // MARK: - Init
  init(viewModel: ContactAddViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    bindToViewModel()
    view.backgroundColor = .systemTeal
  }
  
  // MARK: - Public Methods
  
  // MARK: - Actions
  
  // MARK: - Private Methods
  private func bindToViewModel() {
  }
}
