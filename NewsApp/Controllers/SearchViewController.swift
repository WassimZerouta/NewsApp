//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Wass on 06/04/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.isHidden = false
        searchBar.tintColor = UIColor(named: "ColorSecondary")
        // searchBar.borderColor = Colors.colorPrimary()
        searchBar.placeholder = "chercher.."
        searchBar.barTintColor = UIColor(named: "ColorSecondary")
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        self.view.backgroundColor = UIColor(named: "ColorPrimary")

        // Do any additional setup after loading the view.
    }
    
    func createSearchBar() {
        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
