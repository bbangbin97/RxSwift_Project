import UIKit
import RxSwift
import RxCocoa


let disposeBag = DisposeBag()

Observable.of(["🐶", "🐱", "🐭", "🐹"])
    .subscribe{ event in
        print(event)
    }
    .disposed(by: disposeBag)

let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)


observable.bind(onNext : {
    print($0)
})

observable.subscribe(onNext : {
    print($0)
})

