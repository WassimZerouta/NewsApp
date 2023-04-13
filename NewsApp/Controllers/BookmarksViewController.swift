//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by Wass on 12/04/2023.
//

import UIKit
import Alamofire

class BookmarksViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.frame
        view.backgroundColor = .systemGroupedBackground
    }

}

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsTableViewCell {

            return cell
        }
        
        else { let defaultCell = UITableViewCell(); return defaultCell }
    }
    
}
