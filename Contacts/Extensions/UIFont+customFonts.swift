import UIKit

extension UIFont {
  static func regularAppFont(ofSize size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size, weight: .regular)
  }
  
  static func boldAppFont(ofSize size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size, weight: .bold)
  }
  
  static func mediumAppFont(ofSize size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size, weight: .medium)
  }
  
  static func semiboldAppFont(ofSize size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size, weight: .semibold)
  }
  
  static let basic1 = UIFont.regularAppFont(ofSize: 17)
  static let basic2 = UIFont.boldAppFont(ofSize: 17)

}
