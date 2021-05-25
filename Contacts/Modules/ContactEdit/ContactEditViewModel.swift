import UIKit

protocol ContactEditViewModelProtocol {
  var firstName: String? { get set }
  var lastName: String? { get set }
  var image: UIImage? { get set }
  var phoneNumber: String? { get set }
  var ringtone: String? { get set }
  var notes: String? { get set }
  var didUpdateNewContact: ((Contact) -> Void)? { get set }
  func requestContact()
}

protocol ContactEditViewModelDelegate: class {
}

final class ContactEditViewModel: ContactEditViewModelProtocol {
  // MARK: - Properties
  var firstName: String?
  var lastName: String?
  var image: UIImage?
  var phoneNumber: String?
  var ringtone: String?
  var notes: String?
  weak var delegate: ContactEditViewModelDelegate?
  var didUpdateNewContact: ((Contact) -> Void)?
  
  // MARK: - Types
  typealias Dependencies = HasCoreDataService
  
  // MARK: - Init
  init(dependencies: Dependencies) {
  }
  
  func requestContact() {
    let contact = Contact(photo: nil,
                          firstName: "",
                          lastName: "",
                          phoneNumber: "",
                          ringtone: "",
                          notes: "")
    didUpdateNewContact?(contact)
  }
  
  // MARK: - Private Methods
  private func newContactMode() {
    firstName = ""
    lastName = ""
    image = nil
    phoneNumber = ""
    ringtone = "Default"
    notes = ""
    let contact = Contact(photo: nil,
                          firstName: "",
                          lastName: "",
                          phoneNumber: "",
                          ringtone: "",
                          notes: "")
    didUpdateNewContact?(contact)
  }
  
  private func editContactMode() {
    firstName = ""
    lastName = ""
    image = nil
    phoneNumber = ""
    ringtone = "Default"
    notes = ""
  }
}
