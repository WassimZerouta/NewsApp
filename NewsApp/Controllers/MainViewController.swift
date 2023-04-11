//
//  ViewController.swift
//  NewsApp
//
//  Created by Wass on 25/03/2023.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    
    let headerView = UIView()
    let separation = UIView()
    let secondSeparation = UIView()
    let scrollView = UIScrollView()
    let tableView = UITableView()
    
    var tabArray = [UIButton]()
        
    var articles: [Article]?
    
    let colorPrimaryDark = UIColor(red: 0.13, green: 0.37, blue: 0.38, alpha: 1.00)
    let colorPrimary = UIColor(red: 0.41, green: 0.65, blue: 0.68, alpha: 1.00)
    let colorGreen = UIColor(red: 0.02, green: 1.00, blue: 0.54, alpha: 1.00)
    let colorRed = UIColor(red: 1.00, green: 0.03, blue: 0.17, alpha: 1.00)
    let colorViolet = UIColor(red: 1.00, green: 0.03, blue: 0.17, alpha: 1.00)
    let colorOrange = UIColor(red: 1.00, green: 0.27, blue: 0.00, alpha: 1.00)
    
    let cellReuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles("Soccer")
        self.view.backgroundColor = colorPrimary
        createHeaderView()
        createFavoritesSection()
        createSeparator()
        createTableView()
        setupTableView()
    }
    
    // Definition of the UI
    
    private func createHeaderView() {
        let title = UILabel()
        self.view.addSubview(headerView)
        headerView.addSubview(title)
        self.view.addSubview(separation)
        headerView.backgroundColor = colorPrimary
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: view.frame.height/7).isActive = true
        
        separation.translatesAutoresizingMaskIntoConstraints = false
        separation.backgroundColor = colorPrimaryDark
        separation.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        separation.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separation.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separation.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "NEWSLY"
        title.font = UIFont(name:"Futura-Bold", size: 25.0)
        title.textColor = UIColor.white
        title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
    }
    
    private func createFavoritesSection() {
        self.view.addSubview(scrollView)
        scrollView.isUserInteractionEnabled = true
        scrollView.backgroundColor = colorPrimary
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: separation.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let tabContainer = UIStackView()
        tabContainer.axis = .horizontal
        scrollView.addSubview(tabContainer)
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
        tabContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        tabContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10).isActive = true
        tabContainer.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        tabContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        createTab("ALL", container: tabContainer)
        createTab("TECH", container: tabContainer)
        createTab("SPORT", container: tabContainer)
        createTab("CINEMA", container: tabContainer)
    }
    
    func createTab(_ title: String, container: UIStackView) {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle(title, for: .normal)
        container.addArrangedSubview(button)
        container.setCustomSpacing(10, after: button)
        button.backgroundColor = UIColor(named: "ColorSecondary")
        button.isUserInteractionEnabled = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tabArray.append(button)
        button.addTarget(self, action: #selector(tapTab), for: .touchUpInside)
    }
    
    
    @objc func tapTab(sender: UIButton!) {
        tabArray.forEach { tab in
            tab.backgroundColor = colorPrimaryDark
        }
        sender.backgroundColor = UIColor.systemOrange
        
        fetchArticles((sender.titleLabel?.text)!)
        tableView.reloadData()
    }
    
    
    
    func createSeparator() {
        self.view.addSubview(secondSeparation)
        secondSeparation.translatesAutoresizingMaskIntoConstraints = false
        secondSeparation.backgroundColor = colorPrimaryDark
        secondSeparation.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        secondSeparation.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        secondSeparation.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        secondSeparation.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    func createTableView() {
        self.view.addSubview(tableView)
        tableView.backgroundColor = colorPrimary
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: secondSeparation.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func fetchArticles(_ q: String) {
        
        NewsAPIHelper.shared.performRequest( q: q ) { _ , Articles in
            DispatchQueue.main.async {
                self.articles = Articles!
                self.tableView.reloadData()
            }
        }
    }
    
    func setupTableView() {
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let article = articles { return article.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsTableViewCell {
            
            AF.request(  articles![indexPath.row].urlToImage! ,method: .get).response{ response in
                switch response.result {
                case .success(let responseData):
                    cell.image.image = UIImage(data: responseData!)!
                case .failure(let error):
                    print(error)
                }
            }
            cell.title.text = articles![indexPath.row].title
            cell.contentDescription.text = articles![indexPath.row].description
            
            return cell
        }
        else { let defaultCell = UITableViewCell(); return defaultCell }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
}


