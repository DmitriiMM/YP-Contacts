import UIKit

class ContactsViewController: UIViewController {
    
    var tableView = UITableView()
    var cellModels: [Contact] = []
    let service = ContactsServiceImpl()
    static let shared = ContactsViewController()
    var lastSortWay: SortWay = .nameFromStart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavigationBar()
        createTable()
        loadData()
    }
    
    func createNavigationBar() {
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
    
    @objc func sortButtonTapped() {
        let sortVC = SortViewController()
        sortVC.delegate = self
        sortVC.sortWay = self.lastSortWay
        present(sortVC, animated: true) {
            sortVC.sortedContacts = self.cellModels
        }
    }
    
    @objc func filterButtonTapped() {
        self.present(FilterViewController(), animated: true)
    }
    
    func createTable() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    func loadData() {
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
