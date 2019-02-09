//
//  BasicVC.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import UIKit
import Reachability

class BasicVC: UIViewController, EventHandler, LoadingVC {
    
    // MARK: - Properties

    var loadingView: LoadingView?
    
    private var reachability = Reachability()
    private(set) var haveInternetConnection: Bool = true {
        didSet {
            guard haveInternetConnection != oldValue else { return }
            if haveInternetConnection {
                internetConnectionAvailable()
            } else {
                internetConnectionLost()
            }
        }
    }
    
    // MARK: - Initializers
    
    /// Constructor will load .xib file with the same name as ClassName
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachability?.whenReachable = { [weak self] _ in
            self?.haveInternetConnection = true
        }
        
        reachability?.whenUnreachable = { [weak self] _ in
            self?.haveInternetConnection = false
        }
        
        try? reachability?.startNotifier()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Internet connection handling
    
    /// This method should be overriden if you want to handle status of internet connection
    func internetConnectionAvailable() {}
    
    /// This method should be overriden if you want to handle status of internet connection
    func internetConnectionLost() {}
}

