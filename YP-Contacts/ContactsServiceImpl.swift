import Foundation
import Contacts

protocol ContactsServiceProtocol {
    func requestAccess(completion: @escaping (Bool) -> Void)
    func loadContacts(completion: @escaping ([Contact]) -> Void)
}

final class ContactsServiceImpl: ContactsServiceProtocol {
    private let store = CNContactStore()
    private let queue = DispatchQueue(label: "contacts-queue")
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        store.requestAccess(for: .contacts) { isGrant, error in
            print(error?.localizedDescription as Any)
            completion(isGrant)
        }
    }
    
    func loadContacts(completion: @escaping ([Contact]) -> Void) {
        let keys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataKey
        ] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                var cnContacts = [CNContact]()
                
//                let predicate = CNContact.predicateForContacts(matchingName: "Anna")
//                cnContacts = try self.store.unifiedContacts(matching: predicate, keysToFetch: keys)
                
                try self.store.enumerateContacts(with: request) { contact, _ in
                    cnContacts.append(contact)
                }
                
                let contacts = cnContacts.map { cnContact in
                    let phoneLabeledValue = cnContact.phoneNumbers.first {
                        $0.label == CNLabelPhoneNumberMobile
                    }
                    
                    let phone = phoneLabeledValue?.value.stringValue ?? " "
                    
                    return Contact(
                        name: "\(cnContact.givenName) \(cnContact.familyName)",
                        phoneNumber: phone,
                        imageData: cnContact.imageData
                    )
                }
                
                DispatchQueue.main.async {
                    completion(contacts)
                }
            } catch {
                completion([])
            }
        }
    }
}
