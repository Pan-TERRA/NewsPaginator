//
//  NPError.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import Alamofire
import SwiftyJSON

class NPError: Error {
    
    let error: Error
    let readableData: String?
    let statusCode: Int?
    let json: JSON?
    
    var afError: AFError? {
        return error as? AFError
    }
    
    init(error: Error, readableData: String? = nil, statusCode: Int? = nil, json: JSON? = nil) {
        self.error = error
        self.readableData = readableData
        self.statusCode = statusCode
        self.json = json
    }
    
    var localizedDescription: String {
        return readableData ?? error.localizedDescription
    }
    
    var isNoInternetConnectionError: Bool {
        return localizedDescription == "The Internet connection appears to be offline."
    }
    
    static var unknownError: NPError {
        let nsError = NSError(domain: "com.uptech-test.NewsPaginator", code: 0, userInfo: nil)
        let localizedReadableData = "Unknown Error"
        return NPError(error: nsError, readableData: localizedReadableData, statusCode: 0)
    }
    
    static func createError(readableData: String) -> NPError {
        return NPError(error: unknownError, readableData: readableData, statusCode: 0)
    }
}


