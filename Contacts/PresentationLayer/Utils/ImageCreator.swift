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
}
