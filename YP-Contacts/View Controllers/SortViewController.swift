import UIKit

enum SortWay {
    case nameFromStart
    case nameFromFinish
    case lastnameFromStart
    case lastnameFromFinish
    case none
}

protocol SortViewControllerDelegate: AnyObject {
    func updateTableData(with array: [Contact])
    func returnBack(lastSortOrder: SortWay)
    func reloadTableView()
}

final class SortViewController: UIViewController {
    private let tableView = UITableView()
    private let sortCells = ["По имени (А-Я / A-Z)", "По имени (Я-А / Z-A)", "По фамилии (А-Я / A-Z)", "По фамилии (Я-А / Z-A)"]
    var sortedContacts: [Contact] = []
    private let contactsVC = ContactsViewController.shared
    weak var delegate: SortViewControllerDelegate?
    var sortWay: SortWay = .none
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Сбросить", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Medium", size: 0), size: 16)
        button.addTarget(self, action: #selector(resetSort), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "YP-Gray")
        button.setTitle("Применить", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Medium", size: 0), size: 16)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(applySort), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        createTable()
        addSubViews()
        addConstraints()
    }
    
    private func createTable() {
        tableView.register(SortCell.self, forCellReuseIdentifier: SortCell.identifierSortCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
    }
    
    private func addConstraints() {
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            clearButton.heightAnchor.constraint(equalToConstant: 64),
            clearButton.widthAnchor.constraint(equalToConstant: 162),
            
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.heightAnchor.constraint(equalToConstant: 64),
            applyButton.widthAnchor.constraint(equalToConstant: 162),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -50)
        ])
    }
    
    private func addSubViews() {
        view.addSubview(clearButton)
        view.addSubview(applyButton)
        view.addSubview(tableView)
    }
    
    
    @objc private func applySort() {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SortCell  else { return }
            if row == 0 && cell.radioImageView.image == UIImage(named: "radioOn") {
                sortedContacts = sorting(sortedContacts, by: .nameFromStart)
                sortWay = .nameFromStart
            } else if row == 1 && cell.radioImageView.image == UIImage(named: "radioOn") {
                sortedContacts = sorting(sortedContacts, by: .nameFromFinish)
                sortWay = .nameFromFinish
            } else if row == 2 && cell.radioImageView.image == UIImage(named: "radioOn") {
                sortedContacts = sorting(sortedContacts, by: .lastnameFromStart)
                sortWay = .lastnameFromStart
            } else if row == 3 && cell.radioImageView.image == UIImage(named: "radioOn") {
                sortedContacts = sorting(sortedContacts, by: .lastnameFromFinish)
                sortWay = .lastnameFromFinish
            }
        }
        
        dismiss(animated: true) {
            self.delegate?.updateTableData(with: self.sortedContacts)
            self.delegate?.returnBack(lastSortOrder: self.sortWay)
            self.delegate?.reloadTableView()
        }
    }
    
    @objc private func resetSort() {
        dismiss(animated: true)
    }
    
    private func sorting(_ contacts: [Contact], by sortWay: SortWay) -> [Contact] {
        var contacts = contacts
        switch sortWay {
        case .nameFromStart:
            contacts.sort { $0.name.components(separatedBy: " ").first! < $1.name.components(separatedBy: " ").first! }
        case .nameFromFinish:
            contacts.sort { $0.name.components(separatedBy: " ").first! > $1.name.components(separatedBy: " ").first! }
        case .lastnameFromStart:
            contacts.sort { $0.name.components(separatedBy: " ").last! < $1.name.components(separatedBy: " ").last! }
        case .lastnameFromFinish:
            contacts.sort { $0.name.components(separatedBy: " ").last! > $1.name.components(separatedBy: " ").last! }
        case .none:
            break
        }
        
        return contacts
    }
}

extension SortViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? SortCell else { return }
        
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SortCell else { return }
            
            cell.radioImageView.image = UIImage(named: "radioOff")
            selectedCell.radioImageView.image = UIImage(named: "radioOn")
        }
        
        applyButton.backgroundColor = UIColor(named: "YP-Blue")
        applyButton.isEnabled = true
    }
}

extension SortViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortCell.identifierSortCell, for: indexPath)
        guard let sortCell = cell as? SortCell else { return UITableViewCell() }
        
        sortCell.sortLabel.text = sortCells[indexPath.row]
        sortCell.radioImageView.image = UIImage(named: "radioOff")
        
        switch sortWay {
        case .nameFromStart:
            if indexPath.row == 0 {
                sortCell.radioImageView.image = UIImage(named: "radioOn")
            }
        case .nameFromFinish:
            if indexPath.row == 1 {
                sortCell.radioImageView.image = UIImage(named: "radioOn")
            }
        case .lastnameFromStart:
            if indexPath.row == 2 {
                sortCell.radioImageView.image = UIImage(named: "radioOn")
            }
        case .lastnameFromFinish:
            if indexPath.row == 3 {
                sortCell.radioImageView.image = UIImage(named: "radioOn")
            }
        case .none:
            break
        }
        
        return sortCell
    }
}
