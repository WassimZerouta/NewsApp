//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by Wass on 12/04/2023.
//

import UIKit
import Alamofire

class BookmarksViewController: UIViewController {
    
    var cd_articles = [CD_Article]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.text = "BOOKMARKS:"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    override func viewDidLoad(){
        navigationItem.title = "BBB"
        super.viewDidLoad()
        createTitle()
        createTableView()
        setupTableView()
        view.backgroundColor = .systemGroupedBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CD_ArticleRepository().getArticles { CD_Articles in
            DispatchQueue.main.async {
                self.cd_articles = CD_Articles
                self.cd_articles.removeAll { cd_article in
                    cd_article.title == nil
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func createTitle() {
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func createTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  cd_articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsTableViewCell {
            let article = cd_articles[indexPath.row]
            
            if let urlToImage = article.urlToImage {
            AF.request(  urlToImage ,method: .get).response{ response in
                switch response.result {
                case .success(let responseData):
                    cell.image.image = UIImage(data: responseData!)!
                case .failure(let error):
                    print(error)
                }
            }
        }
            
            if let title = article.title { cell.title.text = title}
            if let description = article.desc { cell.contentDescription.text = description}
            return cell
        }
        
        else { let defaultCell = UITableViewCell(); return defaultCell }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
