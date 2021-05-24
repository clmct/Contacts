import UIKit

final class ContactPhotoComponentView: UIView {
  // MARK: Properties
  private let imageView = UIImageView()
  private let nameLabel = UILabel()
  
  // MARK: Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private Methods
  private func setupLayout() {
    setupImageView()
    setupNameLabel()
  }
  
  private func setupImageView() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
      make.centerX.equalTo(safeAreaLayoutGuide)
      make.height.width.equalTo(100)
    }
    
    imageView.layer.cornerRadius = 50
    imageView.layer.masksToBounds = true
    imageView.backgroundColor = UIColor(red: 0.879, green: 0.879, blue: 0.879, alpha: 1)
  }
  
  private func setupNameLabel() {
    addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(16)
      make.centerX.equalTo(safeAreaLayoutGuide)
    }
    
    nameLabel.textColor = .basic1
    nameLabel.font = .basic3
  }
  
}

// MARK: - ConfigurableProtocol
extension ContactPhotoComponentView: ConfigurableProtocol {
  typealias Model = ContactPhotoComponentViewModel
  
  func configure(with model: ContactPhotoComponentViewModel) {
    imageView.image = model.image
    nameLabel.text = model.firstName + " " + model.lastName
  }
}
