//
//  CustomCollectionViewCell.swift
//  NewsApp
//
//  Created by Wass on 14/04/2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    
    var barSeparator: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(barSeparator)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        barSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        barSeparator.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        barSeparator.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant:  3).isActive = true
        barSeparator.widthAnchor.constraint(equalToConstant: 3).isActive = true
        barSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    
