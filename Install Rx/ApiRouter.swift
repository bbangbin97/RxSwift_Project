//
//  ApiRouter.swift
//  Install Rx
//
//  Created by 정영빈 on 13/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter : URLRequestConvertible {
    
    
    case getImage
    
    private var method : HTTPMethod{
        switch self{
        case.getImage :
            return .get
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = try ApiController.baseUrl.asURL()
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue

        return urlRequest
    }
    
}
