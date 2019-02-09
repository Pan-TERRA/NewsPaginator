//
//  LoadingVC.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import UIKit

protocol LoadingVC: class {
    var loadingView: LoadingView?  { get set }
}

extension LoadingVC where Self: UIViewController {
    
    func startLoading() {
        
        if loadingView == nil {
            loadingView = LoadingView(frame: view.bounds)
            
            DispatchQueue.main.async {
                self.view.addSubview(self.loadingView!)
                
                self.loadingView!.translatesAutoresizingMaskIntoConstraints = false
                
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self.loadingView!]))
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self.loadingView!]))
            }
        }
    }
    
    func stopLoading() {
        
        DispatchQueue.main.async {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}
