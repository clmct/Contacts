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
  
  // MARK: - Private Methods
  
  private func navigationControllerSetupAppearance() {
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController.navigationBar.isTranslucent = false
    navigationController.view.backgroundColor = .basic6
    navigationController.navigationBar.backgroundColor = .basic6
    navigationController.navigationBar.shadowImage = UIImage()
  }
}

extension ContactDetailCoordinator: ContactDetailViewModelDelegate {
  func contactDetailViewModelDidRequestAppearance(_ viewModel: ContactDetailViewModel) {
    navigationControllerSetupAppearance()
  }
  
  func contactsDetailViewModel(_ viewModel: ContactDetailViewModel,
                               didRequestShowEditContact contact: UUID) {
    let coordinator = ContactAddEditCoordinator(appDependency: appDependency,
                                                navigationController: navigationController,
                                                stateScreen: .edit(id: contact))
    coordinator.delegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}

extension ContactDetailCoordinator: ContactAddEditCoordinatorDelegate {
  func contactAddCoordinatorDidFinish(_ coordinator: ContactAddEditCoordinator) {
    childCoordinators.removeAll()
  }
}
