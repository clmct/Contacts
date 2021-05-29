import UIKit

/*
 enum FileManagerStatusOperation {
    case success
    case failure
 }
*/

protocol FileManagerServiceProtocol {
  func saveImage(image: UIImage, urlString: String)
  func loadImage(urlString: String) -> UIImage?
}

final class FileManagerService: FileManagerServiceProtocol {
  private let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  
  func saveImage(image: UIImage, urlString: String) {
    guard let directory = directory,
          let data = image.jpegData(compressionQuality: 1) else {
      return
    }
    let url = directory.appendingPathComponent(urlString)
    do {
      try data.write(to: url)
    } catch {
      print("Error in \(#function)")
    }
  }
  
  func loadImage(urlString: String) -> UIImage? {
    guard let directory = directory else { return nil }
    let url = directory.appendingPathComponent(urlString)
    let image = UIImage(contentsOfFile: url.path)
    if image == nil {
      print("Error in \(#function)")
    }
    return image
  }
}
