//
//  Contacts.swift
//  ContactsApp
//
//  Created by Майя Калицева on 19.11.2022.
//

import Foundation

protocol ContactsProtocol {
    var title: String { get set }
    var phone: String { get set }
}

struct Contact: ContactsProtocol {
    var title: String
    var phone: String
}
