import UIKit

final class ContactAddEditViewController: UIViewController {
  // MARK: - Properties
  
  private var viewModel: ContactAddEditViewModelProtocol
  private let contactPhotoView = ContactPhotoView()
  private let ringtoneComponentView = ContactCellInformationView.editSetupRingtone()
  private let notesComponentView = ContactCellNotesView.editSetup()
  
  private let pickerView = UIPickerView()
  private let scrollView = TPKeyboardAvoidingScrollView()
  private let contentView = UIView()
  
  private let deleteContactButton = UIButton(type: .system)
  
  // MARK: - Init

  init(viewModel: ContactAddEditViewModel) {
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
    bindToViewModel()
    contactPhotoView.configure(viewModel: viewModel.contactPhotoViewModel,
                               delegate: self)
    ringtoneComponentView.configure(viewModel: viewModel.contactCellRingtoneViewModel,
                                    delegate: self)
    notesComponentView.configure(viewModel: viewModel.contactCellNotesViewModel,
                                 delegate: self)
    viewModel.configureViewModels()
    
    ringtoneComponentView.descriptionTextField.tag = 3
    notesComponentView.descriptionTextView.tag = 4
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.changeAppearance()
  }
  
  // MARK: - Actions
  
  @objc
  private func cancelAction() {
    viewModel.cancelAction()
  }
  
  @objc
  private func doneAction() {
    viewModel.addContact()
  }
  
  @objc
  private func doneInputAction() {
    view.endEditing(false)
  }
  
  @objc
  private func deleteAction() {
    viewModel.deleteContact()
  }
  
  @objc
  private func phoneAction() {
    ringtoneComponentView.descriptionTextField.becomeFirstResponder()
  }
  
  @objc
  private func ringtoneAction() {
    notesComponentView.descriptionTextView.becomeFirstResponder()
  }
  
  // MARK: - Private Methods
  
  private func bindToViewModel() {
    viewModel.onDidUpdate = { [weak self] in
      guard let self = self else { return }
      
      self.disableDoneButton()
      
      if let isRequiredInformation = self.viewModel.isRequiredInformation,
         isRequiredInformation == true {
        self.enableDoneButton()
      }
      
      switch self.viewModel.stateScreen {
      case .add:
        self.deleteContactButton.isUserInteractionEnabled = false
        self.deleteContactButton.isHidden = true
      default:
        break
      }
    }
  }
  
  private func enableDoneButton() {
    navigationItem.rightBarButtonItem?.isEnabled = true
  }
  
  private func disableDoneButton() {
    navigationItem.rightBarButtonItem?.isEnabled = false
  }
  
  private func setupLayout() {
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .white
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                       target: self ,
                                                       action: #selector(cancelAction))
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self ,
                                                        action: #selector(doneAction))
    setupContentLayout()
    setupContactEditPhotoComponentView()
    setupRingtoneComponentView()
    setupNotesComponentView()
    setupRingtonePicker()
    setupDeleteContactButton()
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
  
  private func setupContactEditPhotoComponentView() {
    contentView.addSubview(contactPhotoView)
    contactPhotoView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupRingtoneComponentView() {
    contentView.addSubview(ringtoneComponentView)
    ringtoneComponentView.snp.makeConstraints { make in
      make.top.equalTo(contactPhotoView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(65)
    }
  }
  
  private func setupNotesComponentView() {
    contentView.addSubview(notesComponentView)
    notesComponentView.snp.makeConstraints { make in
      make.top.equalTo(ringtoneComponentView.snp.bottom).offset(30)
      make.leading.trailing.equalToSuperview()
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
                                     style: .done, target: self, action: #selector(doneInputAction))
    let nextButton = UIBarButtonItem(title: R.string.localizable.next(),
                                     style: .done, target: self, action: #selector(ringtoneAction))
    toolBar.setItems([doneButton, flexSpace, nextButton], animated: true)
    toolBar.isUserInteractionEnabled = true
    ringtoneComponentView.descriptionTextField.inputView = pickerView
    ringtoneComponentView.descriptionTextField.inputAccessoryView = toolBar
  }
  
  private func setupDeleteContactButton() {
    contentView.addSubview(deleteContactButton)
    deleteContactButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(50)
      make.trailing.equalToSuperview().offset(-50)
      make.top.equalTo(notesComponentView.snp.bottom).offset(40)
      make.height.equalTo(40)
    }
    
    contentView.snp.makeConstraints { make in
      make.bottom.equalTo(deleteContactButton.snp.bottom)
    }
    
    deleteContactButton.setTitle(R.string.localizable.delete(), for: .normal)
    deleteContactButton.setTitleColor(.basic4, for: .normal)
    
    deleteContactButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
  }
}

// MARK: - UIPickerViewDelegate

extension ContactAddEditViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return viewModel.models[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    viewModel.setRingtone(index: row)
  }
}

// MARK: - UITextFieldDelegate

extension ContactAddEditViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField !== contactPhotoView.phoneNumberComponentView.titleTextField { return true }
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.backgroundColor = .gray
    toolBar.tintColor = .systemBlue
    toolBar.sizeToFit()
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: R.string.localizable.done(),
                                     style: .done, target: self, action: #selector(doneInputAction))
    let nextButton = UIBarButtonItem(title: R.string.localizable.next(),
                                     style: .done, target: self, action: #selector(phoneAction))
    toolBar.setItems([doneButton, flexSpace, nextButton], animated: true)
    toolBar.isUserInteractionEnabled = true
    textField.inputAccessoryView = toolBar
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField === contactPhotoView.firstNameComponentView.titleTextField {
      contactPhotoView.lastNameComponentView.titleTextField.becomeFirstResponder()
    } else if textField === contactPhotoView.lastNameComponentView.titleTextField {
      contactPhotoView.phoneNumberComponentView.titleTextField.becomeFirstResponder()
    } else if textField === contactPhotoView.phoneNumberComponentView.titleTextField {
      ringtoneComponentView.descriptionTextField.becomeFirstResponder()
    } else if textField === ringtoneComponentView.descriptionTextField {
      notesComponentView.descriptionTextView.becomeFirstResponder()
    } else {
      textField.returnKeyType = .default
      textField.resignFirstResponder()
    }
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField !== contactPhotoView.phoneNumberComponentView.titleTextField { return true }
    guard let text = textField.text else { return true }
    let newString = (text as NSString).replacingCharacters(in: range, with: string)
    textField.text = PhoneFormatter.format(with: .rus, phone: newString)
    return false
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = textField.text else { return }
    if textField === contactPhotoView.firstNameComponentView.titleTextField {
      viewModel.changeFirstName(with: text)
    } else if textField === contactPhotoView.lastNameComponentView.titleTextField {
      viewModel.changeLastName(with: text)
    } else if textField === contactPhotoView.phoneNumberComponentView.titleTextField {
      viewModel.changePhoneNumber(with: text)
    }
  }
}

// MARK: - UITextViewDelegate

extension ContactAddEditViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    viewModel.changeNotes(with: textView.text)
  }
}
