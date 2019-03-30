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
    
    
    var timerValueSubject = BehaviorSubject<Double>(value: 6)
    var pauseSubject = BehaviorSubject<Bool>(value : true)
    
    
    var pauseButtonObservable : Observable<Bool>?
    var pauser : Observable<Bool>?
    var buttonStatus : Bool?
    var pause = false
    var disposeBag = DisposeBag()
    var timerDisposable : Disposable?
    var subjectDisposable : Disposable?
    var imageDataDisposeBag = DisposeBag()
    var cnt = 0
    var sliderValue : Double?
    var imageAnimateDuration : Double?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pause = true
        imageAnimateDuration = 1
        buttonStatus = true
        
        FlickrViewModel.getImageData()
        bindUI()
        
        //pauser = Observable.of(pauseButtonObservable!,pauseSubject).merge()
    }
    
    
    func bindUI() {
        
        imageIntervalSlider.rx.value
            .throttle(1, scheduler: MainScheduler.instance)
            .bind(onNext : { sliderValue in
                self.sliderValue = Double( round( sliderValue * 10 + 1 ) )
                self.imageIntervalSlider.setValue( round( sliderValue * 10 ) / 10 , animated: false)
                self.timerValueSubject.onNext(self.sliderValue!)
            })
            .disposed(by: disposeBag)
        
        playButton.rx.tap
            .takeWhile{ self.buttonStatus == true }
            .bind(onNext : {
                print("play button")
                self.onPlayButtonClicked()
            })
            .disposed(by: disposeBag)
        
        pauseButton.rx.tap
            .bind(onNext:{ _ in
                self.pause = !self.pause
                self.pauseSubject.onNext(self.pause)
            })
            .disposed(by: disposeBag)
        
        
        stopButton.rx.tap
            .bind(onNext: {
                print("stop button")
                self.onStopButtonClicked()
            })
            .disposed(by: disposeBag)
        
        let timerValueDriver = timerValueSubject
            .map{ "current timer duration \( $0 )" }
            .asDriver(onErrorJustReturn: nil)
        
        timerValueDriver
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    func onPlayButtonClicked() -> Void {
        buttonStatus = false
        subjectDisposable = timerValueSubject.subscribe(onNext:{ timerValue in
            self.timerDisposable?.dispose()
            self.timerDisposable = Observable<Int>.timer(0, period: timerValue + self.imageAnimateDuration!,
                                                         scheduler: MainScheduler.instance)
                .pausable(self.pauseSubject.asObservable())
                .map{ _ in self.checkImageCount() }
                .subscribe(onNext : {
                    print("timer interrupt")
                    self.loadImageView( url : FlickrViewModel.items[self.cnt].media.m)
                    self.cnt = self.cnt + 1
                })
        },onDisposed:{
            self.timerDisposable?.dispose()
        })
    }
    
    func onStopButtonClicked() -> Void {
        buttonStatus = true
        subjectDisposable!.dispose()
    }
    
    func checkImageCount() {
        if self.cnt >= 20 {
            self.cnt = 0
            FlickrViewModel.getImageData()
        }
    }
    
    
    
    func loadImageView(url : String?) -> Void{
        FlickrViewModel.loadImageData(url: url!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { response in
                UIView.transition(with: self.imageSuperView,
                                  duration: self.imageAnimateDuration!,
                                  options: .transitionCrossDissolve,
                                  animations: { self.imageView.image = UIImage(data : response) },
                                  completion: nil)
            })
            .disposed(by: imageDataDisposeBag)
    }
    
}

