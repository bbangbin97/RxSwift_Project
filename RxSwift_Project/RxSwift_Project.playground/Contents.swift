import UIKit
import RxSwift

let disposable : Disposable?

Observable.from([1,2,3,4,5])
    .subscribe(onNext:{
        print($0)
    })
.dispose()

