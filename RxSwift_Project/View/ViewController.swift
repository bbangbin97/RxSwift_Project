//
//  ViewController.swift
//  Install Rx
//
//  Created by 정영빈 on 04/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import RxAlamofire
import RxAnimated

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageSuperView: UIView!
    @IBOutlet weak var imageIntervalSlider: UISlider!
    
    
    var imageUrlSubject = BehaviorSubject<Double>(value: 6)
    
    var buttonStatus : Bool?
    var pause : Bool?
    var disposeBag = DisposeBag()
    var timerDisposable : Disposable?
    var subjectDisposable : Disposable?
    var cnt = 0
    var sliderValue : Double?
    
    var imageAnimateDuration : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageAnimateDuration = 1
        buttonStatus = true
        
        FlickrViewModel.getImageInfo()
        bindUI()
        
    }
    
    
    func bindUI() {
        
        imageIntervalSlider.rx.value
            .throttle(1, scheduler: MainScheduler.instance)
            .bind(onNext : { sliderValue in
                self.sliderValue = Double( sliderValue * 10 + 1 )
                self.imageUrlSubject.onNext(self.sliderValue!)
            })
            .disposed(by: disposeBag)
        
        playButton.rx.tap
            .takeWhile{self.buttonStatus == true}
            .bind(onNext : {
                print("play button")
                self.onPlayButtonClicked()
            })
            .disposed(by: disposeBag)
        
        stopButton.rx.tap
            .bind(onNext: {
                print("stop button")
                self.onStopButtonClicked()
            })
            .disposed(by: disposeBag)
        
        let timerValueDriver = imageUrlSubject
            .map{ "current timer duration \( $0 )" }
            .asDriver(onErrorJustReturn: nil)
        
        timerValueDriver
        .drive(countLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    
    func onPlayButtonClicked() -> Void {
        buttonStatus = false
        subjectDisposable = imageUrlSubject.subscribe({ timerValue in
            self.timerDisposable?.dispose()
            self.timerDisposable = Observable<Int>.timer(0, period: timerValue.element! + self.imageAnimateDuration!, scheduler: MainScheduler.instance)
                .map{ _ in self.checkImageCount() }
                .bind(onNext : {
                    print("timer interrupt")
                    self.loadImageView( Url : FlickrViewModel.items[self.cnt].media.m)
                    self.cnt = self.cnt + 1
                })
            
        })
    }
    
    func onStopButtonClicked() -> Void {
        buttonStatus = true
        subjectDisposable?.dispose()
    }
    
    func checkImageCount() {
        if self.cnt >= 20 {
            self.cnt = 0
            FlickrViewModel.getImageInfo()
        }
    }
    
    
    
    func loadImageView(Url : String?) -> Void{
        _ = Observable.from(optional: Url)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ URL( string: $0 ) }
            .filter{ $0 != nil }
            .map{ $0! }
            .map{ try Data( contentsOf: $0 ) }
            .observeOn( MainScheduler.instance )
            .subscribe({ response in
                //self.imageView.image = UIImage( data : $0 )
                if let imageData = response.element {
                    UIView.transition(with: self.imageSuperView,
                                      duration: self.imageAnimateDuration!,
                                      options: .transitionCrossDissolve,
                                      animations: { self.imageView.image = UIImage(data : imageData) },
                                      completion: nil)
                }
            })
    }
    
    
    
}

