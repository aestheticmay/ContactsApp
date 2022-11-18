//
//  ViewController.swift
//  ContactsApp
//
//  Created by Майя Калицева on 19.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Public Properties

    @IBOutlet var tableView: UITableView!
    
    // MARK: - Private Properties

    private let reuseIdentifier = "ContactsCellIdentifier"

    private var contacts: [ContactsProtocol] = [] {
        didSet {
            contacts.sort { $0.title < $1.title }
            storage.uplode(contacts: contacts)
        }
    }
    
    private var storage: ContactStorageProtocol!
    
    // MARK: - Life-cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
    }
    
    // MARK: - Public Methods

    @IBAction func showNewContactAlert() {
        let alertController = UIAlertController(title: "Create new contact", message: "Enter name and phone", preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "Name"
        }
        alertController.addTextField { textfield in
            textfield.placeholder = "Phone number"
        }
        
        let createButton = UIAlertAction(title: "Create", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text,
                  let contactPhone = alertController.textFields?[1].text else { return }
            
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
    
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(createButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Private Methods

    private func loadContacts() {
        contacts = storage.loading()
    }
}

// MARK: - Extensions

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            cell = reusableCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = contacts[indexPath.row].title
        configuration.secondaryText = contacts[indexPath.row].phone
        cell.contentConfiguration = configuration
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.contacts.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [action])
        return actions
    }
}
