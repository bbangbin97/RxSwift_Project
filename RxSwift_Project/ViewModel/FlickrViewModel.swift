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
    
    var imageData : Observable<Data>!
    
    let intervalValue: Observable<Int>
    let timerWithSlider: Observable<Int>
    
    var flickrModel : FlickrModel.FlickrBaseModel!
    
    init(flickrAPIService : FlickrAPIService, playButton : Observable<Void>, pauseButton : Observable<Void>, stopButton : Observable<Void>, imageIntervalSlider : Observable<Float>){
        
        var currentIndex = -1
        var currentPlayStatus = true
        
        let flickrDataTrigger = BehaviorSubject<Bool>(value: true)
        let flickrPuaser = BehaviorSubject<Bool>(value: true)
        
        self.flickrService = flickrAPIService
        
        _ = pauseButton.subscribe(onNext:{
            currentPlayStatus = !currentPlayStatus
            flickrPuaser.onNext(currentPlayStatus)
        })
        
        _ = stopButton.subscribe(onNext:{
            currentIndex = -1
        })
        
        self.intervalValue = imageIntervalSlider
            .throttle(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ Int( round( $0 * 10 ) + 1 ) }
        
        self.timerWithSlider = self.intervalValue
            .map{ Double($0) }
            .flatMapLatest{ Observable<Int>.timer(0, period: Double( $0 ), scheduler: MainScheduler.instance).pausable(flickrPuaser) }
            .map{_ in
                if currentIndex >= 19 {
                    currentIndex = 0
                    flickrDataTrigger.onNext(true)
                } else {
                    currentIndex = currentIndex + 1
                }
                return currentIndex
            }
            .share(replay: 1)
        
        self.imageData = flickrDataTrigger.asObservable()
            .flatMapLatest{ _ in self.flickrService.getFlickrModel() }
            .retry(3)
            .share(replay: 1)
            .map{ self.flickrModel = $0 }
            .flatMapLatest{ self.timerWithSlider }
            .map{ self.flickrModel.items[$0].media.m }
            .flatMapLatest { self.flickrService.loadImageData(url: $0) }
        
    }
    
}
