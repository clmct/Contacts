import UIKit

final class AppCoordinator: CoordinatorProtocol {
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private let appDependency: AppDependency
  
  init() {
    navigationController = UINavigationController()
    navigationController.navigationBar.prefersLargeTitles = true
    appDependency = AppDependency()
  }
  
  func start() {
    let coordinator = ContactsListCoordinator(appDependency: appDependency,
                                              navigationController: navigationController)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}
