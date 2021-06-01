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
    setupLayout()
    viewModel.requestContact()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.view.backgroundColor = UIColor.clear
    navigationController?.navigationBar.barTintColor = .clear
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.navigationBar.shadowImage = UIImage()
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
    }
  }
  
  private func setupRingtoneComponentView() {
    view.addSubview(ringtoneComponentView)
    ringtoneComponentView.snp.makeConstraints { make in
      make.top.equalTo(contactEditPhotoComponentView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }

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
