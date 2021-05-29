import UIKit

protocol ContactAddCoordinatorDelegate: class {
}

final class ContactAddCoordinator: CoordinatorProtocol {
  // MARK: - Properties
  weak var delegate: ContactAddCoordinatorDelegate?
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
    let viewModel = ContactAddViewModel(dependencies: appDependency)
    let viewController = ContactAddViewController(viewModel: viewModel)
//    viewModel.delegate = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Private Methods
}
