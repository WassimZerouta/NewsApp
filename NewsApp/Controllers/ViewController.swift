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
    let secondSeparation = UIView()
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
        createSeparator()

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
        
        let tabContainer = UIStackView()
        tabContainer.axis = .horizontal
        scrollView.addSubview(tabContainer)
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
        tabContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        tabContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10).isActive = true
        tabContainer.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        tabContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let allTab = UIButton()
        tabContainer.addArrangedSubview(allTab)
        tabContainer.setCustomSpacing(10, after: allTab)
        allTab.layer.cornerRadius = 15
        allTab.setTitle("ALL", for: .normal)
        allTab.backgroundColor = colorGreen
        allTab.widthAnchor.constraint(equalToConstant: 100).isActive = true
        allTab.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let technologyTab = UIButton()
        tabContainer.addArrangedSubview(technologyTab)
        tabContainer.setCustomSpacing(10, after: technologyTab)
        technologyTab.layer.cornerRadius = 15
        technologyTab.setTitle("TECH", for: .normal)
        technologyTab.backgroundColor = colorRed
        technologyTab.widthAnchor.constraint(equalToConstant: 100).isActive = true
        technologyTab.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let sportTab = UIButton()
        tabContainer.addArrangedSubview(sportTab)
        tabContainer.setCustomSpacing(10, after: sportTab)
        sportTab.layer.cornerRadius = 15
        sportTab.setTitle("SPORT", for: .normal)
        sportTab.backgroundColor = colorOrange
        sportTab.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sportTab.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let cinemaTab = UIButton()
        tabContainer.addArrangedSubview(cinemaTab)
        tabContainer.setCustomSpacing(10, after: cinemaTab)
        cinemaTab.layer.cornerRadius = 15
        cinemaTab.setTitle("CINEMA", for: .normal)
        cinemaTab.backgroundColor = UIColor.magenta
        cinemaTab.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cinemaTab.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
    
}


