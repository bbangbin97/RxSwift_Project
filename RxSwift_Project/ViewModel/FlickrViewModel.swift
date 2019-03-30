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
    
    var timer = Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.instance)
    var imageData : Observable<Data>!
    
    //var currentCount : Int = 0
    //var flickrModel : Observable<FlickrModel.FlickrBaseModel>
    var flickrModel : FlickrModel.FlickrBaseModel!
    
    init(flickrAPIService : FlickrAPIService, playButton : Observable<Void> ){
        
        self.flickrService = flickrAPIService
        
        imageData = flickrService.getFlickrModel()
            .map{ self.flickrModel = $0 }
            .flatMapLatest{ self.timer }
            .map{ $0 % self.flickrModel.items.count }
            .map{ self.flickrModel.items[$0].media.m }
            .flatMapLatest { self.flickrService.loadImageData(url: $0) }
        
        _  = playButton.subscribe(onNext : {
            print("play")
        })
    
    }
    
    
    
}
