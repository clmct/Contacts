import UIKit

protocol AlertShowingProtocol {}

extension AlertShowingProtocol where Self: UINavigationController {
  func showImagePickerAlert(completion: @escaping (ShowPhotoAlertState) -> Void) {
    let photoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel) { _ in 
      DispatchQueue.main.async {
        completion(.camera)
      }
    }
    photoAlert.addAction(cancelAction)
    
    let cameraAction = UIAlertAction(title: R.string.localizable.takePhoto(), style: .default) { _ in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        DispatchQueue.main.async {
          completion(.camera)
        }
      } else {
        DispatchQueue.main.async {
          completion(.alertSimulator)
        }
        
      }
    }
    photoAlert.addAction(cameraAction)
    
    let libraryAction = UIAlertAction(title: R.string.localizable.choosePhoto(), style: .default) { _ in
      completion(.library)
    }
    photoAlert.addAction(libraryAction)
    present(photoAlert, animated: true, completion: nil)
  }
  
  func showDeleteContactAlert(completion: @escaping (ShowDeleteAlertState) -> Void) {
    let photoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel) { _ in
      DispatchQueue.main.async {
        completion(.cancel)
      }
    }
    photoAlert.addAction(cancelAction)
    
    let deleteAction = UIAlertAction(title: R.string.localizable.delete(), style: .destructive) { _ in
      DispatchQueue.main.async {
        completion(.delete)
      }
    }
    photoAlert.addAction(deleteAction)
    
    present(photoAlert, animated: true, completion: nil)
  }
}

enum ShowDeleteAlertState {
  case delete
  case cancel
}
