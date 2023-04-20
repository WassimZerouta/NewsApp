//
//  WebNiewsViewController.swift
//  NewsApp
//
//  Created by Wass on 12/04/2023.
//

import UIKit
import WebKit

class WebNiewsViewController: UIViewController {
    
    var article = CD_Article(context: CoreDataStack.sharedInstance.viewContext)
    var stringUrl = String()
    var desc = String()
    var urlToImage = String()
    var titles = String()
    
    var cd_articles: [CD_Article]?
    
    init(url: String, titles: String, desc: String, urlToImage: String) {
        self.stringUrl = url
        self.desc = desc
        self.urlToImage = urlToImage
        super.init(nibName: nil, bundle: nil)
        self.titles = titles
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let webView: WKWebView = {
        var view = WKWebView()
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configutations = WKWebViewConfiguration()
        configutations.defaultWebpagePreferences = preferences
        return view
    }()
    
    let bookmarkButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        webView.navigationDelegate = self
        createWebView()
        createNavItemButtons()
        createbookmarkButton()
        loadNewsUrl(stringUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshFavorite()
        
    }
    
    func refreshFavorite() {
        CD_ArticleRepository().getArticles { CD_Articles in
            DispatchQueue.main.async { [self] in
                self.cd_articles = CD_Articles
                self.cd_articles!.removeAll { cd_article in
                    cd_article.title == nil
                }
                bookmarkButton.tintColor = checkIsAdded(CD_Articles: self.cd_articles!, articleTitle: titles)
            }
        }
        
    }
    
    func checkIsAdded(CD_Articles: [CD_Article], articleTitle: String) -> UIColor {
        var color = UIColor.red
        let titleArray = CD_Articles.map( { $0.title! })
            if titleArray.contains(where: { title in
                title == articleTitle
            }) {
                self.article.isAdded = true
                color = UIColor.systemGreen
            }
            else {
                self.article.isAdded = false
               color = UIColor.red
            }
        return color
    }
    
    func createWebView() {
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    func createbookmarkButton() {
        self.view.addSubview(bookmarkButton)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.topAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        bookmarkButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        bookmarkButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        bookmarkButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        bookmarkButton.addTarget(self, action: #selector(bookmarkHandler), for: .touchUpInside)
        
    }
    
    func createNavItemButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.backward"), style: .done, target: self, action: #selector(backButton))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareButton))
        
    }
    
    @objc func bookmarkHandler() {
        
        for article in cd_articles! {
            if let title = article.title {
                if title == titles {
                   removeArticle(article: article)
                }
            }
        }
        if article.isAdded == true {
            removeArticle(article: self.article)
        } else {
            saveArticle(title: titles, desc: desc, url: stringUrl, urlToImage: urlToImage, isAdded: true)
        }
        
    }
    
    func saveArticle(title: String, desc: String, url: String, urlToImage: String, isAdded: Bool) {
        // create entity instance with context
        article = CD_ArticleRepository().saveArticle(title: title, desc: desc, url: url, urlToImage: urlToImage, isAdded: isAdded) {
            bookmarkButton.tintColor = .systemGreen
        }
    }
    
    
    func removeArticle(article: CD_Article) {
        CD_ArticleRepository().removeArticles(article: article) {
            bookmarkButton.tintColor = .red
        }
    }
    
    @objc func backButton() {
        dismiss(animated: true)
    }
    
    @objc func shareButton() {
        let activityController = UIActivityViewController(activityItems: [URL(string: stringUrl)!] , applicationActivities: nil)
        present(activityController, animated: true)

    }
    
    func loadNewsUrl(_ stringUrl: String) {
        let newsUrl = URL(string: stringUrl)
        if let url = newsUrl {
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url))
            }
        }
        else {
            print("ERR: INNACCESSIBLE CONTENT")
        }
    }

}

extension WebNiewsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.host {
            if host.contains(".com") {
                decisionHandler(.allow)
                return
            }
        }

        decisionHandler(.cancel)
    }
}
