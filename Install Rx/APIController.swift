//
//  APIController.swift
//  Install Rx
//
//  Created by 정영빈 on 11/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxAlamofire

class ApiController {
    
    
    static let Url = "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    static var timerDisposable : Disposable?
    static var imageUrl : String?
    
    static var items = [ApiModel.flickerItemModel]()
    
    
    static func GetImageInfo() -> Void {
        _ = RxAlamofire.requestData(.get, Url)
            .mapObject(type: ApiModel.flickerModel.self)
            .subscribe({ response in
                _ = response.map { items = $0.items  }
            })
    }

    
}

extension ObservableType {
    
    public func mapObject<T: Codable>(type: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let responseTuple = data as? (HTTPURLResponse, Data)
            
            guard let jsonData = responseTuple?.1 else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
                )
            }
            
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: jsonData)
            
            return Observable.just(object)
        }
    }
    
}
