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
    
    private let flickrService : FlickrAPIService
    private let disposeBag = DisposeBag()

    //let timer = Observable<Int>.timer(0, period: 4, scheduler: MainScheduler.instance)
    
    let imageData : Observable<Data>
    
    //var imageCount : Int
    var currentCount : Int = 0
    var flickrModel : Observable<FlickrModel.FlickrBaseModel>
    
    init(flickrAPIService : FlickrAPIService ){
        
        self.flickrService = flickrAPIService
        
        flickrModel = flickrService.getFlickrModel()
        
        imageData = flickrModel
            .map{ $0.items[0].media.m }
            .flatMap{ FlickrAPIService.loadImageData(url: $0) }
        
        
    }
    
    
}
