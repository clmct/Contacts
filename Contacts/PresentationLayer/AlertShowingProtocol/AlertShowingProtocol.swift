import UIKit

protocol AlertShowingProtocol {}

extension AlertShowingProtocol where Self: UINavigationController {
  func showImagePickerAlert(completion: @escaping (ShowPhotoAlertState) -> Void) {
    let photoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
    photoAlert.addAction(cancelAction)
    
    let cameraAction = UIAlertAction(title: R.string.localizable.takePhoto(), style: .default) { _ in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        completion(.camera)
      } else {
        completion(.alertSimulator)
      }
    }
    photoAlert.addAction(cameraAction)
    
    let libraryAction = UIAlertAction(title: R.string.localizable.choosePhoto(), style: .default) { _ in
      completion(.library)
    }
    photoAlert.addAction(libraryAction)
    present(photoAlert, animated: true, completion: nil)
  }
}
