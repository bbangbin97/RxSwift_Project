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

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    let DEMO_URL = "https://picsum.photos/1920/1080/?random"
    let timer = Observable<Int>.interval(4.0, scheduler: MainScheduler.instance)
    
    var status : Bool?
    var pause : Bool?
    var disposeBag = DisposeBag()
    var timerDisposable : Disposable?
    var counter: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiController.GetImageInfo()
        
//        let pauser = Observable.of(pauseButton.rx.tap.asObservable())
//
//        timer.pausable(pauser)
//        pause = false
//
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
        let baseUrl = "https://picsum.photos/1920/1080/?random"
        Observable.just(baseUrl)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ URL( string: $0 ) }
            .filter{ $0 != nil }
            .map{ $0! }
            .map{ try Data( contentsOf: $0 ) }
            .observeOn(MainScheduler.instance)
            .bind(onNext : {
                self.imageView.image = UIImage( data : $0 )
            })
            .disposed(by: disposeBag)
    }
    
    
    //    func GetImageInfo() -> Void {
    //        Observable.create({ observer -> Disposable in
    //            AF.request(APIRouter.getImageInfo)
    //                .responseJSON { response in
    //                    switch response.result {
    //                    case .success:
    //                        print()
    //                        guard let data = response.data else {
    //                            observer.onError(response.error ?? nil)
    //                        }
    //                    case .failure( let error ):
    //                        print("fail")
    //                    }
    //            }
    //            return Disposables.create()
    //        })
    //    }
    //
    
    
}


