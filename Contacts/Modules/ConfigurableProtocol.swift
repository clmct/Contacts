import Foundation

protocol ConfigurableProtocol {
  associatedtype Model
  func configure(with model: Model)
}
