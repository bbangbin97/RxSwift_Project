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

class FlickrAPIService {
    
    func performRequest(router : NetworkRouter ) -> Observable<(HTTPURLResponse,Data)>{
        return RxAlamofire.request(router).responseData()
    }
    
    func parseData< T : Codable >(data : Data,type : T.Type ) -> T {
        
        let decoder = JSONDecoder()
        let object = try? decoder.decode(T.self, from: data)

        return object!
    }
    
    func getFlickrModel() -> Observable<FlickrModel.FlickrBaseModel>{
        print("Make HTTP Request")
        return performRequest(router: NetworkRouter.imageInfo)
            .map{
                self.parseData(data: $0.1, type: FlickrModel.FlickrBaseModel.self)
            }
    }
    
    func loadImageData( url : String ) -> Observable<Data>{

        return Observable.from(optional: url)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ URL( string: $0 ) }
            .filter{ $0 != nil }
            .map{ $0! }
            .map{ try Data( contentsOf: $0 ) }
    }
    
    
}
