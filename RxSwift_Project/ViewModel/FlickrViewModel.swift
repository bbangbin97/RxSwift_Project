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
    
    let intervalValue : Observable<Int>
    
    var flickrModel : FlickrModel.FlickrBaseModel!
    
    init(flickrAPIService : FlickrAPIService, playButton : Observable<Void>, pauseButton : Observable<Void>, stopButton : Observable<Void>, imageIntervalSlider : Observable<Float>){
        
        self.flickrService = flickrAPIService
        
        intervalValue = imageIntervalSlider
            .throttle(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ Int(round( $0 * 10 )+1) }
        
        imageData = flickrService.getFlickrModel()
            .retry(3)
            .map{ self.flickrModel = $0 }
            .flatMapLatest{ imageIntervalSlider }
            .throttle(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ Double(round($0*10)+1) }
            .flatMapLatest{ Observable<Int>.timer(0, period: $0, scheduler: MainScheduler.instance) }
            .map{ $0 % self.flickrModel.items.count }
            .map{ self.flickrModel.items[$0].media.m }
            .flatMapLatest { self.flickrService.loadImageData(url: $0) }
        
    
    }
    
    
    
}
