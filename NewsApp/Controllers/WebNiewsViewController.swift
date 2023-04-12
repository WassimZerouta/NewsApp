//
//  WebNiewsViewController.swift
//  NewsApp
//
//  Created by Wass on 12/04/2023.
//

import UIKit
import WebKit

class WebNiewsViewController: UIViewController {
    
    init(url: String, title: String) {
        self.stringUrl = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
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
    
    var stringUrl = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        createWebView()
        createNavItemButtons()
        loadNewsUrl(stringUrl)
        

    }
    
    func createWebView() {
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func createNavItemButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.backward"), style: .done, target: self, action: #selector(backButton))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareButton))
        
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
            webView.load(URLRequest(url: url))
        }
        else {
            print("CONTENU INNACCESSIBLE")
        }
    }

}
