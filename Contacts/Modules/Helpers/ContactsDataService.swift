import Foundation

final class ContactsDataService {
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

/*
 import UIKit

 final class ContactsDataService {
   static func sort(with text: String, contacts: [Contact]) -> [Contact] {
     let filteredContacts = contacts.filter { contact -> Bool in
       contact.firstName.lowercased().contains(text.lowercased())
     }
     return filteredContacts
   }
   
   static func getSectionsFromContacts(contacts: [Contact]) -> [Section<Contact>] {
     
     let characters = ("A"..."Z").characters
     
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
       if let char = section.title.first, characters.contains(char) {
         
       } else {
         
       }
       sections.append(section)
     }
     
     let newSections = sections.map { section -> Section<Contact> in
       if let char = section.title.first, characters.contains(char) {
         return section
       } else {
         var newSection = section
         newSection.title = "#"
         return newSection
       }
     }
     
     return newSections
   }
 }

 extension ClosedRange where Bound == Unicode.Scalar {
     static let asciiPrintable: ClosedRange = " "..."~"
     var range: ClosedRange<UInt32> { lowerBound.value...upperBound.value }
     var scalars: [Unicode.Scalar] { range.compactMap(Unicode.Scalar.init) }
     var characters: [Character] { scalars.map(Character.init) }
     var string: String { String(scalars) }
 }

 extension String {
     init<S: Sequence>(_ sequence: S) where S.Element == Unicode.Scalar {
         self.init(UnicodeScalarView(sequence))
     }
 }

 */
