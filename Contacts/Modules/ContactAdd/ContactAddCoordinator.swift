import UIKit

// MARK: - ContactAddCoordinatorDelegate

protocol ContactAddCoordinatorDelegate: AnyObject {
  func contactAddCoordinatorDidFinish(_ coordinator: ContactAddCoordinator)
}

final class ContactAddCoordinator: CoordinatorProtocol {
  // MARK: - Properties
  
  weak var delegate: ContactAddCoordinatorDelegate?
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private let appDependency: AppDependency
  weak var contactAddViewModel: ContactAddViewModel?
  private var imagePickerCoordinator: ImagePickerCoordinator?
  
  // MARK: - Init
  
  init(appDependency: AppDependency,
       navigationController: UINavigationController) {
    self.appDependency = appDependency
    self.navigationController = navigationController
  }
  
  // MARK: - Public Methods
  
  func start() {
    let viewModel = ContactAddViewModel(dependencies: appDependency)
    contactAddViewModel = viewModel
    let viewController = ContactAddViewController(viewModel: viewModel)
    viewModel.delegate = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Private Methods
  private func navigationControllerSetupAppearance() {
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController.navigationBar.isTranslucent = true
    navigationController.view.backgroundColor = UIColor.clear
    navigationController.navigationBar.barTintColor = .clear
    navigationController.navigationBar.backgroundColor = .clear
    navigationController.navigationBar.shadowImage = UIImage()
  }
}

// MARK: - ContactAddViewModelDelegate

extension ContactAddCoordinator: ContactAddViewModelDelegate {
  func contactAddViewModelDidRequestAppearance(_ viewModel: ContactAddViewModel) {
    navigationControllerSetupAppearance()
  }
  
  func contactAddViewModelDidFinish(_ viewModel: ContactAddViewModel) {
    navigationController.popViewController(animated: true)
    delegate?.contactAddCoordinatorDidFinish(self)
  }
  
  func contactAddViewModelDidRequestShowImagePicker(_ viewModel: ContactAddViewModel) {
    navigationController.showImagePickerAlert { [weak self] state in
      guard let self = self else { return }
      switch state {
      case .camera:
        self.imagePickerCoordinator = self.showImagePicker(sourceType: .camera,
                                                           navigationController: self.navigationController,
                                                           delegate: self)
      case .library:
        self.imagePickerCoordinator = self.showImagePicker(sourceType: .photoLibrary,
                                                           navigationController: self.navigationController,
                                                           delegate: self)
      case .alertSimulator:
        break
      }
    }
  }
}

// MARK: - ImagePickerCoordinatorDelegate

extension ContactAddCoordinator: ImagePickerCoordinatorDelegate {
  func imagePickerCoordinator(coordinator: ImagePickerCoordinator, didSelectImage: UIImage?) {
    guard let image = didSelectImage else { return }
    contactAddViewModel?.updateImage(image: image)
  }
}

// MARK: - ImagePickerPresentingProtocol

extension ContactAddCoordinator: ImagePickerPresentingProtocol { }
