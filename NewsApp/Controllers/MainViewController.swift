//
//  ViewController.swift
//  NewsApp
//
//  Created by Wass on 25/03/2023.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    
    var subject: String?
    var selectedIndex: IndexPath?
    var articles: [Article]?
    var favoriteSubject = [CD_FavoriteSubject]()
    
    let headerView = UIView()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        var collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    let tableView = UITableView()
    
    var tabArray = [UIButton]()

    let cellReuseIdentifier = "cell"
    
    let refreshController: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        return refreshController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        createHeaderView()
        createTableView()
        createFavoritesSection()
        setupTableView()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CD_FavoriteSubjectRepository(coreDataStack: CoreDataStack.shared).getFavoriteSubject { favorite in
            DispatchQueue.main.async {
                self.favoriteSubject = favorite
                self.favoriteSubject.removeAll { favorite in
                    favorite.name == nil
                }
                guard !self.favoriteSubject.isEmpty else { return self.collectionView.isHidden = true }
                self.collectionView.isHidden = false
                
                self.collectionView.reloadData()
            }
            if favoriteSubject.isEmpty {fetchArticles("Apple") } else { fetchArticles(favoriteSubject[selectedIndex?.row ?? 0].name ?? "Apple")}
        }
          
    }
    
    // Make favorites subjects scrollable
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         if scrollView.contentOffset.y > 0 {
             UIView.animate(withDuration: 0.3) {
                 self.collectionView.alpha = 0
             }
         } else {
             UIView.animate(withDuration: 0.3) {
                 self.collectionView.alpha = 1
             }
         }
     }
    
    // Fetch articles
    func fetchArticles(_ q: String) {
        
        NewsAPIHelper.shared.performRequest( q: q ) { _ , Articles in
            DispatchQueue.main.async {
                self.articles = Articles!
                self.tableView.reloadData()
            }
        }
    }
    
    // Create header view
    private func createHeaderView() {
        let title = UILabel()
        self.view.addSubview(headerView)
        headerView.addSubview(title)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "NEWSAPP"
        title.font = UIFont(name:"Futura-Bold", size: 25.0)
        title.textColor = UIColor(named: "ColorPrimary")
        title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
    }
    
    // Create Favorite section
    private func createFavoritesSection() {
        tableView.addSubview(collectionView)
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        collectionView.backgroundColor = .systemGroupedBackground.withAlphaComponent(0.9)
    }
    
    // Create table view
    func createTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.addSubview(refreshController)
        refreshController.tintColor = UIColor(named: "ColorPrimary")
        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    // set up the table view
    func setupTableView() {
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // set up collection view
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    
    // refresh data for the pull to refresh
    @objc func refreshData() {
        if favoriteSubject.isEmpty {fetchArticles("Apple") } else { fetchArticles(favoriteSubject[selectedIndex?.row ?? 0].name!)}
        refreshController.endRefreshing()
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let article = articles { return article.count } else { return 0 }
    }
    
    // Configuaration of the tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsTableViewCell {
            if let urlToImage = articles![indexPath.row].urlToImage {
            AF.request(  urlToImage ,method: .get).response{ response in
                    switch response.result {
                    case .success(let responseData):
                        DispatchQueue.main.async {
                            cell.image.image = UIImage(data: responseData!)!
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
            if let title = articles![indexPath.row].title { cell.title.text = title }
            if let description = articles![indexPath.row].description { cell.contentDescription.text = description}
            
            return cell
        }
        else { let defaultCell = UITableViewCell(); return defaultCell }
    }
    
    // Define the height of the tableview cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/3-20 
    }
    
    // Action when the tableview cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = articles![indexPath.row].title else {return}
        guard let description = articles![indexPath.row].description else {return}
        guard let url = articles![indexPath.row].url else {return}
        guard let urlToImage = articles![indexPath.row].urlToImage else {return}
        let vc = WebNiewsViewController(url: url, titles: title, desc: description, urlToImage: urlToImage)
        vc.modalPresentationStyle = .fullScreen
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteSubject.count
    }
    
    // Action when the collectionview item is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchArticles(favoriteSubject[indexPath.row].name!)
        tableView.reloadData()
        if let selected = selectedIndex {
            collectionView.deselectItem(at: selected, animated: false)
        }
        selectedIndex = indexPath
        collectionView.reloadData()
    }
    
    // Configuaration of the collectionview item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.titleLabel.text = favoriteSubject[indexPath.row].name
        if selectedIndex == nil && indexPath.row == 0 {
            cell.titleLabel.textColor = UIColor(named: "ColorPrimaryDark")
        } else {
            cell.titleLabel.textColor = indexPath != selectedIndex ? UIColor(named: "ColorPrimaryDark")  : UIColor(named: "ColorPrimary")
        }
        return cell
    }
    
    // Define the size of the collectionview item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/4 - 3, height: 40)
    }
    
    // Define the edges of the collectionview item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
    }
    
    
}


