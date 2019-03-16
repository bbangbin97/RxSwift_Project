import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

Observable.of(2,2,4,4,6,6)
    .enumerated()
    .takeWhile{ index, integer in
        integer % 2 == 0 && index < 3
    }
    .subscribe(onNext : {
        print($0)
    })
// -- 결과 출력 --
// 2 2 4
