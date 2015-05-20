//
//  ViewController.swift
//  state
//
//  Created by Hao Lian on 5/20/15.
//  Copyright (c) 2015 Trello, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    dynamic var transition : UInt = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        RACSignal.interval(5, onScheduler: RACScheduler.mainThreadScheduler()).subscribeNext {
            (x : AnyObject!) -> Void in
            self.transition += 1
        }

        var ugh : AnyObject? = nil

        self.rac_valuesForKeyPath("transition", observer: self).subscribeOn(RACScheduler.immediateScheduler()).map {
            (x : AnyObject!) -> AnyObject! in

            return RACSignal.createSignal({
                (subscriber: RACSubscriber!) -> RACDisposable! in

                println("\(x) beginning")

                return RACDisposable(block: { () -> Void in
                    println("\(x) gone")
                })
            })
        }.switchToLatest().subscribeNext {
            (x: AnyObject!) -> Void in
            println("got something: \(x)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

