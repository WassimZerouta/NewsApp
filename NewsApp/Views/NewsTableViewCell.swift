//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Wass on 30/03/2023.
//

import UIKit
import Alamofire

class NewsTableViewCell: UITableViewCell {
    
    var article = CD_Article(context: CoreDataStack.sharedInstance.viewContext)
    
    var image = UIImageView()
    var title: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 4
        label.lineBreakMode = .byClipping
        label.baselineAdjustment = .alignCenters
        return label
    }()
    
    var contentDescription: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 4
        label.clipsToBounds = false
        label.lineBreakMode = .byClipping
        label.baselineAdjustment = .none
        return label
    }()
    
    var url = String()
    var urlToImage = String()

        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(image)
        image.addSubview(title)
        image.addSubview(contentDescription)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        contentDescription.translatesAutoresizingMaskIntoConstraints = false
        
        image.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
 
        title.bottomAnchor.constraint(equalTo: contentDescription.topAnchor, constant: -20).isActive = true
        title.rightAnchor.constraint(equalTo: image.rightAnchor, constant: -10).isActive = true
        title.leftAnchor.constraint(equalTo: image.leftAnchor, constant: 10).isActive = true
        
        contentDescription.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant:  -10).isActive = true
        contentDescription.rightAnchor.constraint(equalTo: image.rightAnchor, constant: -10).isActive = true
        contentDescription.leftAnchor.constraint(equalTo: image.leftAnchor, constant: 10).isActive = true
    }
    
    override func layoutSublayers(of layer: CALayer) {
        
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight:CGFloat = 300
        
        if image.layer.sublayers?.first is CAGradientLayer {
            }
        else {
            let gradient = CAGradientLayer()
          //  gradient.colors = [UIColor.clear.cgColor, colorPrimary]
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
            image.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by:  UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
