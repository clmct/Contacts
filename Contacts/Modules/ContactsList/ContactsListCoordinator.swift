import UIKit

protocol ContactsListCoordinatorDelegate: AnyObject {
}

final class ContactsListCoordinator: CoordinatorProtocol {
  // MARK: - Properties
  weak var delegate: ContactsListCoordinatorDelegate?
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private let appDependency: AppDependency
  
  // MARK: - Init
  init(appDependency: AppDependency,
       navigationController: UINavigationController) {
    self.appDependency = appDependency
    self.navigationController = navigationController
  }
  
  // MARK: - Public Methods
  func start() {
    let viewModel = ContactsListViewModel(dependencies: appDependency)
    let viewController = ContactsListViewController(viewModel: viewModel)
    viewModel.delegate = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Private Methods
}

extension ContactsListCoordinator: ContactsListViewModelDelegate {
  func contactsListViewModel(_ viewModel: ContactsListViewModel, didRequestShowContact contact: String) {
    let coordinator = ContactDetailCoordinator(appDependency: appDependency,
                                               navigationController: navigationController)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}
