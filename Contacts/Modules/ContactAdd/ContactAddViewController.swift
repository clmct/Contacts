import UIKit

final class ContactAddViewController: UIViewController {
  // MARK: - Properties
  
  private var viewModel: ContactAddViewModel
  private let contactPhotoView = ContactPhotoView() // done
  private let ringtoneComponentView = ContactCellInformationView.editSetupRingtone() // done
  private let notesComponentView = ContactCellNotesView() // done
  private let pickerView = UIPickerView()
  
  // MARK: - Init
  
  init(viewModel: ContactAddViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    view.backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    contactPhotoView.configure(viewModel: viewModel.contactPhotoViewModel)
    ringtoneComponentView.configure(viewModel: viewModel.contactCellRingtoneViewModel)
    notesComponentView.configure(viewModel: viewModel.contactCellNotesViewModel)
    viewModel.configureViewModels()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.viewWillAppear()
  }
  
  // MARK: - Actions
  
  @objc
  private func cancel() {
    navigationController?.popViewController(animated: false)
    viewModel.cancelAction()
  }
  
  @objc
  private func done() {
    viewModel.addContact()
  }
  
  @objc
  private func doneAction() {
  }
  
  // MARK: - Private Methods
  
  private func setupLayout() {
    navigationItem.largeTitleDisplayMode = .never
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
    }
  }
  
  private func setupRingtoneComponentView() {
    view.addSubview(ringtoneComponentView)
    ringtoneComponentView.snp.makeConstraints { make in
      make.top.equalTo(contactPhotoView.snp.bottom).offset(6)
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
  
  private func setupRingtonePicker() {
    pickerView.dataSource = viewModel.pickerDataSource
    pickerView.delegate = self
    pickerView.backgroundColor = .white
    
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.backgroundColor = .gray
    toolBar.tintColor = .systemBlue
    toolBar.sizeToFit()
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: R.string.localizable.done(),
                                     style: .done, target: self, action: #selector(doneAction))
    toolBar.setItems([flexSpace, doneButton], animated: true)
    toolBar.isUserInteractionEnabled = true
    ringtoneComponentView.descriptionTextField.inputView = pickerView
    ringtoneComponentView.descriptionTextField.inputAccessoryView = toolBar
  }
  
}

// MARK: - UIPickerViewDelegate

extension ContactAddViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return viewModel.models[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    viewModel.setRingtone(index: row)
  }
}
