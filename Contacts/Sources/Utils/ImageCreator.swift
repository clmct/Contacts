import Foundation

struct ImageCreator {
  static func mergeImages(bottomImage: UIImage) -> UIImage? {
    let topImage = R.image.plus()

    let size = CGSize(width: 40, height: 40)
    UIGraphicsBeginImageContext(size)

    let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let plusSize = CGRect(x: 10, y: 10, width: 20, height: 20)
    bottomImage.draw(in: areaSize)

    topImage?.draw(in: plusSize, blendMode: .normal, alpha: 1)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
  static func imageInitials(name: String?) -> UIImage? {
    let frame = CGRect(x: 0, y: 0, width: 480, height: 480)
    let nameLabel = UILabel(frame: frame)
    nameLabel.textAlignment = .center
    nameLabel.backgroundColor = .basic5
    nameLabel.textColor = .basic7
    nameLabel.font = .basic5
    var initials = ""
    
    if let initialsArray = name?.components(separatedBy: " ") {
      if let firstWord = initialsArray.first {
        if let firstLetter = firstWord.first {
          initials = String(firstLetter).capitalized
        }
      }
      if let lastWord = initialsArray.last, initialsArray.count > 1 {
        if let lastLetter = lastWord.first {
          initials += String(lastLetter).capitalized
        }
      }
    }
    
    nameLabel.text = initials
    UIGraphicsBeginImageContext(frame.size)
    if let currentContext = UIGraphicsGetCurrentContext() {
      nameLabel.layer.render(in: currentContext)
      let nameImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return nameImage
    }
    return nil
  }
}
