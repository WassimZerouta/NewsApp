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
        label.text = "Bookmarks !"
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.textColor = UIColor(red: 0.41, green: 0.65, blue: 0.68, alpha: 1.00)
        return label
    }()

    override func viewDidLoad(){
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
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = cd_articles[indexPath.row].title else {return}
        guard let description = cd_articles[indexPath.row].desc else {return}
        guard let url = cd_articles[indexPath.row].url else {return}
        guard let urlToImage = cd_articles[indexPath.row].urlToImage else {return}
        let vc = WebNiewsViewController(url: url, titles: title, desc: description, urlToImage: urlToImage)
        vc.modalPresentationStyle = .fullScreen
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/3-20 
    }
    
}
