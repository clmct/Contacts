import UIKit

// MARK: - ContactAddCoordinatorDelegate

protocol ContactAddEditCoordinatorDelegate: AnyObject {
  func contactAddCoordinatorDidFinish(_ coordinator: ContactAddEditCoordinator)
}

final class ContactAddEditCoordinator: CoordinatorProtocol {
  // MARK: - Properties
  
  weak var delegate: ContactAddEditCoordinatorDelegate?
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private let appDependency: AppDependency
  weak var contactAddViewModel: ContactAddEditViewModel?
  private var imagePickerCoordinator: ImagePickerCoordinator?
  private let stateScreen: StateScreen
  
  // MARK: - Init
  
  init(appDependency: AppDependency,
       navigationController: UINavigationController,
       stateScreen: StateScreen) {
    self.appDependency = appDependency
    self.navigationController = navigationController
    self.stateScreen = stateScreen
  }
  
  // MARK: - Public Methods
  
  func start() {
    let viewModel = ContactAddEditViewModel(dependencies: appDependency, stateScreen: stateScreen)
    contactAddViewModel = viewModel
    let viewController = ContactAddEditViewController(viewModel: viewModel)
    viewModel.delegate = self
    
    switch stateScreen {
    case .add:
      navigationController.modalPresentationStyle = .fullScreen
      navigationController.pushViewController(viewController, animated: true)
    default:
    viewController.modalPresentationStyle = .fullScreen
    navigationController.pushViewController(viewController, animated: false)
    }
  }
  
  // MARK: - Private Methods
  
  private func navigationControllerSetupAppearance() {
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController.navigationBar.isTranslucent = true
    navigationController.view.backgroundColor = .white
    navigationController.navigationBar.backgroundColor = .white
    navigationController.navigationBar.shadowImage = UIImage()
  }
}

// MARK: - ContactAddViewModelDelegate

extension ContactAddEditCoordinator: ContactAddViewModelDelegate {
  func contactAddViewModelDidRequestAppearance(_ viewModel: ContactAddEditViewModel) {
    navigationControllerSetupAppearance()
  }
  
  func contactAddCoordinatorDidFinishAndDeleteContact(_ viewModel: ContactAddEditViewModel) {
    navigationController.showDeleteContactAlert { [weak self] state in
      guard let self = self else { return }
      switch state {
      case .delete:
        self.contactAddViewModel?.deleteContactFromDataBase()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.navigationController.popToRootViewController(animated: true)
          self.delegate?.contactAddCoordinatorDidFinish(self)
        }
      case .cancel:
        break
      }
    }
  }
  
  func contactAddViewModelDidFinish(_ viewModel: ContactAddEditViewModel) {
    switch stateScreen {
    case .add:
      navigationController.popViewController(animated: false)
    default:
      navigationController.popViewController(animated: false)
    }
    delegate?.contactAddCoordinatorDidFinish(self)
  }
  
  func contactAddViewModelDidRequestShowImagePicker(_ viewModel: ContactAddEditViewModel) {
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
      case .alertSimulator, .cancel:
        break
      }
    }
  }
}

// MARK: - ImagePickerCoordinatorDelegate

extension ContactAddEditCoordinator: ImagePickerCoordinatorDelegate {
  func imagePickerCoordinator(_ coordinator: ImagePickerCoordinator, didSelectImage: UIImage?) {
    guard let image = didSelectImage else { return }
    contactAddViewModel?.updateImage(image: image)
  }
}

// MARK: - ImagePickerPresentingProtocol

extension ContactAddEditCoordinator: ImagePickerPresentingProtocol { }
