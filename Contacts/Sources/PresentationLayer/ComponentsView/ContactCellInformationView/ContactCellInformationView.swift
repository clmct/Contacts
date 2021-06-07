import UIKit

extension ContactCellInformationView {
  static func editSetupRingtone() -> ContactCellInformationView {
    let informationView = ContactCellInformationView()
    informationView.configureEditRingtone()
    return informationView
  }
}

final class ContactCellInformationView: UIView {
  // MARK: - Properties
  
  private var viewModel: ContactCellInformationViewModel?
  private let titleLabel = UILabel()
  let descriptionTextField = UITextField()
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
  
  func configure(viewModel: ContactCellInformationViewModel) {
    self.viewModel = viewModel
    
    viewModel.onDidUpdateViewModel = { [weak self] in
      self?.setupData()
    }
  }
  
  func configureEditRingtone() {
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
  
  private func setupData() {
    titleLabel.text = viewModel?.title
    descriptionTextField.text = viewModel?.description
  }
  
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
    descriptionTextField.delegate = self
  }
  
  private func setupLine() {
    addSubview(line)
    line.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    line.backgroundColor = .basic3
  }
}

// MARK: - UITextFieldDelegate

extension ContactCellInformationView: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = textField.text else { return }
    viewModel?.changeText(with: text)
  }
}