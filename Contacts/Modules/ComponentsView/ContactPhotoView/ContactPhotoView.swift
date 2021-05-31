import UIKit

final class ContactPhotoView: UIView {
  // MARK: Properties
  private var viewModel: ContactPhotoViewModel?
  private let imagePhotoView = UIImageView()
  private let firstNameComponentView = ContactInformationView()
  private let lastNameComponentView = ContactInformationView()
  private let phoneNumberComponentView = ContactInformationView()
  
  // MARK: Lifecycle
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
  }
  
  // MARK: - Actions
  @objc
  private func actionPhoto() {
    showPhotoPicker()
  }
  
  // MARK: - Private Methods
  private func mergeImages(bottomImage: UIImage) -> UIImage? {
    let topImage = R.image.plus()

    let size = CGSize(width: 45, height: 45)
    UIGraphicsBeginImageContext(size)

    let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    bottomImage.draw(in: areaSize)

    topImage?.draw(in: areaSize, blendMode: .normal, alpha: 1)

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
    
//    imagePhotoView.addSubview(plusView)
//    plusView.snp.makeConstraints { make in
//      make.centerX.centerY.equalToSuperview()
//      make.height.width.equalTo(45)
//    }
//    plusView.image = R.image.plus()
    
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
  
  func showPhotoPicker() {
    let photoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    photoAlert.addAction(cancelAction)
    
    let cameraAction = UIAlertAction(title: "Take photo", style: .default) { _ in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        self.takePhotoWithCamera()
      } else {
        self.alertCameraSimulator()
      }
    }
    photoAlert.addAction(cameraAction)
    
    let libraryAction = UIAlertAction(title: "Choose photo", style: .default) { _ in
      self.choosePhotoFromLibrary() }
    photoAlert.addAction(libraryAction)
    
    window?.rootViewController?.present(photoAlert, animated: true, completion: nil)
  }
  
  func takePhotoWithCamera() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    window?.rootViewController?.present(imagePicker, animated: true, completion: nil)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    window?.rootViewController?.present(imagePicker, animated: true, completion: nil)
  }
  
  private func alertCameraSimulator() {
    let alert = UIAlertController(title: "Упс... На симуляторе нет камеры!",
                                  message: "Попробуйте на реальном девайсе. Кнопка представлена на симуляторе для разработчиков.",
                                  preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
    alert.addAction(cancelAction)

    window?.rootViewController?.present(alert, animated: true, completion: nil)
  }
}

extension ContactPhotoView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    imagePhotoView.image = image
    viewModel?.updateImage(with: image)
    window?.rootViewController?.dismiss(animated: true)
  }
}






// MARK: - ConfigurableProtocol
//extension ContactEditPhotoView: ConfigurableProtocol {
//  typealias Model = ContactEditPhotoViewModel
//
//  func configure(with model: Model) {
//    imagePhotoView.image = model.image
//    firstNameComponentView.configure(with: ContactEditInformationComponentViewModel(title: model.firstName))
//    lastNameComponentView.configure(with: ContactEditInformationComponentViewModel(title: model.lastName))
//    phoneNumberComponentView.configure(with: ContactEditInformationComponentViewModel(title: model.phoneNumber))
//  }
//}
