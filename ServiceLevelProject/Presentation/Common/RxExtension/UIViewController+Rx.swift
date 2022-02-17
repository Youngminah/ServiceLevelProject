//
//  UIViewController+Rx.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {

  var viewDidLoad: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }

  var viewWillAppear: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
    return ControlEvent(events: source)
  }
  var viewDidAppear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }

  var viewWillDisappear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
  var viewDidDisappear: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { _ in () }
    return ControlEvent(events: source)
  }

  var viewWillLayoutSubviews: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
    return ControlEvent(events: source)
  }
  var viewDidLayoutSubviews: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
    return ControlEvent(events: source)
  }

  var viewWillTransition: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillTransition)).map { _ in }
    return ControlEvent(events: source)
  }

  var willMoveToParentViewController: ControlEvent<UIViewController?> {
    let source = self.methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
    return ControlEvent(events: source)
  }
  var didMoveToParentViewController: ControlEvent<UIViewController?> {
    let source = self.methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
    return ControlEvent(events: source)
  }

  var didReceiveMemoryWarning: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
    return ControlEvent(events: source)
  }

  var isVisible: Observable<Bool> {
    let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
    let viewWillDisappearObservable = self.base.rx.viewWillDisappear.map { _ in false }
    return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
  }

  var isDismissing: ControlEvent<Bool> {
    let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
}
