import UIKit

protocol ContactEditCoordinatorDelegate: class {
}

final class ContactEditCoordinator: CoordinatorProtocol {
  // MARK: - Properties
  weak var delegate: ContactEditCoordinatorDelegate?
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
    let viewModel = ContactEditViewModel(dependencies: appDependency)
    let viewController = ContactEditViewController(viewModel: viewModel)
    viewController.modalPresentationStyle = .fullScreen
    navigationController.pushViewController(viewController, animated: false)
//    navigationController.present(viewController, animated: false)
  }
  
  // MARK: - Private Methods
}
