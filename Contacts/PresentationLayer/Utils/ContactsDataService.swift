import Foundation

struct ContactsDataService {
  static func sort(with text: String, contacts: [Contact]) -> [Contact] {
    let filteredContacts = contacts.filter { contact -> Bool in
      contact.firstName.lowercased().contains(text.lowercased())
    }
    return filteredContacts
  }
  
  static func getSectionsFromContacts(contacts: [Contact]) -> [Section<Contact>] {
    var result: [[Contact]] = []
    let sorted = contacts.sorted { $0.firstName < $1.firstName }
    
    var previewCharacter: Character?
    for contact in sorted {
      let initial = contact.firstName.first
      if initial != previewCharacter {
        result.append([])
        previewCharacter = initial
      }
      if !result.isEmpty {
        result[result.endIndex - 1].append(contact)
      }
    }
    
    var sections = [Section<Contact>]()
    for section in result {
      let section = Section<Contact>(title: section.first?.firstName.first?.uppercased() ?? "#", items: section)
      sections.append(section)
    }
    return sections
  }
}
