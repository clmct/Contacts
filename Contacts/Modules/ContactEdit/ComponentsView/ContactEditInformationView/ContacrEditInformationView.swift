import UIKit

final class ContactEditInformationComponentView: UIView {
  // MARK: - Properties
  private let titleTextField = UITextField()
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
  func getDescription() -> String? {
    return titleTextField.text
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

// MARK: - ConfigurableProtocol
extension ContactEditInformationComponentView: ConfigurableProtocol {
  typealias Model = ContactEditInformationComponentViewModel
  
  func configure(with model: Model) {
    titleTextField.text = model.title
  }
}
