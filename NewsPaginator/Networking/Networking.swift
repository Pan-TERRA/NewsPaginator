//
//  Networking.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Networking {
    
    func makeRequestToFullPath(path: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, success: @escaping (Any) -> (), failure: @escaping (NPError) -> ()) {
        
        var encoding: ParameterEncoding = URLEncoding.default
        if method != .get { encoding = JSONEncoding.default }
        
        Alamofire.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                success(data)
                
            case .failure(let error):
                
                print ("\n\(String(describing: method).uppercased()) \(path)")
                print ("ERROR: \(error.localizedDescription)")
                
                if let parameters = parameters {
                    print ("\nPARAMETERS:")
                    for item in parameters {
                        print (item)
                    }
                } else {
                    print ("\nPARAMETERS: nil")
                }
                
                if let headers = headers {
                    print ("\nHEADERS:")
                    for item in headers {
                        print (item)
                    }
                } else {
                    print ("\nHEADERS: nil")
                }
                
                var readableData: String?
                var json: JSON?
                
                if let data = response.data {
                    readableData = String(data: data, encoding: .utf8)
                    json = JSON(data)
                    
                    if readableData?.isEmpty == true {
                        readableData = error.localizedDescription
                    }
                    
                    print("\nREADABLE DATA:\n\(readableData ?? "nil")")
                }
                
                let npError = NPError(error: error, readableData: readableData, statusCode: response.response?.statusCode, json: json)
                
                DispatchQueue.main.async {
                    failure(npError)
                }
            }
        }
    }
    
}
