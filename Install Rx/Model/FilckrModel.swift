//
//  ApiModel.swift
//  Install Rx
//
//  Created by 정영빈 on 18/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation

class FlickrModel {
    
    struct flickrModel : Codable {
        let title : String
        let link : String
        let description : String
        let modified : String
        let generator : String
        let items : [flickrItemModel]
    }
    
    struct flickrItemModel : Codable {
        
        let title : String
        let link : String
        let media : flickrMediaModel
        let date_taken : String
        let description : String
        let published : String
        let author : String
        let author_id : String
        let tags : String
        
    }
    
    struct flickrMediaModel : Codable {
        let m : String
    }
    
}
