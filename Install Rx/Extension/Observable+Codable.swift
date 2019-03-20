//
//  RxAlamofire+Codable.swift
//  Install Rx
//
//  Created by 정영빈 on 20/03/2019.
//  Copyright © 2019 정영빈. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    
    public func mapCodableObject<T: Codable>(type: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let responseTuple = data as? (HTTPURLResponse, Data)
            
            guard let jsonData = responseTuple?.1 else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
                )
            }
            
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: jsonData)
            
            return Observable.just(object)
        }
    }
    
}
