import UIKit

extension ContactCellNotesView {
  static func editSetup() -> ContactCellNotesView {
    let contactCellNotesView = ContactCellNotesView()
    contactCellNotesView.configureEditSetup()
    return contactCellNotesView
  }
}

class ContactCellNotesView: UIView {
  // MARK: - Properties
  
  private var viewModel: ContactCellNotesViewModelProtocol?
  private let titleLabel = UILabel()
  let descriptionTextView = UITextView()
  private let line = UILabel()
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
    bindToViewModel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  func configure(viewModel: ContactCellNotesViewModelProtocol,
                 delegate: UITextViewDelegate?) {
    self.viewModel = viewModel
    descriptionTextView.delegate = delegate
    bindToViewModel()
  }
  
  func configureEditSetup() {
    descriptionTextView.textColor = .basic2
  }
  
  // MARK: - Private Methods
  
  private func bindToViewModel() {
    viewModel?.onDidUpdateViewModel = { [weak self] in
      guard let self = self else { return }
      self.titleLabel.text = self.viewModel?.title
      self.descriptionTextView.text = self.viewModel?.text
    }
  }
  
  private func setupLayout() {
    setupTitleLabel()
    setupDescriptionTextView()
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
  
  private func setupDescriptionTextView() {
    addSubview(descriptionTextView)
    descriptionTextView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(2)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    descriptionTextView.isScrollEnabled = false
    descriptionTextView.textColor = .basic1
    descriptionTextView.font = .basic1
  }
  
  private func setupLine() {
    addSubview(line)
    line.snp.makeConstraints { make in
      make.top.equalTo(descriptionTextView.snp.bottom).offset(9)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    line.backgroundColor = .basic3
  }
}
