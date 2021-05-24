import UIKit

extension InformationView {
  static func defaultSetup() -> InformationView {
    let informationView = InformationView()
    return informationView
  }
  
  static func editSetup() -> InformationView {
    let informationView = InformationView()
    informationView.configureEdit()
    return informationView
  }
  
  static func editSetupRingtone() -> InformationView {
    let informationView = InformationView()
    informationView.configureEditRingtone()
    return informationView
  }
}

final class InformationView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel()
  private let descriptionTextField = UITextField()
  private let line = UILabel()
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  func configureEdit() {
    descriptionTextField.isUserInteractionEnabled = true
    descriptionTextField.textColor = .basic2
  }
  
  func configureEditRingtone() {
    descriptionTextField.isUserInteractionEnabled = true
    descriptionTextField.textColor = .basic2
    let imageView = UIImageView()
    imageView.image = R.image.disclosureIndicator()
    imageView.contentMode = .scaleAspectFit
    descriptionTextField.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-16)
      make.centerY.equalToSuperview()
      make.height.width.equalTo(15)
    }
  }
  
  // MARK: - Private Methods
  private func setupLayout() {
    setupTitleLabel()
    setupDescriptionTextField()
    setupLine()
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(6)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview()
    }
    
    titleLabel.textColor = .basic1
    titleLabel.font = .basic4
  }
  
  private func setupDescriptionTextField() {
    addSubview(descriptionTextField)
    descriptionTextField.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(2)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview()
    }
    
    descriptionTextField.textColor = .basic1
    descriptionTextField.font = .basic1
    descriptionTextField.isUserInteractionEnabled = false
  }
  
  private func setupLine() {
    addSubview(line)
    line.snp.makeConstraints { make in
      make.top.equalTo(descriptionTextField.snp.bottom).offset(9)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    line.backgroundColor = UIColor(red: 0.784, green: 0.78, blue: 0.8, alpha: 1)
  }
}

// MARK: - ConfigurableProtocol
extension InformationView: ConfigurableProtocol {
  typealias Model = InformationViewModel
  
  func configure(with model: InformationViewModel) {
    titleLabel.text = model.title
    descriptionTextField.text = model.description
  }
}
