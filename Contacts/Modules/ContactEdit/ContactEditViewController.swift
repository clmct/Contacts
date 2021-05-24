import UIKit

final class ContactEditViewController: UIViewController {
  // MARK: - Properties
  private let viewModel: ContactEditViewModelProtocol
  private let contactEditPhotoComponentView = ContactEditPhotoComponentView()
  private let ringtoneComponentView = InformationView.editSetupRingtone()
  private let notesComponentView = InformationView.editSetup()
  
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
  }
  
  // MARK: - Public Methods
  
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
      make.height.equalTo(300)
    }
//    contactEditPhotoComponentView.backgroundColor = .red
  }
  
  private func setupRingtoneComponentView() {
    view.addSubview(ringtoneComponentView)
    ringtoneComponentView.snp.makeConstraints { make in
      make.top.equalTo(contactEditPhotoComponentView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }
    
    let model = InformationViewModel(title: "Ringtone", description: "Old Phone")
    ringtoneComponentView.configure(with: model)
  }
  
  private func setupNotesComponentView() {
    view.addSubview(notesComponentView)
    notesComponentView.snp.makeConstraints { make in
      make.top.equalTo(ringtoneComponentView.snp.bottom).offset(30)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }
    
    let model = InformationViewModel(title: "Notes", description: "Wake up, Neo...")
    notesComponentView.configure(with: model)
  }
}
