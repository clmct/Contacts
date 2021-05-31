import UIKit

final class ContactDetailViewController: UIViewController {
  // MARK: - Properties
  private let viewModel: ContactDetailViewModelProtocol
  private let contactPhotoComponentView = ContactDetailPhotoView()
  private let phoneView = ContactCellInformationView()
  private let ringtoneView = ContactCellInformationView()
  private let notesView = ContactCellInformationView()
  
  // MARK: - Init
  init(viewModel: ContactDetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    bindToViewModel()
    viewModel.fetchContact()
  }
  
  // MARK: - Public Methods
  func configureSubviews() {
//    phoneView.configure(viewModel: viewModel.contactPhotoComponentViewModel)
  }
  
  // MARK: - Actions
  @objc
  private func editContact() {
//    viewModel.showEditContact()
  }
  
  // MARK: - Private Methods
  private func bindToViewModel() {
  }
  
  private func configureView(contact: Contact) {
//    let phoneModel = ContactCellInformationViewModel(title: "Phone", description: contact.phoneNumber)
//    phoneView.configure(with: phoneModel)
//    let ringtoneModel = ContactCellInformationViewModel(title: "Ringtone", description: contact.ringtone)
//    ringtoneView.configure(with: ringtoneModel)
//    let motesModel = ContactCellInformationViewModel(title: "Notes", description: contact.notes)
//    notesView.configure(with: motesModel)
//    let photoModel = ContactDetailPhotoViewModel(image: contact.photo,
//                                                 firstName: contact.firstName,
//                                                 lastName: contact.lastName)
//    contactPhotoComponentView.configure(with: photoModel)
  }
  
  private func setupLayout() {
    view.backgroundColor = .white
//    navigationItem.largeTitleDisplayMode = .never
//    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//    navigationController?.navigationBar.shadowImage = UIImage()
//    navigationController?.navigationBar.isTranslucent = true
//    navigationController?.view.backgroundColor = UIColor.clear
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                        target: self ,
                                                        action: #selector(editContact))
    
    setupContactPhotoComponentView()
    setupPhoneView()
    setupRingtoneView()
    setupNotesView()
  }
  
  private func setupContactPhotoComponentView() {
    view.addSubview(contactPhotoComponentView)
    contactPhotoComponentView.snp.makeConstraints { make in
      make.top.equalTo(view.snp.top)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.height.equalTo(300)
    }
    contactPhotoComponentView.backgroundColor = UIColor(red: 0.984, green: 0.98, blue: 1, alpha: 1)
  }
  
  private func setupPhoneView() {
    view.addSubview(phoneView)
    phoneView.snp.makeConstraints { make in
      make.top.equalTo(contactPhotoComponentView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }
  }
  
  private func setupRingtoneView() {
    view.addSubview(ringtoneView)
    ringtoneView.snp.makeConstraints { make in
      make.top.equalTo(phoneView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }

  }
  
  private func setupNotesView() {
    view.addSubview(notesView)
    notesView.snp.makeConstraints { make in
      make.top.equalTo(ringtoneView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }
  }
}
