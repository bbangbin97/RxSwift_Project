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
    @IBOutlet weak var imageIntervalSlider: UISlider!
    @IBOutlet weak var currentIntervalLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var count = 0
    var uiDisposeBag = DisposeBag()
    
    private var flickrViewModel : FlickrViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        flickrViewModel = FlickrViewModel(flickrAPIService: FlickrAPIService(),
                                          playButton: playButton.rx.tap.asObservable(),
                                          pauseButton: pauseButton.rx.tap.asObservable(),
                                          stopButton: stopButton.rx.tap.asObservable(),
                                          imageIntervalSlider: imageIntervalSlider.rx.value.asObservable())
        
        _ = stopButton.rx.tap.subscribe(onNext:{
            self.uiDisposeBag = DisposeBag()
            self.imageView.image = nil
        })
        
        _ = playButton.rx.tap.subscribe(onNext:{
            // button pushed only one time
            self.bindUI(viewModel: self.flickrViewModel)
        })
        
    }
    
    
    func bindUI(viewModel : FlickrViewModel) {
        
        viewModel.imageData
            .map(UIImage.init)
            .bind(animated: imageView.rx.animated.fade(duration: 0.3).image)
            .disposed(by: uiDisposeBag)
        
        imageIntervalSlider.rx.value
            .subscribe(onNext: {
                self.imageIntervalSlider.setValue( round( $0 * 10 )/10 , animated: false)
            })
            .disposed(by: uiDisposeBag)
        
        viewModel.intervalValue
            .map{"현재 슬라이더 값 : \($0)"}
            .bind(to: currentIntervalLabel.rx.text)
            .disposed(by: uiDisposeBag)
        
        viewModel.timerWithSlider
            .map{ "\($0)번째 사진" }
            .bind(to: countLabel.rx.text)
            .disposed(by: uiDisposeBag)
        
    }
    
    @objc func timerCallback() {
        count += 1
        timerLabel.text = "\(count)"
    }
    
}

