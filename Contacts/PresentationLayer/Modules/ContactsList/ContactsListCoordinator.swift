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
  
  // MARK: - Private Methods
  
  private func navigationControllerSetupAppearance() {
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController.navigationBar.isTranslucent = false
    navigationController.view.backgroundColor = .white
    navigationController.navigationBar.backgroundColor = .white
    navigationController.navigationBar.shadowImage = UIImage()
  }
}

// MARK: - ContactsListViewModelDelegate

extension ContactsListCoordinator: ContactsListViewModelDelegate {
  func contactsListViewModelDidRequestAppearance(_ viewModel: ContactsListViewModel) {
    navigationControllerSetupAppearance()
  }
  
  func contactsListViewModelDidRequestShowAddContact(_ viewModel: ContactsListViewModel) {
    let coordinator = ContactAddEditCoordinator(appDependency: appDependency,
                                                navigationController: navigationController,
                                                stateScreen: .add)
    coordinator.delegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }
  
  func contactsListViewModel(_ viewModel: ContactsListViewModel, didRequestShowDetailContact id: UUID) {
    let coordinator = ContactDetailCoordinator(appDependency: appDependency,
                                               navigationController: navigationController,
                                               id: id)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}

// MARK: - ContactAddCoordinatorDelegate

extension ContactsListCoordinator: ContactAddEditCoordinatorDelegate {
  func contactAddCoordinatorDidFinishAndDeleteContact(_ coordinator: ContactAddEditCoordinator) {
  }
  
  func contactAddCoordinatorDidFinish(_ coordinator: ContactAddEditCoordinator) {
    childCoordinators.removeAll()
  }
}
