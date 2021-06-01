import UIKit

final class ContactPhotoView: UIView {
  // MARK: - Properties
  
  private var viewModel: ContactPhotoViewModel?
  private let imagePhotoView = UIImageView()
  private let firstNameComponentView = ContactInformationView()
  private let lastNameComponentView = ContactInformationView()
  private let phoneNumberComponentView = ContactInformationView()
  
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
      self?.imagePhotoView.image = self?.viewModel?.image
    }
  }
  
  private func mergeImages(bottomImage: UIImage) -> UIImage? {
    let topImage = R.image.plus()

    let size = CGSize(width: 40, height: 40)
    UIGraphicsBeginImageContext(size)

    let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let plusSize = CGRect(x: 10, y: 10, width: 20, height: 20)
    bottomImage.draw(in: areaSize)

    topImage?.draw(in: plusSize, blendMode: .normal, alpha: 1)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
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
    imagePhotoView.backgroundColor = UIColor(red: 0.879, green: 0.879, blue: 0.879, alpha: 1)
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionPhoto))
    imagePhotoView.isUserInteractionEnabled = true
    imagePhotoView.addGestureRecognizer(tapGestureRecognizer)
    let image = mergeImages(bottomImage: imagePhotoView.image ?? UIImage())
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
