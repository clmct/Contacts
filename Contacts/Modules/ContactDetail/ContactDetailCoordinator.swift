import UIKit

protocol ContactDetailCoordinatorDelegate: AnyObject {
}

final class ContactDetailCoordinator: CoordinatorProtocol {
  // MARK: - Properties
  weak var delegate: ContactDetailCoordinatorDelegate?
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
    let viewModel = ContactDetailViewModel(dependencies: appDependency)
    viewModel.delegate = self
    let viewController = ContactDetailViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension ContactDetailCoordinator: ContactDetailViewModelDelegate {
  func contactsDetailViewModel(_ viewModel: ContactDetailViewModel,
                               didRequestShowEditContact contact: String) {
    let coordinator = ContactEditCoordinator(appDependency: appDependency,
                                             navigationController: navigationController)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}
