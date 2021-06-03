import UIKit

final class ContactDetailViewController: UIViewController {
  // MARK: - Properties
  
  private let viewModel: ContactDetailViewModelProtocol
  private let contactPhotoComponentView = ContactDetailPhotoView()
  private let phoneView = ContactCellInformationView.disableUI()
  private let ringtoneView = ContactCellInformationView.disableUI()
  private let notesView = ContactCellInformationView.disableUI()
  
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
    configureSubviews()
    viewModel.fetchContact()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.fetchContact()
    viewModel.changeAppearance()
  }
  
  // MARK: - Public Methods
  
  func configureSubviews() {
    contactPhotoComponentView.configure(viewModel: viewModel.contactDetailPhotoViewModel)
    phoneView.configure(viewModel: viewModel.phoneViewModel)
    ringtoneView.configure(viewModel: viewModel.ringtoneViewModel)
    notesView.configure(viewModel: viewModel.notesViewModel)
  }
  
  // MARK: - Actions
  @objc
  private func editContact() {
    viewModel.showEditContact()
  }
  
  private func setupLayout() {
    view.backgroundColor = .white
    navigationItem.largeTitleDisplayMode = .never
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
