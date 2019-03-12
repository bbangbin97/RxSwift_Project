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
    
    
    static let baseUrl = "http://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=83e38d8bf2973dec25889662e19dfd09&format=json"
    
    
    static var timerDisposable : Disposable?
    

    static func loadImage(from imageUrl:String)->UIImage?{
        guard let url = URL(string: imageUrl) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        let image = UIImage(data: data)
        return image
    }

    static func asyncLoadImage(from imageUrl: String, completed: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let image = self.loadImage(from: imageUrl)
            completed(image)
        }
    }
    
}
