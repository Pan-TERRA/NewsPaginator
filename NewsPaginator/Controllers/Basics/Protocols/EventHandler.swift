//
//  EventHandler.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import UIKit

protocol EventHandler {}

extension EventHandler {
    
    func showAlertWith(error: Error, controller: UIViewController?, completion: ((UIAlertAction)->())? = nil) {
        if let customError = error as? NPError {
            showAlertWith(text: customError.localizedDescription, controller: controller)
        } else {
            showAlertWith(text: error.localizedDescription, controller: controller)
        }
    }
    
    func showAlertWith(text: String, controller: UIViewController?, completion: ((UIAlertAction)->())? = nil) {
        
        let alertVC = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: completion)
        alertVC.addAction(okAction)
        
        controller?.present(alertVC, animated: true, completion: nil)
    }
    
}
