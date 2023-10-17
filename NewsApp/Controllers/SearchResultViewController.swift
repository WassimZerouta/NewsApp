//
//  SearchResultViewController.swift
//  NewsApp
//
//  Created by Wass on 27/04/2023.
//

import UIKit
import Alamofire

class SearchResultViewController: UIViewController {

    var subject: String?
    let tableView = UITableView()

    var articles: [Article]?
    
    let cellReuseIdentifier = "cell"
    
    init(subject: String) {
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let search = subject { fetchArticles(search)} else { fetchArticles("Google")}
        view.backgroundColor = .systemGroupedBackground
        createTableView()
        setupTableView()
        let backButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.leftBarButtonItem = backButton

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
   
    // Action when BackButton is pressed
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    // Create table view
    func createTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // Set up table view
    func setupTableView() {
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
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
