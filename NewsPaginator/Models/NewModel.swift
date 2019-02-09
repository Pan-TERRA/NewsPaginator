//
//  NewModel.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import ObjectMapper
import RealmSwift

class NewModel: Object, Mappable {
    
    @objc dynamic var title: String = ""
    @objc dynamic var shortDescription: String = ""
    @objc dynamic var content: String = ""
    
    @objc dynamic var author: String = ""
    @objc dynamic var publishedAtString: String = ""
    
    @objc dynamic var urlToOriginalPage: String = ""
    @objc dynamic var urlToImage: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        shortDescription <- map["description"]
        content <- map["content"]
        
        author <- map["author"]
        publishedAtString <- map["publishedAt"]
        
        urlToOriginalPage <- map["url"]
        urlToImage <- map["urlToImage"]
    }
    
    override class func primaryKey() -> String {
        return "urlToOriginalPage"
    }
    
    func update(with another: NewModel) {
        
        guard urlToOriginalPage == another.urlToOriginalPage else { return }
        
        title = another.title
        shortDescription = another.shortDescription
        content = another.content
        
        author = another.author
        urlToImage = another.urlToImage
    }
}

extension NewModel {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    
    var publishedAt: Date? {
        return NewModel.dateFormatter.date(from: publishedAtString)
    }
}
