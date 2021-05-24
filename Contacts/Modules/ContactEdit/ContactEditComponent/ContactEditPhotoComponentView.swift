import UIKit

final class ContactEditPhotoComponentView: UIView {
  // MARK: Properties
  private let plusView = UIImageView()
  private let imagePhotoView = UIImageView()
  private let firstNameComponentView = ContactEditInformationComponentView()
  private let lastNameComponentView = ContactEditInformationComponentView()
  private let phoneNumberComponentView = ContactEditInformationComponentView()
  
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
    setupImagePhotoView()
    setupFirstNameComponentView()
    setupLastNameComponentView()
    setupShoneNumberComponentView()
  }
  
  private func setupImagePhotoView() {
    addSubview(imagePhotoView)
    imagePhotoView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
      make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(16)
      make.height.width.equalTo(100)
    }
    
    imagePhotoView.layer.cornerRadius = 50
    imagePhotoView.layer.masksToBounds = true
    imagePhotoView.backgroundColor = UIColor(red: 0.879, green: 0.879, blue: 0.879, alpha: 1)
    
    imagePhotoView.addSubview(plusView)
    plusView.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.height.width.equalTo(45)
    }
    plusView.image = R.image.plus()
  }
  
  private func setupFirstNameComponentView() {
    addSubview(firstNameComponentView)
    firstNameComponentView.snp.makeConstraints { make in
      make.top.equalTo(imagePhotoView.snp.top).offset(-10)
      make.leading.equalTo(imagePhotoView.snp.trailing).offset(24)
      make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-16)
      make.height.equalTo(44)
    }
  }
  
  private func setupLastNameComponentView() {
    addSubview(lastNameComponentView)
    lastNameComponentView.snp.makeConstraints { make in
      make.top.equalTo(firstNameComponentView.snp.bottom).offset(2)
      make.leading.equalTo(imagePhotoView.snp.trailing).offset(24)
      make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-16)
      make.height.equalTo(44)
    }
  }
  
  private func setupShoneNumberComponentView() {
    addSubview(phoneNumberComponentView)
    phoneNumberComponentView.snp.makeConstraints { make in
      make.top.equalTo(imagePhotoView.snp.bottom).offset(10)
      make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(16)
      make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-16)
      make.height.equalTo(44)
    }
    let model = ContactEditInformationComponentViewModel(title: "+ 7 (999) 499-917")
    phoneNumberComponentView.configure(with: model)
  }
  
}

// MARK: - ConfigurableProtocol
extension ContactEditPhotoComponentView: ConfigurableProtocol {
  typealias Model = ContactPhotoComponentViewModel
  
  func configure(with model: ContactPhotoComponentViewModel) {
  }
}
