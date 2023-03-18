import UIKit

final class ContactsViewController: UIViewController {
    
    var cellModels: [Contact] = []
    private let service = ContactsServiceImpl()
    private var lastSortWay: SortWay = .nameFromStart
    private var cellModelsMemory: [Contact] = []
    var filterSettings: [String] = []
    
    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Bold", size: 34)
        label.text = "Контакты"
        label.textColor = .white
        
        return label
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "filter"), for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private lazy var emptyTableLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Regular", size: 0), size: 16)
        label.text = "Таких контактов нет, выберите другие фильтры"
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLocalData()
//        loadData()
        addSubViews()
        addConstraints()
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
    
    private func addConstraints() {
        topBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyTableLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 116),
            
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            filterButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            filterButton.heightAnchor.constraint(equalToConstant: 26),
            filterButton.widthAnchor.constraint(equalToConstant: 26),
            
            sortButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -21),
            sortButton.heightAnchor.constraint(equalToConstant: 26),
            sortButton.widthAnchor.constraint(equalToConstant: 26),
            
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: topBar.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyTableLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTableLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyTableLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addSubViews() {
        view.addSubview(topBar)
        view.addSubview(tableView)
        view.addSubview(emptyTableLabel)
        topBar.addSubview(titleLabel)
        topBar.addSubview(sortButton)
        topBar.addSubview(filterButton)
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
            self.cellModelsMemory = contacts
            self.tableView.reloadData()
        }
    }
    
    func loadLocalData() {
        JSONContactsService().parseContactsFromLocalData { contacts in
            self.cellModels = contacts
            self.tableView.reloadData()
        }
    }
    
    func returnToDefault() {
        filterSettings = []
        cellModels = cellModelsMemory
        sortButton.setImage(UIImage(named: "sort"), for: .normal)
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        tableView.reloadData()
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAlert = UIAlertController(
            title: nil,
            message: "Уверены что хотите удалить контакт?",
            preferredStyle: .actionSheet
        )
        
        let alertAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.cellModels.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteAlert.addAction(alertAction)
        deleteAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить"
        ) { [weak self]  _, _, completion in
            self?.present(deleteAlert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        for subview in tableView.subviews {
            if NSStringFromClass(type(of: subview)) == "_UITableViewCellSwipeContainerView" {
                for swipeContainerSubview in subview.subviews {
                    if NSStringFromClass(type(of: swipeContainerSubview)) == "UISwipeActionPullView" {
                        swipeContainerSubview.backgroundColor = .systemRed
                        swipeContainerSubview.layer.cornerRadius = 24
                        swipeContainerSubview.clipsToBounds = true
                        swipeContainerSubview.frame.size.height = 116
                        swipeContainerSubview.frame.origin.y = 2
                        
                        for case let button as UIButton in swipeContainerSubview.subviews {
                            button.layer.cornerRadius = 24
                            button.clipsToBounds = true
                        }
                    }
                }
            }
        }
    }
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
        sortButton.setImage(UIImage(named: "sort.fill"), for: .normal)
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
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
        
        if cellModels == [] {
            emptyTableLabel.isHidden = false
        } else {
            emptyTableLabel.isHidden = true
        }
        
        sortButton.setImage(UIImage(named: "sort"), for: .normal)
        filterButton.setImage(UIImage(named: "filter.fill"), for: .normal)
        
        self.tableView.reloadData()
        
        DispatchQueue.main.async {
            self.cellModels = self.cellModelsMemory
        }
    }
}
