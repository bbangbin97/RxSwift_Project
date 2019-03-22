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

Observable.from([1,2,3])
    .map { [$0 * 1, $0 * 2] }
    .subscribe(onNext : {
        print($0)
    })
// === result ===
// 10 20 30 40 50 60


let fruits = Observable<String>.create{ observer in
    observer.onNext("[apple]")
    sleep(2)
    observer.onNext("[apple]")
    sleep(2)
    observer.onNext("[apple]")
    return Disposables.create()
}


func printType<T>(Type : T.Type) -> Void {
    print("\(Type)")
}

printType(Type: Int.self)


let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject
.takeUntil(trigger)
    .subscribe(onNext : {
        print($0)
    })

subject.onNext("1")
subject.onNext("2")

trigger.onNext("X")
subject.onNext("3")

// 결과
// 1, 2
//
