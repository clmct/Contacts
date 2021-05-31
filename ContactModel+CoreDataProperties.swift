import Foundation
import CoreData

extension ContactModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactModel> {
        return NSFetchRequest<ContactModel>(entityName: "ContactModel")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String
    @NSManaged public var photo: String?
    @NSManaged public var phoneNumber: String
    @NSManaged public var ringtone: String?
    @NSManaged public var notes: String?
    @NSManaged public var id: UUID

}

extension ContactModel: Identifiable {
}
