//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Wass on 06/04/2023.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {
    
    var favoriteSubjects = [CD_FavoriteSubject]()
    
    var searchArray = [String]()
    
    let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.isHidden = false
        searchBar.placeholder = "Search.."
        return searchBar
    }()
        
    let addFavoriteSubjectButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    let favoriteSubjectLabel: UILabel = {
        let label = UILabel()
        label.text = "Topics"
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.textColor = UIColor(red: 0.41, green: 0.65, blue: 0.68, alpha: 1.00)
        return label
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    //Put in assets
    let colorPrimary = UIColor(red: 0.41, green: 0.65, blue: 0.68, alpha: 1.00)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupCollectionView()
        createSearchBar()
        createFavoriteSubjectLabel()
        createAddFavoriteSubjectButton()
        createFavoritesSection()

        let closeKeyboard = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        closeKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(closeKeyboard)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCollectionView()
    }
    
    // Add alert when there are 0 favorite subject
    func addAlert() {
        let alert = UIAlertController(title: "Add a favorite subject !", message: " You still don't have a favorite topic ! You can add more by pressing the plus button. \n You will find them on the home page.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Create search bar
    func createSearchBar() {
        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    // Create favorite subject label
    func createFavoriteSubjectLabel() {
        self.view.addSubview(favoriteSubjectLabel)
        favoriteSubjectLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteSubjectLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        favoriteSubjectLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        favoriteSubjectLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        favoriteSubjectLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    // Create addFavoriteSubject button
    func createAddFavoriteSubjectButton() {
        self.view.addSubview(addFavoriteSubjectButton)
        addFavoriteSubjectButton.translatesAutoresizingMaskIntoConstraints = false
        addFavoriteSubjectButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        addFavoriteSubjectButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addFavoriteSubjectButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addFavoriteSubjectButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addFavoriteSubjectButton.addTarget(self, action: #selector(addFavoriteSubjectButtonPressed), for: .touchUpInside)
    }
    
    // create favorite section
    private func createFavoritesSection() {
        self.view.addSubview(collectionView)
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: favoriteSubjectLabel.bottomAnchor, constant: 20).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    // Set up collection view
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    
    // Add action when addFavoriteSubject button is pressed
    @objc func addFavoriteSubjectButtonPressed() {
        let alertController = UIAlertController(title: "Add new favorite subject !", message: nil, preferredStyle: .alert)
        
                let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
                    if let textField = alertController.textFields?.first, let text = textField.text {
                        
                        _ = CD_FavoriteSubjectRepository(coreDataStack: CoreDataStack.shared).saveFavoriteSubject(name: text, isAdded: true, completion: {
                            print("\(text) is added")
                        })
                        self.refreshCollectionView()
                    }
                }
        
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                alertController.addTextField { (textField) in
                    textField.placeholder = "Sport, Music.."
                }
        
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
        
    }
    
    // refresh the collectionView
    func refreshCollectionView() {
        CD_FavoriteSubjectRepository(coreDataStack: CoreDataStack.shared).getFavoriteSubject { CD_FavoriteSubject in
            DispatchQueue.main.async {
                self.favoriteSubjects = CD_FavoriteSubject
                self.favoriteSubjects = self.favoriteSubjects.compactMap { $0.name != nil ? $0 : nil }
                self.collectionView.reloadData()
                if self.favoriteSubjects.isEmpty {
                    self.addAlert()
                }
            }
        }
    }
}

// Convert array on adapted string to pass in the SearchResultViewController
func stringArray(array: [String]) -> String {
    let search = array
        .joined(separator: " ")
        .replacingOccurrences(of: ",", with: "")
        .replacingOccurrences(of: " ", with: "%20+")
    return search
}


// SearchViewController extensions

extension SearchViewController: UISearchBarDelegate {
    
    // Action when search button is pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchArray.append(searchBar.text!)
        view.endEditing(true)
        let searchText = stringArray(array: searchArray)
        let vc = SearchResultViewController(subject: searchText)
        searchArray.removeAll()
        vc.navigationItem.title = searchBar.text!
        vc.modalPresentationStyle = .fullScreen
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteSubjects.count
    }
    
    // Configuaration of the collectionview item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.titleLabel.text = favoriteSubjects[indexPath.row].name
        cell.barSeparator.backgroundColor = .white.withAlphaComponent(0.0)
        cell.contentView.layer.cornerRadius = 7
        cell.contentView.backgroundColor = colorPrimary
        return cell
    }
    
    // Action when the collectionview item is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Remove from favorite", message: "You can always access your content by signing back in", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
            alert.addAction(UIAlertAction(title: "Delete",
                                          style: UIAlertAction.Style.destructive,
                                          handler: {(_: UIAlertAction!) in
                CD_FavoriteSubjectRepository(coreDataStack: CoreDataStack.shared).removeFavoriteSubject(favoriteSubject: self.favoriteSubjects[indexPath.row]) {
                            print("delete")
                        
                        self.refreshCollectionView()
                }
            }))
            self.present(alert, animated: true, completion: nil)
    }
    
    // Define the size of the collectionview item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3.5 - 5, height: 50)
    }
}
