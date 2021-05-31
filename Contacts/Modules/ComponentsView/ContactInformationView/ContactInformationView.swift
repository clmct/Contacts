import UIKit

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
    titleTextField.placeholder = viewModel.placeholder
  }
  
  // MARK: - Private Methods
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
    
    line.backgroundColor = UIColor(red: 0.784, green: 0.78, blue: 0.8, alpha: 1)
  }
}

extension ContactInformationView: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else { return }
    viewModel?.changeText(with: text)
  }
}
