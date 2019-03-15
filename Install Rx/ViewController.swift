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
    
    let timer = Observable<Int>.interval(4.0, scheduler: MainScheduler.instance)
    let DEMO_URL = "https://picsum.photos/1024/768/?random"
    let subject = PublishSubject<Int>()
    
    var status : Bool?
    var disposeBag = DisposeBag()
    var timerDisposable : Disposable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status = true
        playButton.rx.tap
            .bind(onNext : {
                print("playbutton")
                self.PlayButton()
            })
            .disposed(by: disposeBag)
        stopButton.rx.tap
            .bind(onNext: {
                print("stopbutton")
                self.StopButton()
            })
            .disposed(by: disposeBag)
        
    }
    
    func PlayButton() -> Void {
        if (status == true ){
            status = false
            timerDisposable = timer
                //.skipUntil(playButton.rx.tap.asObservable())
                .bind(onNext : { _ in
                    print("timer interrupt")
                    self.LoadImageView()
                })
        }
        
    }
    
    func StopButton() -> Void {
        if (status == false){
            status = true
            timerDisposable?.dispose()
        }
    }
    
//    func LoadImageView() -> Void{
//        let baseUrl = "http://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=1fbe3608e90dc6426aa75c5170209192&format=json"
//
//        if let url = URL(string: baseUrl){
//            _ = Observable.just(url)
//                .map{ try Data(contentsOf: $0) }
//                .map{ try JSON(data : $0) }
//                .bind(onNext : { response in
//                    print(response)
//                })
//        }
//    }





    func LoadImageView() -> Void {

        _ = DemoLoadImage(from: DEMO_URL)
            .observeOn(MainScheduler.instance)
            .subscribe({ result in
                switch result {
                case let .next(image):
                    self.imageView.image = image
                case let .error(err):
                    print(err.localizedDescription)
                case .completed:
                    break
                }
            })

    }

    func DemoLoadImage(from imageUrl : String) -> Observable<UIImage?> {
        return Observable.create{ response in
            ApiController.asyncLoadImage(from: imageUrl) { image in
                response.onNext(image)
                response.onCompleted()
            }
            return Disposables.create()
        }
    }

}


