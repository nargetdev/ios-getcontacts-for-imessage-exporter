//
//  ContentView.swift
//  getcontacts
//
//  Created by Ms Whiskers on 2/19/24.
//

import SwiftUI

import Contacts

func fetchAndMatchContacts() async -> [String] {
    let store = CNContactStore()
    var results: [String] = []
    do {
        let JSON_not_CSV = false
        if JSON_not_CSV{
            print("[")
        } else {
            print("number, name")
        }
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
                // Implement your matching logic here
                // If matched, append to results
                if (JSON_not_CSV){
                    print("{\"number\":" + " \"\(number)\", \"name\": \"\(contact.familyName) \(contact.givenName)\"},")
                }
                else {
                    print("\(number), \(contact.familyName) \(contact.givenName)")
                }
            }
        }
        if (JSON_not_CSV){
            print("]")
        }
        return results
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
            
            Button("getContact") {
                
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

#Preview {
    ContentView()
}
