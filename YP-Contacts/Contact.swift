import Foundation
import Contacts

struct Contact: Equatable {
    let name: String
    let phoneNumber: String
    let imageData: Data?
    let socialProfiles: [String]
    let emails: [String]?
}
