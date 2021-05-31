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
  }
  
  // MARK: - Actions
  @objc
  private func cancel() {
    navigationController?.popViewController(animated: false)
  }
  
  @objc
  private func done() {
    viewModel.addContact()
//    navigationController?.popViewController(animated: false)
  }
  // MARK: - Actions
  @objc
  private func showPicker() {
    
  }
  
  // MARK: - Private Methods
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
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPicker))
    ringtoneComponentView.addGestureRecognizer(tapGestureRecognizer)
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
    pickerView.backgroundColor = .white
    
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.backgroundColor = .gray
    toolBar.tintColor = .systemBlue
    toolBar.sizeToFit()
    // Adding Button ToolBar
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(showPicker))
    toolBar.setItems([flexSpace, doneButton], animated: true)
    toolBar.isUserInteractionEnabled = true
    ringtoneComponentView.descriptionTextField.inputView = pickerView
    ringtoneComponentView.descriptionTextField.inputAccessoryView = toolBar
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
