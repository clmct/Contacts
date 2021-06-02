@testable import Contacts
import XCTest
import CoreData

final class CoreDataServiceMock: CoreDataServiceProtocol {
  func fetchContacts(completion: @escaping (Result<[Contact], Error>) -> Void) {
  }
  
  func getContact(id: UUID, completion: @escaping (Result<Contact, Error>) -> Void) {
  }
  
  func addContact(with contact: Contact) {
  }
  
  func editContact(with contact: Contact) {
  }
  
}
