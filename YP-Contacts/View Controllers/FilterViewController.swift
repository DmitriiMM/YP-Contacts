import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func reloadTableView(with filterArray: [String])
    func returnToAllContacts()
}

final class FilterViewController: UIViewController {
    private let logos = ["LogoTelegram", "LogoWhatsapp", "LogoViber", "LogoSignal", "LogoThreema", "LogoPhone", "LogoEmail"]
    
    private let tableView = UITableView()
    var filterArray: [String] = []
    weak var delegate: FilterViewControllerDelegate?
    var showAllContacts = false
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Сбросить", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Medium", size: 0), size: 16)
        button.addTarget(self, action: #selector(clearFilters), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "YP-Gray")
        button.setTitle("Применить", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Medium", size: 0), size: 16)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        
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
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.identifierFilterCell)
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
    
    @objc private func applyFilters() {
        filterArray = []
        for row in 0..<tableView.numberOfRows(inSection: 0)
        where (tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FilterCell)?.isOn == true {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FilterCell  else { return }
            
            guard let filter = cell.logoLabel.text else { return }
            filterArray.append(filter)
        }
        if showAllContacts == false {
            dismiss(animated: true) {
                self.delegate?.reloadTableView(with: self.filterArray)
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func clearFilters() {
        delegate?.returnToAllContacts()
        showAllContacts = true
        applyButton.backgroundColor = UIColor(named: "YP-Blue")
        
        for row in 0..<tableView.numberOfRows(inSection: 0)
        where (tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FilterCell)?.isOn == true {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FilterCell  else { return }
            
            cell.resetCheckmark(for: cell)
        }
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? FilterCell else { return }
        
        if indexPath.row == 0 {
            selectedCell.setCheckmark(for: selectedCell)
            
            for row in 1..<tableView.numberOfRows(inSection: 0)
            where (tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FilterCell)?.isOn == false {
                guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FilterCell  else { return }
                
                cell.setCheckmark(for: cell)
                tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
            }
        } else {
            selectedCell.changeCheckmark()
            
            guard let selectAllCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FilterCell else { return }
            selectedCell.resetCheckmark(for: selectAllCell)
        }
        
        var allCellsArray = [FilterCell]()
        for row in 1..<tableView.numberOfRows(inSection: 0) {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FilterCell else { return }
            allCellsArray.append(cell)
           
            if allCellsArray.contains(where: { $0.isOn == true }) {
                applyButton.backgroundColor = UIColor(named: "YP-Blue")
            } else {
                applyButton.backgroundColor = UIColor(named: "YP-Gray")
            }
        }
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        logos.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.identifierFilterCell, for: indexPath)
        
        guard let filterCell = cell as? FilterCell else { return UITableViewCell() }
        
        if indexPath.row != 0 {
            filterCell.logoLabel.text = logos[indexPath.row - 1].replacingOccurrences(of: "Logo", with: "")
        } else {
            filterCell.logoLabel.text = "Выбрать все"
            filterCell.logoLabel.leadingAnchor.constraint(equalTo: filterCell.contentView.leadingAnchor, constant: 16).isActive = true
        }
        
        if indexPath.row != 0 {
            filterCell.logoImageView.image = UIImage(named: logos[indexPath.row - 1])
        } else {
            filterCell.logoImageView.removeFromSuperview()
        }
        
        for filter in filterArray {
            if filter == filterCell.logoLabel.text {
                filterCell.setCheckmark(for: filterCell)
            }
        }
        
        return filterCell
    }
}
