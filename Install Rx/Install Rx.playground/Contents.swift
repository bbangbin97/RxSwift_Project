import UIKit
import RxSwift

let disposeBag = DisposeBag()

Observable.of(["🐶", "🐱", "🐭", "🐹"])
    .subscribe{ event in
        print(event)
    }
    .disposed(by: disposeBag)

