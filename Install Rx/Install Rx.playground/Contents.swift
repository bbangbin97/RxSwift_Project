import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

//let disposeBag = DisposeBag()
//
//Observable.of(["🐶", "🐱", "🐭", "🐹"])
//    .subscribe{ event in
//        print(event)
//    }
//    .disposed(by: disposeBag)
//
//let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//
//
//observable.bind(onNext : {
//    print($0)
//})
//
//observable.subscribe(onNext : {
//    print($0)
//})



let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)

let trueAtThreeSeconds = Observable<Int>.timer(3, scheduler: MainScheduler.instance).map { _ in true }
let falseAtFiveSeconds = Observable<Int>.timer(5, scheduler: MainScheduler.instance).map { _ in false }
let pauser = Observable.of(trueAtThreeSeconds, falseAtFiveSeconds).merge()

let pausedObservable = observable.pausable(pauser)

let _ = pausedObservable
    .subscribe { print($0) }
