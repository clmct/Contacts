import UIKit

extension ContactInformationView {
  static func phoneSetup() -> ContactInformationView {
    let informationView = ContactInformationView()
    informationView.configurePhoneSetup()
    return informationView
  }
}

final class ContactInformationView: UIView {
  // MARK: - Properties
  
  private var viewModel: ContactInformationViewModelProtocol?
  private let titleTextField = UITextField()
  private let line = UILabel()
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
    titleTextField.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  func configure(viewModel: ContactInformationViewModelProtocol) {
    self.viewModel = viewModel
    bindToViewModel()
  }
  
  func configurePhoneSetup() {
    titleTextField.keyboardType = .phonePad
  }
  
  // MARK: - Private Methods
  
  private func bindToViewModel() {
    viewModel?.didUpdateViewModel = { [weak self] in
      guard let self = self else { return }
      self.titleTextField.text = self.viewModel?.text
      self.titleTextField.placeholder = self.viewModel?.placeholder
    }
  }
  
  private func setupLayout() {
    setupTitleTextField()
    setupLine()
  }
  
  private func setupTitleTextField() {
    addSubview(titleTextField)
    titleTextField.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(25)
    }
    
    titleTextField.textColor = .basic1
    titleTextField.font = .basic1
  }
  
  private func setupLine() {
    addSubview(line)
    line.snp.makeConstraints { make in
      make.top.equalTo(titleTextField.snp.bottom).offset(9)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    line.backgroundColor = .basic3
  }
}

// MARK: - UITextFieldDelegate

extension ContactInformationView: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = textField.text else { return }
    viewModel?.changeText(with: text)
  }
}
