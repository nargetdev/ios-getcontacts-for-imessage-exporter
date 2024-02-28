import SwiftUI
import Contacts

// Define a struct to hold contact info
struct ContactInfo: Codable {
    var phoneNumber: String
    var contactName: String
}

func fetchAndMatchContacts() async -> [String] {
    let store = CNContactStore()
    var contactsInfo: [ContactInfo] = []
    
    do {
        let granted = try await store.requestAccess(for: .contacts)
        guard granted else {
            print("Access to contacts was denied.")
            return []
        }
        
        let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        try store.enumerateContacts(with: request) { (contact, stop) in
            for phoneNumber in contact.phoneNumbers {
                let number = phoneNumber.value.stringValue
                let name = "\(contact.familyName)_\(contact.givenName)"
                // Add contact info to the array
                contactsInfo.append(ContactInfo(phoneNumber: number, contactName: name))
            }
        }
        
        // Convert contactsInfo array to JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // For readability
        let jsonData = try encoder.encode(contactsInfo)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }
        
        return contactsInfo.map { "\($0.phoneNumber): \($0.contactName)" }
    } catch {
        print("Failed to fetch contacts: \(error)")
        return []
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button("Get Contacts") {
                // Call the async function
                Task {
                    let matchedContacts = await fetchAndMatchContacts()
                    // Process matchedContacts here, e.g., update UI.
                }
            }
        }
        .padding()
    }
}

// Preview struct omitted for brevity
