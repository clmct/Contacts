import Foundation

final class ContactsDataService {
  static func getFakeContacts() -> [Section<Contact>] {
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
    
    var result: [[Contact]] = []
    var prevInitial: Character?
    for contact in contacts {
      let initial = contact.firstName.first
      if initial != prevInitial {
        result.append([])
        prevInitial = initial
      }
      result[result.endIndex - 1].append(contact)
    }
    
    var sections = [Section<Contact>]()
    for section in result {
      let section = Section<Contact>(title: section.first?.firstName.first?.uppercased() ?? "#", items: section)
      sections.append(section)
    }
    return sections
  }
}
