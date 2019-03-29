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
    
    var count = 0
    
    private var flickrViewModel : FlickrViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        
        flickrViewModel = FlickrViewModel(flickrAPIService: FlickrAPIService())
        bindUI(viewModel: flickrViewModel)
        
    }
    
    
    func bindUI(viewModel : FlickrViewModel) {
        _ = viewModel.imageData
            .map(UIImage.init)
            .observeOn(MainScheduler.instance)
            .bind(animated: imageView.rx.animated.fade(duration: 0.5).image)
    }

    @objc func timerCallback() {
        count += 1
        countLabel.text = "\(count)"
    }

}

