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
        label.text = "Bookmarks"
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
        CD_ArticleRepository(coreDataStack: CoreDataStack.shared ).getArticles { CD_Articles in
            DispatchQueue.main.async {
                self.cd_articles = CD_Articles
                self.cd_articles.removeAll { cd_article in
                    cd_article.title == nil
                }
                if self.cd_articles.isEmpty { self.addAlert()}
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CD_ArticleRepository(coreDataStack: CoreDataStack.shared).getArticles { CD_Articles in
            DispatchQueue.main.async {
                self.cd_articles = CD_Articles
                self.cd_articles.removeAll { cd_article in
                    cd_article.title == nil
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // Add addAlert when there are 0 favorite article
    func addAlert() {
        let addAlert = UIAlertController(title: "Add your favorites news !", message: " You still don't have bookmarks ! You can add more by pressing the bookmarks button in the news", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        addAlert.addAction(cancelAction)
        self.present(addAlert, animated: true, completion: nil)
    }

    // Create title
    func createTitle() {
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // Create table view
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
    
    // Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  cd_articles.count
    }
    
    // Configuaration of the tableview cell
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
    
    // Action when the tableview cell is selected
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
    
    // Define the height of the tableview cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/3-20 
    }
    
}
