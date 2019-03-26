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
    
    static func getImageData() {
        _ = NetworkService.performRequest(router: NetworkRouter.imageInfo)
            .map{
                NetworkService.parseData(data: $0.1, type: FlickrModel.FlickrBaseModel.self)
            }
            .subscribe(onNext:{
                items = $0.items
            })
    }
}
