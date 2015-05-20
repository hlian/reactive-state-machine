Q: What's the idiomatic way implement a state machine with ReactiveCocoa?

For synchronous state transitions, this is fairly easy. You have a block of code

```objc
- (void)didTransitionFromFooToBar {
  ...
}
```

you want to call. You enumerate your transitions and subscribe to `RACObserve(self, transition)`; on next, you call the appropriate function.

But what if you have something to dispose of? Let's say the transition from foo to bar creates an `NSOperation` we'd like to cancel.

The block could return a disposable:

```objc
- (RACDisposable *)didTransitionFromFooToBar {
  ...
}
```

And now you `map` to the disposable and `combinePreviousWithStart:reduce:` to dispose:

```objc
__block RACDisposable *capture;
[[RACObserve(self, transition) map:^...] combinePreviousWithStart:nil reduce:^(RACDisposable *previous, RACDisposable *current) {
  [previous dispose];
  capture = current;
}]
```

(You could even take advantage of RACDisposable's diposal-on-`dealloc` if you didn't want to combine with previous and didn't mind relying on ARC.)

But is there a way to do this that feels more idiomatic? Something by creating signals with attached disposables? Something that sort of abuses signals' resource management as a way to demarcate time.

See `ViewController.swift` for a possible solution.
