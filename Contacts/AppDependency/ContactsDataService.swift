import Foundation

protocol ContactsDataServiceProtocol {
//  func getFakeContacts() -> [Contact]
}

final class ContactsDataService: ContactsDataServiceProtocol {
  static func getFakeContacts() -> [Contact] {
    var contacts: [Contact] = []
    for nameID in "abcdefghijklmnopqrstuvwxyz" {
      let contact = Contact(photo: nil,
                            firstName: "\(nameID.uppercased())_name1",
                            lastName: nil,
                            phoneNumber: "8 (934) 445-553",
                            ringtone: nil,
                            notes: nil)
      let contact2 = Contact(photo: nil,
                             firstName: "\(nameID.uppercased())_name2",
                             lastName: nil,
                             phoneNumber: "8 (934) 777-777",
                             ringtone: nil,
                             notes: nil)
      contacts.append(contact)
      contacts.append(contact2)
    }
    return contacts
  }
}
