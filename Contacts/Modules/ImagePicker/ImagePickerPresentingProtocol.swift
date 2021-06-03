import UIKit

protocol ImagePickerPresentingProtocol { }

extension ImagePickerPresentingProtocol {
  func showImagePicker(sourceType: UIImagePickerController.SourceType,
                       navigationController: UINavigationController,
                       delegate: ImagePickerCoordinatorDelegate) -> ImagePickerCoordinator {
    let imagePickerCoordinator = ImagePickerCoordinator(sourceType: sourceType,
                                                        navigationController: navigationController)
    imagePickerCoordinator.delegate = delegate
    imagePickerCoordinator.start()
    return imagePickerCoordinator
  }
}
