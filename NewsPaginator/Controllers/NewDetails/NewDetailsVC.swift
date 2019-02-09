
//
//  NewDetailsVC.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import UIKit

class NewDetailsVC: BasicVC {
    
    // MARK: - Constants
    
    private static let imagePlacegolder = UIImage(named: "emptyImage")
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy 'at' HH:mm"
        return formatter
    }()
    
    // MARK: - Properties
    
    var new: NewModel
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var readMoreContainer: UIView!
    @IBOutlet weak var readMoreButton: UIButton!
    var gradientLayer = CAGradientLayer()
    
    // MARK: - Lifecycle
    
    init(new: NewModel) {
        self.new = new
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Yoy have to provide NewModel object to create NewDetailsVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        setImage()
        setLabels()
        setGradient()
    }
    
    // MARK: - Setup
    
    private func setImage() {
        
        if let imageURL = URL(string: new.urlToImage) {
            
            imageView?.af_setImage(withURL: imageURL, completion: { [weak self] response in
                guard self != nil else { return }
                
                if let image = response.result.value {
                    
                    let imageViewHeight = self!.imageView.frame.width * image.size.height / image.size.width
                    
                    self?.imageViewHeight.constant = imageViewHeight
                    UIView.animate(withDuration: 0.3, animations: {
                        self!.view.layoutIfNeeded()
                    })
                } else {
                    self!.imageView?.image = NewDetailsVC.imagePlacegolder
                }
            })
        } else {
            imageView?.image = NewDetailsVC.imagePlacegolder
        }
    }
    
    private func setLabels() {
        
        titleLabel?.text = new.title
        titleLabel?.sizeToFit()
        titleLabelHeight?.constant = titleLabel?.frame.height ?? 0
        
        if !new.author.isEmpty {
            authorLabel?.text = new.author
        } else {
            authorLabel?.text = "Unknown Author"
        }
        if let publishedDate = new.publishedAt {
            dateLabel?.text = NewDetailsVC.dateFormatter.string(from: publishedDate)
        } else {
            dateLabel?.text = "Recently"
        }
        
        contentLabel?.text = new.content
        contentLabel?.sizeToFit()
        contentLabelHeight?.constant = contentLabel?.frame.height ?? 0
        
        
    }
    
    private func setGradient() {

        gradientLayer.frame = readMoreContainer.bounds
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 0.5]
        readMoreContainer.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Actions
    
    @IBAction func openFullPageTapped(_ sender: Any) {
        LinksManager.shared.openURL(new.urlToOriginalPage, sender: self)
    }
}
