import UIKit

final class ContactDetailViewController: UIViewController {
  // MARK: - Properties
  
  private let viewModel: ContactDetailViewModelProtocol
  private let contactPhotoComponentView = ContactDetailPhotoView()
  private let phoneView = ContactCellInformationView()
  private let ringtoneView = ContactCellInformationView()
  private let notesView = ContactCellNotesView()
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  lazy var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                target: self ,
                                                action: #selector(editContact))
  
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
  
  deinit {
    viewModel.closeViewController()
  }
  
  // MARK: - Public Methods
  
  func configureSubviews() {
    contactPhotoComponentView.configure(viewModel: viewModel.contactDetailPhotoViewModel)
    phoneView.configure(viewModel: viewModel.phoneViewModel, delegate: nil)
    ringtoneView.configure(viewModel: viewModel.ringtoneViewModel, delegate: nil)
    notesView.configure(viewModel: viewModel.notesViewModel, delegate: nil)
  }
  
  // MARK: - Actions
  
  @objc
  private func editContact() {
    viewModel.showEditContact()
  }
  
  // MARK: - Private Methods
  
  private func setupLayout() {
    view.backgroundColor = .white
    
    setupContentLayout()
    setupContactPhotoComponentView()
    setupPhoneView()
    setupRingtoneView()
    setupNotesView()
  }
  
  private func setupContentLayout() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints { make in
      make.edges.width.equalToSuperview()
    }
  }
  
  private func setupContactPhotoComponentView() {
    contentView.addSubview(contactPhotoComponentView)
    contactPhotoComponentView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(200)
    }
    
    contactPhotoComponentView.isUserInteractionEnabled = false
  }
  
  private func setupPhoneView() {
    contentView.addSubview(phoneView)
    phoneView.snp.makeConstraints { make in
      make.top.equalTo(contactPhotoComponentView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }
    
    phoneView.isUserInteractionEnabled = false
  }
  
  private func setupRingtoneView() {
    contentView.addSubview(ringtoneView)
    ringtoneView.snp.makeConstraints { make in
      make.top.equalTo(phoneView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }

    ringtoneView.isUserInteractionEnabled = false
  }
  
  private func setupNotesView() {
    contentView.addSubview(notesView)
    notesView.snp.makeConstraints { make in
      make.top.equalTo(ringtoneView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
    }
    
    contentView.snp.makeConstraints { make in
      make.bottom.equalTo(notesView.snp.bottom)
    }
    
    notesView.isUserInteractionEnabled = false
  }
}
