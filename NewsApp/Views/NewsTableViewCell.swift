//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Wass on 30/03/2023.
//

import UIKit
import Alamofire

class NewsTableViewCell: UITableViewCell {

    let colorPrimary = UIColor(red: 0.41, green: 0.65, blue: 0.68, alpha: 1.00)
    var gradient: CAGradientLayer?

    
    var image = UIImageView()
    var title: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 4
        label.lineBreakMode = .byClipping
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        return label
    }()
    
    var contentDescription: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 4
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.clipsToBounds = false
        label.lineBreakMode = .byClipping
        label.baselineAdjustment = .none
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(image)
        image.addSubview(title)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        image.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
 
        title.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant:  -10).isActive = true
        title.rightAnchor.constraint(equalTo: image.rightAnchor, constant: -10).isActive = true
        title.leftAnchor.constraint(equalTo: image.leftAnchor, constant: 10).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by:  UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))

        let width = self.contentView.bounds.width
        let height = self.contentView.bounds.height
        let sHeight: CGFloat = 200

        if gradient == nil {
            gradient = CAGradientLayer()
            gradient?.colors = [UIColor.clear.cgColor, UIColor.gray.cgColor]
            gradient?.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
            self.image.layer.insertSublayer(gradient!, at: 0)
        } else {
            gradient?.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        }
    }
    
    override func willTransition(to state: UITableViewCell.StateMask) {
        super.willTransition(to: state)

        if let gradient = self.gradient {
            let width = self.contentView.bounds.width
            let height = self.contentView.bounds.height
            let sHeight: CGFloat = 200

            if UIDevice.current.orientation.isLandscape {
                gradient.frame = CGRect(x: width - sHeight, y: 0, width: sHeight, height: height)
            } else {
                gradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
