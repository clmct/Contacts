import UIKit

final class ContactDetailPhotoView: UIView {
  // MARK: - Properties
  
  private var viewModel: ContactDetailPhotoViewModel?
  private let imageView = UIImageView()
  private let nameLabel = UILabel()
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
    setupData()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  func configure(viewModel: ContactDetailPhotoViewModel) {
    self.viewModel = viewModel
    
    viewModel.onDidUpdateViewModel = { [weak self] in
      self?.setupData()
    }
  }
  
  // MARK: - Private Methods
  
  private func setupData() {
    imageView.image = viewModel?.image
    let firstName = viewModel?.firstName ?? ""
    let lastName = viewModel?.lastName ?? ""
    nameLabel.text = firstName + " " + lastName
  }
  private func setupLayout() {
    backgroundColor = .basic6
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
    imageView.backgroundColor = .basic5
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
