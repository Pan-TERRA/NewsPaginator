//
//  NewsViewModel+HelperEntities.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import ObjectMapper

struct PagedNewsResponse: Mappable {
    
    enum Status: String {
        case ok = "ok"
        case error = "error"
    }
    
    // MARK: - Properties

    var news: [NewModel]?
    var total: Int?
    var page: Int?
    
    var status: Status?
    var errorMessage: String?
    
    // MARK: - Mappable

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        news <- map["articles"]
        total <- map["totalResults"]
        
        status <- (map["status"], EnumTransform<PagedNewsResponse.Status>())
        errorMessage <- map["message"]
    }
}
