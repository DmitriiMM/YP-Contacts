import UIKit

final class ContactsViewController: UIViewController {
    
    private var tableView = UITableView()
    var cellModels: [Contact] = []
    private let service = ContactsServiceImpl()
    private var lastSortWay: SortWay = .nameFromStart
    private var cellModelsMemory: [Contact] = []
    var filterSettings: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavigationBar()
        createTable()
        loadData()
    }
    
    private  func createNavigationBar() {
        title = "Контакты"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        
        let sortBarButton = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        
        sortBarButton.tintColor = .white
        
        let filterBarButton = UIBarButtonItem(
            image: UIImage(named: "filter"),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        
        filterBarButton.tintColor = .white
        
        navigationItem.rightBarButtonItems = [
            filterBarButton,
            sortBarButton
        ]
    }
    
    @objc private func sortButtonTapped() {
        let sortVC = SortViewController()
        sortVC.delegate = self
        sortVC.sortWay = self.lastSortWay
        present(sortVC, animated: true) {
            sortVC.sortedContacts = self.cellModels
        }
    }
    
    @objc private func filterButtonTapped() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        filterVC.filterArray = filterSettings
        present(filterVC, animated: true)
    }
    
    private func createTable() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    private func loadData() {
        service.loadContacts { [weak self] contacts in
            guard let self = self else { return }
            self.cellModels = contacts
            self.tableView.reloadData()
        }
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Deleting
    //
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //        return .delete
    //    }
    //
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            myTableView.cellForRow(at: indexPath)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //    }
    
}

extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath)
        
        guard let contactCell = cell as? ContactCell else {
            return UITableViewCell()
        }
        
        let contact = cellModels[indexPath.row]
        contactCell.contactNameLabel.text = "\(contact.name)"
        contactCell.contactPhoneLabel.text = "\(contact.phoneNumber)"
        
        if let imageData = contact.imageData {
            contactCell.contactImageView.image = UIImage(data: imageData)
            contactCell.contactImageView.contentMode = .scaleAspectFill
        } else {
            contactCell.contactImageView.image = UIImage(systemName: "theatermasks.fill")
            contactCell.contactImageView.contentMode = .scaleAspectFit
        }
        
        
        for name in contact.socialProfiles {
            if let image = UIImage(named: name) {
                contactCell.addMiniLogo(to: contactCell.contactIconsStackView,
                                        imageView: UIImageView(image: image))
            }
        }
        
        if contact.phoneNumber != " " {
            contactCell.addMiniLogo(to: contactCell.contactIconsStackView,
                                    imageView: UIImageView(image: UIImage(named: "Phone")))
        }
        
        if contact.emails != [] {
            contactCell.addMiniLogo(to: contactCell.contactIconsStackView,
                                    imageView: UIImageView(image: UIImage(named: "Email")))
        }
        
        return contactCell
    }
}

extension ContactsViewController: SortViewControllerDelegate {
    func updateTableData(with array: [Contact]) {
        cellModels = array
    }
    
    func returnBack(lastSortOrder: SortWay) {
        lastSortWay = lastSortOrder
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension ContactsViewController: FilterViewControllerDelegate {
    func reloadTableView(with filterArray: [String]) {
        filterSettings = filterArray
        var filteredContacts: [Contact] = []
        cellModelsMemory = cellModels
        
        if filterArray.contains("Phone") {
            let phoneFiltered = cellModels.filter { contact in
                contact.phoneNumber != " "
            }
            filteredContacts.append(contentsOf: phoneFiltered)
        }
        
        if filterArray.contains("Email") {
            let emailFiltered = cellModels.filter { contact in
                contact.emails != nil && !contact.emails!.isEmpty
            }
            filteredContacts.append(contentsOf: emailFiltered)
        }
        
        for filter in filterArray {
            let socialFiltered = cellModels.filter { contact in
                contact.socialProfiles.contains(where: { $0 == filter })
            }
            filteredContacts.append(contentsOf: socialFiltered)
        }
        
        let uniqueFilteredContacts: [Contact] = filteredContacts.reduce(into: []) { uniqueContacts, contact in
            if !uniqueContacts.contains(where: { $0 == contact }) {
                uniqueContacts.append(contact)
            }
        }
        
        cellModels = []
        cellModels = uniqueFilteredContacts
        
        
        self.tableView.reloadData()
        
        DispatchQueue.main.async {
            self.cellModels = self.cellModelsMemory
        }
    }
    
    func returnToAllContacts() {
        cellModels = cellModelsMemory
        tableView.reloadData()
    }
}
