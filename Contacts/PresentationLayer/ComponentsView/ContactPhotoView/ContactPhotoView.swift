import UIKit

final class ContactPhotoView: UIView {
  // MARK: - Properties
  
  private var viewModel: ContactPhotoViewModel?
  private let imagePhotoView = UIImageView()
  private let firstNameComponentView = ContactInformationView()
  private let lastNameComponentView = ContactInformationView()
  private let phoneNumberComponentView = ContactInformationView.phoneSetup()
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  func configure(viewModel: ContactPhotoViewModel) {
    self.viewModel = viewModel
    
    firstNameComponentView.configure(viewModel: viewModel.firstNameContactInformationViewModel)
    lastNameComponentView.configure(viewModel: viewModel.lastNameContactInformationViewModel)
    phoneNumberComponentView.configure(viewModel: viewModel.phoneNumberContactInformationViewModel)
    
    bindToViewModel()
  }
  
  // MARK: - Actions
  
  @objc
  private func actionPhoto() {
    viewModel?.showImagePicker()
  }
  
  // MARK: - Private Methods

  private func bindToViewModel() {
    viewModel?.didUpdateViewModel = { [weak self] in
      guard let image = self?.viewModel?.model.image else { return }
      self?.imagePhotoView.image = image
    }
  }
  
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
    imagePhotoView.backgroundColor = .basic5
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionPhoto))
    imagePhotoView.isUserInteractionEnabled = true
    imagePhotoView.addGestureRecognizer(tapGestureRecognizer)
    let image = ImageCreator.mergeImages(bottomImage: imagePhotoView.image ?? UIImage())
    imagePhotoView.image = image
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
      make.bottom.equalToSuperview()
    }
  }
}
