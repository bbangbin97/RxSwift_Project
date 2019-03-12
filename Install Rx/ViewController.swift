//
//  ViewController.swift
//  Install Rx
//
//  Created by 정영빈 on 04/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    var disposeBag = DisposeBag()
    static var timerDisposable : Disposable?
    
    let timer = Observable<Int>.interval(4.0, scheduler: MainScheduler.instance)
    let DEMO_URL = "https://picsum.photos/1024/768/?random"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.rx.tap
            .bind(onNext: {
                FlowController.playTask()
            })
            .disposed(by: disposeBag)
        pauseButton.rx.tap
            .bind(onNext: {
                FlowController.pauseTask()
            })
            .disposed(by: disposeBag)
        stopButton.rx.tap
            .bind(onNext:{
                FlowController.stopTask()
            })
            .disposed(by: disposeBag)
        
        ViewController.timerDisposable = timer.bind(onNext : { _ in
            print("timer interrupt")
            self.LoadImageView()
        })
        
    }
    
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

