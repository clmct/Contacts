import CoreData

extension ContactModel {
  convenience init(with model: Contact, in context: NSManagedObjectContext) {
    self.init(context: context)
    firstName = model.firstName
    lastName = model.lastName
    phoneNumber = model.phoneNumber
    photo = model.photoURL
    ringtone = model.ringtone
    notes = model.notes
    id = model.id
  }
  
  func getModel() -> Contact {
    let contact = Contact(id: id,
                          photoURL: photo,
                          firstName: firstName,
                          lastName: lastName,
                          phoneNumber: phoneNumber,
                          ringtone: ringtone,
                          notes: notes)
    return contact
  }
}
