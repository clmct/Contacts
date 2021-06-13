import UIKit

protocol FileManagerServiceProtocol {
  func saveImage(image: UIImage, urlString: String, completion: @escaping () -> Void)
  func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void)
}

final class FileManagerService: FileManagerServiceProtocol {
  private let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  private let concurrentQueue = DispatchQueue(label: "contacts.concurrent.queue", attributes: .concurrent)
  
  func saveImage(image: UIImage, urlString: String, completion: @escaping () -> Void) {
    concurrentQueue.async {
      guard let directory = self.directory,
            let data = image.jpegData(compressionQuality: 1) else {
              DispatchQueue.main.async {
                completion()
              }
              return
            }
      let url = directory.appendingPathComponent(urlString)
      do {
        try data.write(to: url)
        DispatchQueue.main.async {
          completion()
        }
      } catch {
        print("Error in \(#function)")
        DispatchQueue.main.async {
          completion()
        }
      }
    }
  }
  
  func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
    concurrentQueue.async {
      guard let directory = self.directory else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      let url = directory.appendingPathComponent(urlString)
      let image = UIImage(contentsOfFile: url.path)
      if image == nil {
        print("Error in \(#function)")
      }
      DispatchQueue.main.async {
        completion(image)
      }
    }
  }
}
