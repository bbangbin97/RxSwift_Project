//
//  NetworkRouter.swift
//  RxSwift_Project
//
//  Created by 정영빈 on 27/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkRouter : URLRequestConvertible {
    
    case imageInfo
  
    
    private var method : HTTPMethod{
        switch self{
        case.imageInfo :
            return .get
            
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try CommonConstant.flickrUrl.asURL()
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        //Headers
        //Some Logic to create Header
        
        //Parameters
        //Some Logic to create BODY for POST METHOD
        
        return urlRequest
    }
    
}
