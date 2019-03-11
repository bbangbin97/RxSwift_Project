//
//  APIController.swift
//  Install Rx
//
//  Created by 정영빈 on 11/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

private let apiKey = "83e38d8bf2973dec25889662e19dfd09"

struct photosDetail {
    let id : String
    let owner : String
    let seceret : String
    let server : String
    let farm : Int
    let title : String
    let ispublic : Int
    let isfriend : Int
    let isfamily : Int
}

struct photos {
    let page : Int
    let pages : Int
    let perpage : Int
    let total : Int
    let photo : [photosDetail]
}
