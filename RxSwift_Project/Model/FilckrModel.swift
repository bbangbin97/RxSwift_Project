//
//  ApiModel.swift
//  Install Rx
//
//  Created by 정영빈 on 18/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation

class FlickrModel {
    
    struct FlickrBaseModel : Codable {
        let title : String
        let link : String
        let description : String
        let modified : String
        let generator : String
        let items : [FlickrItemModel]
    }
    
    struct FlickrItemModel : Codable {
        
        let title : String
        let link : String
        let media : FlickrMediaModel
        let date_taken : String
        let description : String
        let published : String
        let author : String
        let author_id : String
        let tags : String
        
    }
    
    struct FlickrMediaModel : Codable {
        let m : String
    }
    
}
