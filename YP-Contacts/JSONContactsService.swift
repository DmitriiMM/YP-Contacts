import Foundation

final class JSONContactsService {
    private let queue = DispatchQueue(label: "contactsQueue")
    private var contacts: [Contact] = []
    
    func parseContactsFromLocalData(completion: @escaping ([Contact]) -> Void){
        
        if let url = Bundle.main.url(forResource: "contacts_list", withExtension: "json") {
            if let JSONData = try? Data(contentsOf: url) {
                queue.async {
                    do {
                        let responce = try JSONDecoder().decode(ContactsResponse.self, from: JSONData)
                        responce.contacts.forEach { contact in
                            var socialProfilesArray = [String]()
                            
                            if contact.messenger.telegram {
                                socialProfilesArray.append("Telegram")
                            }
                            
                            if contact.messenger.whatsapp == true {
                                socialProfilesArray.append("WhatsApp")
                            }
                            
                            if contact.messenger.viber == true {
                                socialProfilesArray.append("Viber")
                            }
                            
                            if contact.messenger.signal == true {
                                socialProfilesArray.append("Signal")
                            }
                            
                            if contact.messenger.threema == true {
                                socialProfilesArray.append("Threema")
                            }
                            
                            var emails = [String]()
                            if let email = contact.email {
                                emails.append(email)
                            }
                            
                            guard let photoUrl = contact.photoUrl else { return }
                            guard let url = URL(string: photoUrl) else { return }
                            let data = try? Data(contentsOf: url)
                            
                            let contact = Contact(
                                name: contact.firstname + " " + contact.lastname,
                                phoneNumber: contact.phoneNumber,
                                imageData: data,
                                socialProfiles: socialProfilesArray,
                                emails: emails
                            )
                            
                            self.contacts.append(contact)
                        }
                        DispatchQueue.main.async {
                            completion(self.contacts)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion([])
                        }
                    }
                }
            }
        }
    }
}

struct ContactStruct: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstname = try container.decode(String.self, forKey: .firstname)
        self.lastname = try container.decode(String.self, forKey: .lastname)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.photoUrl = try container.decode(String?.self, forKey: .photoUrl)
        self.messenger = try container.decode(Messenger.self, forKey: .messenger)
        self.email = try container.decode(String?.self, forKey: .email)
    }
    
    let firstname: String
    let lastname: String
    let phoneNumber: String
    let photoUrl: String?
    let messenger: Messenger
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case firstname
        case lastname
        case phoneNumber = "phone_number"
        case photoUrl = "photo_url"
        case messenger
        case email
    }
}

struct Messenger: Codable {
    let telegram: Bool
    let whatsapp: Bool
    let viber: Bool
    let signal: Bool
    let threema: Bool
    let email: Bool
    
    enum CodingKeys: String, CodingKey {
        case telegram
        case whatsapp
        case viber
        case signal
        case threema
        case email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.telegram = try container.decode(Bool.self, forKey: .telegram)
        self.whatsapp = try container.decode(Bool.self, forKey: .whatsapp)
        self.viber = try container.decode(Bool.self, forKey: .viber)
        self.signal = try container.decode(Bool.self, forKey: .signal)
        self.threema = try container.decode(Bool.self, forKey: .threema)
        self.email = try container.decode(Bool.self, forKey: .email)
    }
}


struct ContactsResponse: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contacts = try container.decode([ContactStruct].self, forKey: .contacts)
    }
    
    let contacts: [ContactStruct]
}
