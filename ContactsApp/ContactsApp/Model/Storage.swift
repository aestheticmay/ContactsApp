//
//  Storage.swift
//  ContactsApp
//
//  Created by Майя Калицева on 19.11.2022.
//

import Foundation

protocol ContactStorageProtocol {
    
    // loading the list of contacts
    func loading() -> [ContactsProtocol]
    
    // upload the list of contacts
    func uplode(contacts: [ContactsProtocol])
}

class ContactStorage: ContactStorageProtocol {
    
    private var storage = UserDefaults.standard
    private var storageKey = "contacts"
    
    private enum ContactKey: String {
        case title
        case phone
    }

    func loading() -> [ContactsProtocol] {
        var resultContacts: [ContactsProtocol] = []
        let contactsFromStorage = storage.array(forKey: storageKey) as?
        [[String:String]] ?? []
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else {
                continue }
            resultContacts.append(Contact(title: title, phone: phone)) }
        return resultContacts
    }
    
    func uplode(contacts: [ContactsProtocol]) {
        var arrayForStorage: [[String:String]] = []
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
        
    }
}
