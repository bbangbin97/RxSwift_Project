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
import Alamofire

class ApiController {
    
    struct photosDetail : Codable{
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
    
    struct photos : Codable{
        let page : Int
        let pages : Int
        let perpage : Int
        let total : Int
        let photo : [photosDetail]
    }
    
    
    static let baseUrl = "http://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=1fbe3608e90dc6426aa75c5170209192&format=json"
    
    
    static var timerDisposable : Disposable?
    
    

    
}
