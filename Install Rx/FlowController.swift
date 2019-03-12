//
//  FlowController.swift
//  Install Rx
//
//  Created by 정영빈 on 13/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation

class FlowController {
    static func stopTask(){
        ApiController.timerDisposable?.dispose()
        print("Stop Task button")
    }
    
    static func playTask(){
        print("play Task button")
    }
    
    static func pauseTask(){
        print("pause Task button")
    }
}
