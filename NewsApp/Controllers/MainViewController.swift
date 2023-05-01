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
        
    var articles: [Article]?
    var cd_favoriteSubject = [CD_FavoriteSubject]()

    let colorPrimaryDark = UIColor(red: 0.13, green: 0.37, blue: 0.38, alpha: 1.00)
    let colorPrimary = UIColor(red: 0.41, green: 0.65, blue: 0.68, alpha: 1.00)
    let colorGreen = UIColor(red: 0.02, green: 1.00, blue: 0.54, alpha: 1.00)
    let colorRed = UIColor(red: 1.00, green: 0.03, blue: 0.17, alpha: 1.00)
    let colorViolet = UIColor(red: 1.00, green: 0.03, blue: 0.17, alpha: 1.00)
    let colorOrange = UIColor(red: 1.00, green: 0.27, blue: 0.00, alpha: 1.00)
    
    let cellReuseIdentifier = "cell"
    
    let refreshController: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        return refreshController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let search = subject { fetchArticles(search)} else { fetchArticles("Google")}
        view.backgroundColor = .systemGroupedBackground
        createHeaderView()
        createTableView()
        createFavoritesSection()
        setupTableView()
        setupCollectionView()
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CD_FavoriteSubjectRepository().getFavoriteSubject { CD_FavoriteSubject in
            DispatchQueue.main.async {
                self.cd_favoriteSubject = CD_FavoriteSubject
                self.cd_favoriteSubject.removeAll { cd_favoriteSubject in
                    cd_favoriteSubject.name == nil
                }
                if self.cd_favoriteSubject.isEmpty { self.collectionView.isHidden = true} else { self.collectionView.isHidden = false}
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchArticles(_ q: String) {
        
        NewsAPIHelper.shared.performRequest( q: q ) { _ , Articles in
            DispatchQueue.main.async {
                self.articles = Articles!
                self.tableView.reloadData()
            }
        }
    }
    
    // Definition of the UI
    
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
        title.textColor = colorPrimary
        title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
    }
    
    private func createFavoritesSection() {
        tableView.addSubview(collectionView)
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        collectionView.backgroundColor = .systemGroupedBackground.withAlphaComponent(0.9)
    }
    
    func createTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.addSubview(refreshController)
        refreshController.tintColor = colorPrimary
        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func setupTableView() {
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    
    @objc func refreshData() {
        if let search = subject { fetchArticles(search)} else { fetchArticles("Google")}
        refreshController.endRefreshing()
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let article = articles { return article.count } else { return 0 }
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/3-20 
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cd_favoriteSubject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchArticles(cd_favoriteSubject[indexPath.row].name!)
        tableView.reloadData()
        if let selected = selectedIndex {
            collectionView.deselectItem(at: selected, animated: false)
        }
        selectedIndex = indexPath
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.titleLabel.text = cd_favoriteSubject[indexPath.row].name
        cell.titleLabel.textColor = indexPath != selectedIndex ? colorPrimary : colorPrimaryDark
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/4 - 3, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
    }
    
    
}


