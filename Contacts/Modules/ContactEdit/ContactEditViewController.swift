import UIKit

final class ContactEditViewController: UIViewController {
  // MARK: - Properties
  private var viewModel: ContactEditViewModelProtocol
  private let contactEditPhotoComponentView = ContactPhotoView()
  private let ringtoneComponentView = ContactCellInformationView.editSetupRingtone()
  private let notesComponentView = ContactCellInformationView.editSetup()
  
  // MARK: - Init
  init(viewModel: ContactEditViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    bindToViewModel()
    setupLayout()
    viewModel.requestContact()
  }
  
  // MARK: - Actions
  @objc
  private func cancel() {
    navigationController?.popViewController(animated: false)
  }
  
  @objc
  private func done() {
    navigationController?.popViewController(animated: false)
  }
  
  // MARK: - Private Methods
  private func bindToViewModel() {
    viewModel.didUpdateNewContact = { [weak self] contact in
      self?.configureView(contact: contact)
    }
  }
  
  private func configureView(contact: Contact) {
//    let photoModel = ContactEditPhotoViewModel(image: contact.photo,
//                                               firstName: contact.firstName,
//                                               lastName: contact.lastName,
//                                               phoneNumber: contact.phoneNumber)
//    contactEditPhotoComponentView.configure(with: photoModel)
    let ringtoneModel = ContactCellInformationViewModel(title: "Ringtone",
                                                        description: "contact.ringtone")
    ringtoneComponentView.configure(with: ringtoneModel)
    let notesModel = ContactCellInformationViewModel(title: "Notes",
                                                     description: "contact.notes")
    notesComponentView.configure(with: notesModel)
  }
  
  private func saveContact() {
    //    let ringtone = ringtoneComponentView.getDescription()
    //    let notes = notesComponentView.getDescription()
    //    let firstName = contactEditPhotoComponentView.getModel().firstName
    //    let lastName = contactEditPhotoComponentView.getModel().lastName
    //    let image = contactEditPhotoComponentView.getModel().image
    //    let phoneNumber = contactEditPhotoComponentView.getModel().phoneNumber
  }
  
  private func setupLayout() {
    view.backgroundColor = .white
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                       target: self ,
                                                       action: #selector(cancel))
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self ,
                                                        action: #selector(done))
    setupContactEditPhotoComponentView()
    setupRingtoneComponentView()
    setupNotesComponentView()
  }
  
  private func setupContactEditPhotoComponentView() {
    view.addSubview(contactEditPhotoComponentView)
    contactEditPhotoComponentView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
//      make.height.equalTo(300)
    }
//    contactEditPhotoComponentView.backgroundColor = .blue
  }
  
  private func setupRingtoneComponentView() {
    view.addSubview(ringtoneComponentView)
    ringtoneComponentView.snp.makeConstraints { make in
      make.top.equalTo(contactEditPhotoComponentView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }
//    ringtoneComponentView.backgroundColor = .red
  }
  
  private func setupNotesComponentView() {
    view.addSubview(notesComponentView)
    notesComponentView.snp.makeConstraints { make in
      make.top.equalTo(ringtoneComponentView.snp.bottom).offset(30)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }
  }
}
