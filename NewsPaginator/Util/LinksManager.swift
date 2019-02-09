//
//  LinksManager.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/9/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import UIKit

class LinksManager {
    
    static let shared = LinksManager()
    
    func openURL(_ url: String, sender: UIViewController?) {
        openURL(URL(string: url), sender: sender)
    }
    
    func openURL(_ url: URL?, sender: UIViewController?) {
        
        if url != nil {
            
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                showError("Invalid URL", on: sender)
            }
            
        } else {
            showError("Invalid URL", on: sender)
        }
        
    }
    
    private func showError(_ errorMessage: String, on vc: UIViewController?) {
        let alertVC = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        
        vc?.present(alertVC, animated: true, completion: nil)
    }
    
}
