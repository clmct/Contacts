import UIKit

class ContactCellNotesView: UIView {
  // MARK: - Properties
  private let viewModel = ContactCellNotesViewModel()
  private let titleLabel = UILabel()
  private let descriptionTextView = UITextView()
  private let line = UILabel()
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
    titleLabel.text = "Notes"
    descriptionTextView.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureEdit() {
    descriptionTextView.isUserInteractionEnabled = true
    descriptionTextView.textColor = .basic2
  }
  
  func configureEditRingtone() {
    descriptionTextView.isUserInteractionEnabled = true
    descriptionTextView.textColor = .basic2
    let imageView = UIImageView()
    imageView.image = R.image.disclosureIndicator()
    imageView.contentMode = .scaleAspectFit
    descriptionTextView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-16)
      make.centerY.equalToSuperview()
      make.height.width.equalTo(15)
    }
  }
  
  // MARK: - Private Methods
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
//      make.height.equalTo(40)
    }
    descriptionTextView.isScrollEnabled = false
    descriptionTextView.textColor = .basic1
    descriptionTextView.font = .basic1
  }
  
  private func setupLine() {
    addSubview(line)
    line.snp.makeConstraints { make in
      make.top.equalTo(descriptionTextView.snp.bottom).offset(9)
//      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    line.backgroundColor = UIColor(red: 0.784, green: 0.78, blue: 0.8, alpha: 1)
  }
}

// MARK: - UITextViewDelegate
extension ContactCellNotesView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    viewModel.changeNotes(with: textView.text)
  }
}
