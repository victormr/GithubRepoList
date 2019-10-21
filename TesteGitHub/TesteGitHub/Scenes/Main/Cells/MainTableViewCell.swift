//
//  MainTableViewCell.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol MainTableViewCellProtocol {
    func requestImage(_ cell: MainTableViewCell, imageURL: String)
}

class MainTableViewCell: UITableViewCell {
    
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    var isLoading: Bool {
        return activityIndicator.isAnimating
    }
    private var model: ServiceResponseModelItem?
    var delegate: MainTableViewCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupActivityIndicator()
        imageView?.image = UIImage(named: "images")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        textLabel?.text = ""
        imageView?.image = UIImage(named: "images")
        detailTextLabel?.text = ""
    }
    
    private func setupActivityIndicator() {
        contentView.addSubview(activityIndicator)

        // Constraints
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let margins = contentView.layoutMarginsGuide
        activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        // Animation
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func setModel(model: ServiceResponseModelItem) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        textLabel?.text = model.name
        if let owner = model.owner?.login {
            detailTextLabel?.text = owner
            let formatter = NumberFormatter()
            formatter.groupingSeparator = "."
            formatter.groupingSize = 3
            formatter.usesGroupingSeparator = true
            if let formattedNumber = formatter.string(from: NSNumber(value: model.stargazers_count)) {
                detailTextLabel?.text = owner + " - \(formattedNumber)" + "⭐"
            }
        }
        detailTextLabel?.numberOfLines = 0
        selectionStyle = .none
        delegate?.requestImage(self, imageURL: model.owner?.avatar_url ?? "")
    }
    
    func setImage(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView?.image = image
        }
    }
}
