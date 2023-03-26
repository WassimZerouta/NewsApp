//
//  ViewController.swift
//  NewsApp
//
//  Created by Wass on 25/03/2023.
//

import UIKit

class MainViewController: UIViewController {
    
    let headerView = UIView()
    let separation = UIView()
    let scrollView = UIScrollView()
    
    let colorPrimaryDark = UIColor(red: 0.13, green: 0.37, blue: 0.38, alpha: 1.00)
    let colorPrimary = UIColor(red: 0.41, green: 0.65, blue: 0.68, alpha: 1.00)
    let colorGreen = UIColor(red: 0.02, green: 1.00, blue: 0.54, alpha: 1.00)
    let colorRed = UIColor(red: 1.00, green: 0.03, blue: 0.17, alpha: 1.00)
    let colorViolet = UIColor(red: 1.00, green: 0.03, blue: 0.17, alpha: 1.00)
    let colorOrange = UIColor(red: 1.00, green: 0.27, blue: 0.00, alpha: 1.00)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colorPrimary
        createHeaderView()
        createFavoritesSection()

        // Do any additional setup after loading the view.
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
        
        let v = UIStackView()
        v.axis = .horizontal
        scrollView.addSubview(v)
        v.backgroundColor = UIColor.red
        v.translatesAutoresizingMaskIntoConstraints = false
        v.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        v.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        v.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        v.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        v.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        let a = UIView()
        v.addArrangedSubview(a)
        a.backgroundColor = UIColor.yellow
        a.widthAnchor.constraint(equalToConstant: 600).isActive = true
        a.heightAnchor.constraint(equalTo: v.heightAnchor).isActive = true
        
    }
    
}


