//
//  APIManager.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import Alamofire
import ObjectMapper

class APIManager {
    
    // MARK: - Constants

    private let newsAPIKey = "c4f1f73e001b40e1883a8078aaad7818"
    private let mainAPIURL = "https://newsapi.org/v2/top-headlines?language=en"
    private var linkToNews: String {
        return "\(mainAPIURL)&apiKey=\(newsAPIKey)"
    }
    
    let networking = Networking()
    
    // MARK: - News Loading
    
    func getCampaigns(page: Int, pageSize: Int, success: @escaping (Any)->(), failure: @escaping (NPError)->()) {
        
        let url = "\(linkToNews)&pageSize=\(pageSize)&page=\(page)"
        
        networking.makeRequestToFullPath(path: url, method: .get, parameters: nil, headers: nil, success: success, failure: failure)
    }
}


