//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Wass on 06/04/2023.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {
    
    var favoriteSubject = CD_FavoriteSubject(context: CoreDataStack.sharedInstance.viewContext)
    var cd_favoriteSubject = [CD_FavoriteSubject]()
    
    var searchArray = [String]()
    
    let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.isHidden = false
        // searchBar.borderColor = Colors.colorPrimary()
        searchBar.placeholder = "Search.."
        return searchBar
    }()
    
    let animation: LottieAnimationView = {
        var animation = LottieAnimationView()
        animation = .init(name: "news")
        animation.contentMode = .scaleToFill
        animation.loopMode = .playOnce
        animation.animationSpeed = 1.5
        animation.alpha = 0.5
        return animation
    }()
    
    let addFavoriteSubjectButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    let favoriteSubjectLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Favorites Subjects !"
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.textColor = UIColor(red: 0.41, green: 0.65, blue: 0.68, alpha: 1.00)
        return label
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    let colorPrimary = UIColor(red: 0.41, green: 0.65, blue: 0.68, alpha: 1.00)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupCollectionView()
        createSearchBar()
        createFavoriteSubjectLabel()
        createAddFavoriteSubjectButton()
        createFavoritesSection()
        collectionView.backgroundView = animation
        animation.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCollectionView()
        
    }
    
    func createSearchBar() {
        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func createFavoriteSubjectLabel() {
        self.view.addSubview(favoriteSubjectLabel)
        favoriteSubjectLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteSubjectLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        favoriteSubjectLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        favoriteSubjectLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        favoriteSubjectLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func createAddFavoriteSubjectButton() {
        self.view.addSubview(addFavoriteSubjectButton)
        addFavoriteSubjectButton.translatesAutoresizingMaskIntoConstraints = false
        addFavoriteSubjectButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        addFavoriteSubjectButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addFavoriteSubjectButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addFavoriteSubjectButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addFavoriteSubjectButton.addTarget(self, action: #selector(addFavoriteSubjectButtonPressed), for: .touchUpInside)
    }
        
    private func createFavoritesSection() {
        self.view.addSubview(collectionView)
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: favoriteSubjectLabel.bottomAnchor, constant: 20).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    
    @objc func addFavoriteSubjectButtonPressed() {
        let alertController = UIAlertController(title: "Add new favorite subject !", message: nil, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
                    if let txtField = alertController.textFields?.first, let text = txtField.text {
                            // create entity instance with context
                        self.favoriteSubject = CD_FavoriteSubjectRepository().saveFavoriteSubject(name: text, isAdded: true, completion: {
                            print("\(text) is added")
                        })
                        self.refreshCollectionView()
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                alertController.addTextField { (textField) in
                    textField.placeholder = "Sport, music.."
                }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
        
    }
    
    func refreshCollectionView() {
        CD_FavoriteSubjectRepository().getFavoriteSubject { CD_FavoriteSubject in
            DispatchQueue.main.async {
                self.cd_favoriteSubject = CD_FavoriteSubject
                self.cd_favoriteSubject.removeAll { cd_favoriteSubject in
                    cd_favoriteSubject.name == nil
                }
                self.collectionView.reloadData()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchArray.append(searchBar.text!)
        print(searchArray)
        let vc = MainViewController()
        vc.subject = searchBar.text
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cd_favoriteSubject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.titleLabel.text = cd_favoriteSubject[indexPath.row].name
        cell.contentView.layer.cornerRadius = 7
        cell.contentView.backgroundColor = colorPrimary
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Remove from favorite", message: "You can always access your content by signing back in", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
            alert.addAction(UIAlertAction(title: "Delete",
                                          style: UIAlertAction.Style.destructive,
                                          handler: {(_: UIAlertAction!) in
                
                for favorite in self.cd_favoriteSubject {
                    if favorite.name == self.favoriteSubject.name {
                        CD_FavoriteSubjectRepository().removeFavoriteSubject(favoriteSubject: self.favoriteSubject) {
                            print("Delete")
                        }
                        self.refreshCollectionView()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3.5 - 5, height: 50)
    }
}
