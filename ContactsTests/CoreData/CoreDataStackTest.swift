@testable import Contacts
import XCTest
import CoreData

class CoreDataServiceTests: XCTestCase {
  func testCoreDataService() throws {
    // Given
    let coreDataServiceMock: CoreDataServiceProtocol = CoreDataServiceMock()
    let contact = Contact(id: UUID(), firstName: "Alex", phoneNumber: "562356")
    
    // When
    coreDataServiceMock.addContact(with: contact)
    
    // Then
  }
}
