import UIKit

// MARK: - ContactDetailCoordinatorDelegate

protocol ContactDetailCoordinatorDelegate: AnyObject {
  func contactDetailCoordinatorDidFinish(_ coordinator: ContactDetailCoordinator)
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
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.backgroundColor = .basic6
    navBarAppearance.shadowColor = .clear
    navigationController.navigationBar.standardAppearance = navBarAppearance
    navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
  }
}

extension ContactDetailCoordinator: ContactDetailViewModelDelegate {
  func contactDetailViewModelDidFinish(_ viewModel: ContactDetailViewModel) {
    delegate?.contactDetailCoordinatorDidFinish(self)
  }
  
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
