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
  let titleTextField = UITextField()
  private let line = UILabel()
  private var isPhoneSetup = false
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  func configure(viewModel: ContactInformationViewModelProtocol,
                 delegate: UITextFieldDelegate) {
    self.viewModel = viewModel
    titleTextField.delegate = delegate
    bindToViewModel()
    
  }
  
  func configurePhoneSetup() {
    titleTextField.keyboardType = .phonePad
    isPhoneSetup = true
  }
  
  // MARK: - Private Methods
  
  private func bindToViewModel() {
    viewModel?.onDidUpdateViewModel = { [weak self] in
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
    titleTextField.returnKeyType = .next
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
