import UIKit

final class ContactAddViewController: UIViewController {
  // MARK: - Properties
  private var viewModel: ContactAddViewModelProtocol
  private let contactPhotoView = ContactPhotoView()
  private let ringtoneComponentView = ContactCellInformationView.editSetupRingtone() // to do
  private let notesComponentView = ContactCellNotesView()
  private let pickerView = UIPickerView()
  
  // MARK: - Init
  init(viewModel: ContactAddViewModelProtocol) {
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
    configureView()
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
//    viewModel.didUpdateNewContact = { [weak self] contact in
//      self?.configureView()
//    }
  }
  
  private func configureView() {
//    let photoModel = ContactEditPhotoViewModel(image: nil,
//                                               firstName: "",
//                                               lastName: "",
//                                               phoneNumber: "")
//    contactEditPhotoComponentView.configure(with: photoModel)
//    let ringtoneModel = ContactCellInformationViewModel(title: "Ringtone",
//                                                        description: "default")
//    ringtoneComponentView.configure(with: ringtoneModel)
//    let notesModel = ContactCellInformationViewModel(title: "Notes",
//                                                     description: "")
//    notesComponentView.configure(with: notesModel)
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
    setupRingtonePicker()
  }
  
  private func setupContactEditPhotoComponentView() {
    view.addSubview(contactPhotoView)
    contactPhotoView.snp.makeConstraints { make in
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
      make.top.equalTo(contactPhotoView.snp.bottom).offset(6)
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
//    notesComponentView.backgroundColor = .red
  }
  
  private func setupRingtonePicker() {
    pickerView.dataSource = viewModel.pickerDataSource
    pickerView.delegate = self
    
    view.addSubview(pickerView)
    pickerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(300)
    }
    
//    pickerView.backgroundColor = .gray
  }
}

extension ContactAddViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return viewModel.models[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    viewModel.setRingtone(index: row)
  }
}
