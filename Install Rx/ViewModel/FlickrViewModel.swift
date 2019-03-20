//
//  FlickrViewModel.swift
//  Install Rx
//
//  Created by 정영빈 on 20/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation
import RxAlamofire

class FlickrViewModel {
    
    static var itemsCount : Int?
    static var items = [FlickrModel.flickrItemModel]()
    
    static func GetImageInfo() -> Void {
        _ = RxAlamofire.requestData(.get, CommonConstant.flickrUrl)
            .mapCodableObject(type: FlickrModel.flickrModel.self)
            .subscribe({ response in
                _ = response.map { FlickrViewModel.items = $0.items  }
                FlickrViewModel.itemsCount = FlickrViewModel.items.count
                print(FlickrViewModel.items.count)
            })
    }
    
}
