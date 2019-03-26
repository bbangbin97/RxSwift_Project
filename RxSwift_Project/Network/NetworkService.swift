//
//  NetworkService.swift
//  RxSwift_Project
//
//  Created by 정영빈 on 27/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift

class NetworkService {
    
    static func performRequest(router : NetworkRouter ) -> Observable<(HTTPURLResponse,Data)>{
        return RxAlamofire.request(router).responseData()
    }
    
    static func parseData< T : Codable >(data : Data,type : T.Type ) -> T {
        
        let decoder = JSONDecoder()
        let object = try? decoder.decode(T.self, from: data)

        return object!
    }
    
}
