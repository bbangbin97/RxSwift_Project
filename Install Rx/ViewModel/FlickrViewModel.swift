//
//  FlickrViewModel.swift
//  Install Rx
//
//  Created by 정영빈 on 20/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift

class FlickrViewModel {
    
    static var itemsCount : Int?
    static var items = [FlickrModel.flickrItemModel]()
    
    static func GetImageInfo() -> Void {
        _ = RxAlamofire.requestData(.get, CommonConstant.flickrUrl)
            .mapCodableObject(type: FlickrModel.flickrModel.self)
            .subscribe({ response in
                _ = response.map { FlickrViewModel.items = $0.items  }
                FlickrViewModel.itemsCount = FlickrViewModel.items.count
            })
    }
    

//    func LoadImageView(Url : String?) -> Observable<Data>{
//        _ = Observable.from(optional: Url)
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
//            .map{ URL( string: $0 ) }
//            .filter{ $0 != nil }
//            .map{ $0! }
//            .map{ imageURL -> Observable<Data> in
//                let imageData = try Data( contentsOf: imageURL )
//                return Observable.just(imageData)
//        }
//    }
//    
}
