import CoreData

protocol CoreDataServiceProtocol {
  func fetchContacts(completion: @escaping (Result<[Contact], Error>) -> Void)
  func getContact(id: UUID, completion: @escaping (Result<Contact, Error>) -> Void)
  func addContact(with contact: Contact)
  func editContact(with contact: Contact)
}

final class CoreDataService: CoreDataServiceProtocol {
  // MARK: - Properties
  private let coreDataStack: CoreDatasStackProtocol
  
  // MARK: - Init
  init() {
    self.coreDataStack = CoreDataStack()
  }
  
  // MARK: - Public Methods
  func fetchContacts(completion: @escaping (Result<[Contact], Error>) -> Void) {
    let context = coreDataStack.getContext()
    let request = NSFetchRequest<ContactModel>(entityName: "ContactModel")
    do {
      let contacts = try context.fetch(request)
      DispatchQueue.main.async {
        completion(.success(contacts.map { contact -> Contact in
          return contact.getModel()
        }))
      }
    } catch let error {
      DispatchQueue.main.async {
        completion(.failure(error))
      }
    }
  }
  
  func getContact(id: UUID, completion: @escaping (Result<Contact, Error>) -> Void) {
    fetchContact(id: id) { result in
      switch result {
      case .success(let contact):
        DispatchQueue.main.async {
          completion(.success(contact.getModel()))
        }
      case .failure(let error):
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
  
  func addContact(with contact: Contact) {
    let context = coreDataStack.getContext()
    _ = ContactModel(with: contact, in: context)
    coreDataStack.saveContext()
  }
  
  func deleteContact(id: UUID) {
    let context = coreDataStack.getContext()
    fetchContact(id: id) { [weak self] result in
      switch result {
      case .success(let contact):
        context.delete(contact)
      default:
        print(#function)
      }
      self?.coreDataStack.saveContext()
    }
  }
  
  func editContact(with contact: Contact) {
    let context = coreDataStack.getContext()
    _ = ContactModel(with: contact, in: context)
    coreDataStack.saveContext()
  }
  
  // MARK: - Private Methods
  private func fetchContact(id: UUID, completion: @escaping (Result<ContactModel, Error>) -> Void) {
    let context = coreDataStack.getContext()
    let request = NSFetchRequest<ContactModel>(entityName: "ContactModel")
    let predicate = NSPredicate(format: "id == %@", id as CVarArg)
    request.predicate = predicate
    do {
      let contact = try context.fetch(request)
      if let contact = contact.first {
        DispatchQueue.main.async {
          completion(.success(contact))
        }
      }
    } catch let error {
      DispatchQueue.main.async {
        completion(.failure(error))
      }
    }
  }
  
}
