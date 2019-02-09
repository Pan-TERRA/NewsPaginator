//
//  NewItemTVCell.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import UIKit
import AlamofireImage
import ConvenientKit

class NewItemTVCell: UITableViewCell, NibLoadableView {

    // MARK: - Constants
    
    static let height: CGFloat = 128.0
    private static let imagePlacegolder = UIImage(named: "emptyImage")

    // MARK: - Properties

    weak var newModel: NewModel? {
        didSet {
            setViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Management
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbImageView?.image = NewItemTVCell.imagePlacegolder
        activityIndicator?.stopAnimating()
    }

    private func setViews() {
        
        if let title = newModel?.title, !title.isEmpty {
            titleLabel?.text = title
        } else {
            titleLabel?.text = "Title not provided by Newsapi.org"
        }
        
        descriptionLabel?.text = newModel?.shortDescription
        
        if let imageURL = URL(string: newModel?.urlToImage ?? "") {
            activityIndicator?.startAnimating()
            thumbImageView?.af_setImage(withURL: imageURL, placeholderImage: NewItemTVCell.imagePlacegolder, completion: { [weak self] response in
                
                self?.activityIndicator?.stopAnimating()
            })
        } else {
            thumbImageView?.image = NewItemTVCell.imagePlacegolder
        }
    }
    
}
