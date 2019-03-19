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
    
    static let timer = Observable<Int>.interval(4.0, scheduler: MainScheduler.instance)
    
    var imageUrlSubject = PublishSubject<String>()
    
    var status : Bool?
    var pause : Bool?
    var disposeBag = DisposeBag()
    var timerDisposable : Disposable?
    var counter: Int = 0
    
    var cnt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiController.GetImageInfo()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
        
        status = true
        
        playButton.rx.tap
            .bind(onNext : {
                print("play button")
                self.PlayButton()
            })
            .disposed(by: disposeBag)
        stopButton.rx.tap
            .bind(onNext: {
                print("stop button")
                self.StopButton()
            })
            .disposed(by: disposeBag)
        pauseButton.rx.tap
            .bind(onNext : {
                print("pause button")
                //                self.pause = true
            }).disposed(by: disposeBag)
        
        
    }
    
    func PlayButton() -> Void {
        if (status == true){
            status = false
            timerDisposable = ViewController.timer
                //.skipUntil(playButton.rx.tap.asObservable())
                .bind(onNext : { _ in
                    self.LoadImageView( Url : ApiController.items[self.cnt].media.m)
                    self.cnt = self.cnt + 1
                })
        }
    }
    
    func StopButton() -> Void {
        if (status == false){
            status = true
            timerDisposable?.dispose()
        }
    }
    
    
    
    func LoadImageView(Url : String?) -> Void{
        _ = Observable.from(optional: Url)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ URL( string: $0 ) }
            .filter{ $0 != nil }
            .map{ $0! }
            .map{ try Data( contentsOf: $0 ) }
            .observeOn(MainScheduler.instance)
            .subscribe({ response in
                //self.imageView.image = UIImage( data : $0 )
                if let imageData = response.element {
                    UIView.transition(with: self.imageSuperView,
                                      duration: 1,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.imageView.image = UIImage(data : imageData)
                    },
                                      completion: nil)
                }
            })
    }
    
    
    
}


