import UIKit

final class ContactsListCoordinator: CoordinatorProtocol {
  // MARK: - Properties
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
}

// MARK: - ContactsListViewModelDelegate
extension ContactsListCoordinator: ContactsListViewModelDelegate {
  func contactsListViewModelDidRequestShowAddContact(_ viewModel: ContactsListViewModel) {
    let coordinator = ContactAddCoordinator(appDependency: appDependency,
                                            navigationController: navigationController)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
  
  func contactsListViewModel(_ viewModel: ContactsListViewModel, didRequestShowDetailContact contact: String) {
    let coordinator = ContactDetailCoordinator(appDependency: appDependency,
                                               navigationController: navigationController)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}
