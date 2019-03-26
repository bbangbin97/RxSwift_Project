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
    static var items = [FlickrModel.FlickrItemModel]()
    
    static func getImageInfo() -> Void {
        _ = RxAlamofire.requestData(.get, CommonConstant.flickrUrl)
            .mapCodableObject(type: FlickrModel.FlickrModel.self)
            .subscribe({ response in
                _ = response.map { FlickrViewModel.items = $0.items  }
                FlickrViewModel.itemsCount = FlickrViewModel.items.count
            })
    }
    
    //    static func loadImageView() -> Observable<Data>{
    //
    //    }
    
//    static func loadImageView(Url : String?) -> Observable<UIImage?> {
//        return convertImageData(Url: Url)
//            .map{ data in
//                return UIImage(data : data)
//        }
//    }
    
//    static func convertImageData(Url : String?) -> Observable<Data>{
//        return Observable.from(optional: Url)
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
//            .map{ URL( string: $0 ) }
//            .filter{ $0 != nil }
//            .map{ $0! }
//            .map{ try Data( contentsOf: $0 )}
//    }
}
