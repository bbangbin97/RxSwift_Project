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
import SwiftyJSON
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    let DEMO_URL = "https://picsum.photos/1024/768/?random"
    let subject = PublishSubject<Int>()
    let timer = Observable<Int>.interval(4.0, scheduler: MainScheduler.instance)
    
    var status : Bool?
    var pause : Bool?
    var disposeBag = DisposeBag()
    var timerDisposable : Disposable?
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let pauser = Observable.of(pauseButton.rx.tap.asObservable(), playButton.rx.tap.asObservable()).merge()
        
        //        timer.pausable(pauser)
        //        pause = false
        
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
            timerDisposable = timer
                //.skipUntil(playButton.rx.tap.asObservable())
                .bind(onNext : { _ in
                    print("timer interrupt")
                    self.LoadImageView()
                })
        }
        //        if (status == true && pause == true){
        //            pause = false
        //            //resume logic
        //        }
        //
    }
    
    func StopButton() -> Void {
        if (status == false){
            status = true
            timerDisposable?.dispose()
        }
    }
    
    
    
    func LoadImageView() -> Void{
        let baseUrl = "https://picsum.photos/1024/768/?random"
        Observable.just(baseUrl)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ URL(string: $0) }
            .filter{ $0 != nil }
            .map{ $0! }
            .map{ try Data(contentsOf: $0) }
            .observeOn(MainScheduler.instance)
            .bind(onNext : {
                self.imageView.image = UIImage( data : $0 )
            })
            .disposed(by: disposeBag)
    }
    
    
    
    
   
    
}


