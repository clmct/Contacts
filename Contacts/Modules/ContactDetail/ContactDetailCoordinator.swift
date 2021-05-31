import UIKit

protocol ContactDetailCoordinatorDelegate: AnyObject {
}

final class ContactDetailCoordinator: CoordinatorProtocol {
  // MARK: - Properties
  weak var delegate: ContactDetailCoordinatorDelegate?
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private let appDependency: AppDependency
  private let id: UUID
  
  // MARK: - Init
  init(appDependency: AppDependency,
       navigationController: UINavigationController,
       id: UUID) {
    self.appDependency = appDependency
    self.navigationController = navigationController
    self.id = id
  }
  
  // MARK: - Public Methods
  func start() {
    let viewModel = ContactDetailViewModel(dependencies: appDependency, id: id)
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
