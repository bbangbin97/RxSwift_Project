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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.rx.tap
            .bind(onNext: {
                FlowController.playTask()
            })
        pauseButton.rx.tap
            .bind(onNext: {
                FlowController.pauseTask()
            })

        stopButton.rx.tap
            .bind(onNext:{
                FlowController.stopTask()
            })
        
        ApiController.init()
        
    }
    
    
}

