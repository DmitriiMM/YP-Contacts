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
            CNContactImageDataKey,
            CNContactSocialProfilesKey,
            CNContactEmailAddressesKey
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
                    
                    let socialProfiles: [CNLabeledValue<CNSocialProfile>] = cnContact.socialProfiles
                    var socSeti: [String] = []
                    for profile in socialProfiles {
                        let service = profile.value.service
                        socSeti.append(service)
                    }
                    
                    let emailAddresses: [CNLabeledValue<NSString>] = cnContact.emailAddresses
                    var emails: [String] = []
                    for emailAddress in emailAddresses {
                        let label = emailAddress.label ?? ""
                        let address = emailAddress.value as String
                        emails.append(address)
                    }
                    
                    return Contact(
                        name: "\(cnContact.givenName) \(cnContact.familyName)",
                        phoneNumber: phone,
                        imageData: cnContact.imageData,
                        socialProfiles: socSeti,
                        emails: emails
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


//YP_Contacts.Contact(
//name: "Valera Plyushkin",
//phoneNumber: " ",
//imageData: Optional(3658312 bytes),
//socialProfiles: [
//    <CNLabeledValue:
//        0x60000068fa80:
//            identifier=7AAF1B58-54DD-4DD0-8DBA-37C8DA325804,
//            label=Telegram,
//            value=<CNMutableSocialProfile:
//                0x60000068f900:
//                    urlString=x-apple:telegram,
//                    username=telegram,
//                    userIdentifier=(nil),
//                    service=Telegram,
//                    displayname=(nil),
//                    teamIdentifier=(nil),
//                    bundleIdentifiers=(nil)>,
//                    iOSLegacyIdentifier=0>,
//    <CNLabeledValue:
//        0x60000068e580:
//            identifier=14D4040D-E62A-4D5E-869B-E674EFD38BE0,
//            label=Whatsup,
//            value=<CNMutableSocialProfile:
//                0x60000068fe80:
//                    urlString=x-apple:whazzzaaap,
//                    username=whazzzaaap,
//                    userIdentifier=(nil),
//                    service=Whatsup,
//                    displayname=(nil),
//                    teamIdentifier=(nil),
//                    bundleIdentifiers=(nil)>,
//                    iOSLegacyIdentifier=1>,
//    <CNLabeledValue: 0x60000068e5c0:
//    identifier=2CD6D67E-AB06-41B0-BE2A-272370FD96AD,
//    label=Threema,
//    value=<CNMutableSocialProfile: 0x60000068fd40:
//    urlString=x-apple:threeema,
//    username=threeema,
//    userIdentifier=(nil),
//    service=Threema,
//    displayname=(nil),
//    teamIdentifier=(nil),
//    bundleIdentifiers=(nil)>,
//    iOSLegacyIdentifier=2>,
//    <CNLabeledValue: 0x60000068fec0:
//    identifier=D1340B9F-BA7B-4A5D-8918-D5077F8DDA6E,
//    label=Viber,
//    value=<CNMutableSocialProfile: 0x60000068c200:
//    urlString=x-apple:viber,
//    username=viber,
//    userIdentifier=(nil),
//    service=Viber,
//    displayname=(nil),
//    teamIdentifier=(nil),
//    bundleIdentifiers=(nil)>,
//    iOSLegacyIdentifier=3>,
//    <CNLabeledValue: 0x60000068e340:
//    identifier=DD0BF382-87E5-4F2F-8D80-E935F26394B0,
//    label=Signal,
//    value=<CNMutableSocialProfile: 0x60000068fcc0:
//    urlString=x-apple:signal,
//    username=signal,
//    userIdentifier=(nil),
//    service=Signal,
//    displayname=(nil),
//    teamIdentifier=(nil),
//    bundleIdentifiers=(nil)>, i
//    OSLegacyIdentifier=4>
//]
//)
//
