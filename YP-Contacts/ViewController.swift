//
//  ViewController.swift
//  YP-Contacts
//
//  Created by Дмитрий Мартынов on 25.02.2023.
//

import UIKit
class PrivetViewController: UIViewController {

    

        var tableView: UITableView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white

            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always

            title = "Контакты"
            let font = UIFont.boldSystemFont(ofSize: 34)
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: font]
                   
            
            tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tableView)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
