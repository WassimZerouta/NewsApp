//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Wass on 06/04/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    var a = [String]()
    
    let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.isHidden = false
        // searchBar.borderColor = Colors.colorPrimary()
        searchBar.placeholder = "chercher.."
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        createSearchBar()

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
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        a.append(searchBar.text!)
        print(a)
        searchBar.text = ""
        searchBar.endEditing(false)
    }
}
