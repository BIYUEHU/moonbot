///|
let stream_counter : Counter = Counter::new()

///|
pub struct Observable[T, E] {
  priv onFn : (Observer[T, E]) -> () -> Unit
}

///|
/// Creates a new observable with the given `onFn` function.
pub fn[T, E] Observable::new(
  onFn : (Observer[T, E]) -> () -> Unit,
) -> Observable[T, E] {
  { onFn, }
}

///|
/// Subscribes to the observable with the given `observer` and returns a
pub fn[T, E] Observable::on(
  self : Observable[T, E],
  observer : Observer[T, E],
) -> Subscription {
  let subscription = Subscription::new()
  let wrapped_observer = Observer::new(
    next=val => {
      guard !subscription.is_closed() && observer.next is Some(next)
      next(val)
    },
    error=err => {
      guard !subscription.is_closed() && observer.error is Some(error)
      error(err)
      subscription.off()
    },
    complete=() => {
      guard !subscription.is_closed() && observer.complete is Some(complete)
      complete()
      subscription.off()
    },
  )
  subscription.add_from_func((self.onFn)(wrapped_observer))
  subscription
}

///|
/// Converts the observable to an observer and subscribes to it with the given
pub fn[T, E] Observable::on_from_next(
  self : Observable[T, E],
  next : (T) -> Unit,
) -> Subscription {
  self.on(Observer::new(next~))
}

///|
pub struct Observer[T, E] {
  priv id : Int
  next : ((T) -> Unit)?
  error : ((E) -> Unit)?
  complete : (() -> Unit)?
}

///|
/// Creates a new observer with the given `next`, `error`, and `complete`
pub fn[T, E] Observer::new(
  next? : (T) -> Unit,
  error? : (E) -> Unit,
  complete? : () -> Unit,
) -> Observer[T, E] {
  { id: stream_counter.get(), next, error, complete }
}

///|
pub struct Subscription {
  priv id : Int
  priv mut closed : Bool
  priv offs : Array[(Int, () -> Unit)]
}

///|
/// Creates a new subscription with the given `off` function.
pub fn Subscription::new(off? : () -> Unit) -> Subscription {
  if off is Some(off) {
    let id = stream_counter.get()
    { id, closed: false, offs: [(id, off)] }
  } else {
    { id: 0, closed: true, offs: [] }
  }
}

///|
/// Unsubscribes the observer from the subscription.
pub fn Subscription::off(self : Subscription) -> Unit {
  guard !self.closed
  self.closed = true
  self.offs.each(off => (off.1)())
}

///|
/// Returns `true` if the subscription is closed, `false` otherwise.
pub fn Subscription::is_closed(self : Subscription) -> Bool {
  self.closed
}

///|
/// Adds the given `subscription` to the list of subscriptions.
pub fn Subscription::add(
  self : Subscription,
  subscription : Subscription,
) -> Unit {
  guard !self.closed
  self.offs.push((subscription.id, () => subscription.off()))
}

///|
/// Adds the given `off` function to the list of subscriptions.
pub fn Subscription::add_from_func(
  self : Subscription,
  off : () -> Unit,
) -> Unit {
  guard !self.closed
  self.offs.push((stream_counter.get(), off))
}

///|
/// Removes the given `subscription` from the list of subscriptions.
pub fn Subscription::remove(
  self : Subscription,
  subscription : Subscription,
) -> Unit {
  guard !self.closed
  self.offs.retain(off => off.0 != subscription.id)
}

///|
pub struct Subject[T, E] {
  priv observable : Observable[T, E]
  priv observers : Array[Observer[T, E]]
  priv mut closed : Bool
  priv mut stopped : Bool
  priv mut error : E?
}

///|
/// Creates a new subject with the given `onFn` function.
pub fn[T, E] Subject::new(
  onFn : (Observer[T, E]) -> () -> Unit,
) -> Subject[T, E] {
  {
    observable: Observable::new(onFn),
    observers: [],
    closed: false,
    stopped: false,
    error: None,
  }
}

///|
/// Converts the subject to an observable and returns it.
pub fn[T, E] Subject::as_observable(self : Subject[T, E]) -> Observable[T, E] {
  Observable::new(observer => () => self.on(observer).off())
}

///|
/// Returns `true` if the subject is closed, `false` otherwise.
pub fn[T, E] Subject::is_closed(self : Subject[T, E]) -> Bool {
  self.closed
}

///|
/// Returns `true` if the subject is stopped, `false` otherwise.
pub fn[T, E] Subject::is_stopped(self : Subject[T, E]) -> Bool {
  self.stopped
}

///|
/// Returns `true` if the subject has an error, `false` otherwise.
pub fn[T, E] Subject::has_error(self : Subject[T, E]) -> Bool {
  self.error is Some(_)
}

///|
/// Returns the error of the subject, if any.
pub fn[T, E] Subject::get_error(self : Subject[T, E]) -> E? {
  self.error
}

///|
/// Returns the number of observers of the subject.
pub fn[T, E] Subject::observers_count(self : Subject[T, E]) -> Int {
  self.observers.length()
}

///|
/// Subscribes to the subject with the given `observer` and returns a
pub fn[T, E] Subject::on(
  self : Subject[T, E],
  observer : Observer[T, E],
) -> Subscription {
  if self.closed {
    if observer.complete is Some(complete) {
      complete()
    }
    Subscription::new()
  } else if self.stopped {
    if self.error is Some(err) {
      guard observer.error is Some(error)
      error(err)
    } else {
      guard observer.complete is Some(complete)
      complete()
    }
    Subscription::new()
  } else {
    let subscription = self.observable.on(observer)
    if observer.next is Some(_) ||
      observer.error is Some(_) ||
      observer.complete is Some(_) {
      self.observers.push(observer)
      subscription.add_from_func(() => self.observers.retain(obs => obs.id !=
        observer.id))
    }
    subscription
  }
}

///|
/// Converts the subject to an observable and subscribes to it with the given
pub fn[T, E] Subject::on_from_next(
  self : Subject[T, E],
  next : (T) -> Unit,
) -> Subscription {
  self.on(Observer::new(next~))
}

///|
/// Closes the subject and unsubscribes all observers.
pub fn[T, E] Subject::close(self : Subject[T, E]) -> Unit {
  guard !self.closed
  self.closed = true
  self.observers.clear()
}

///|
/// Nexts the subject with the given `value`.
pub fn[T, E] Subject::next(self : Subject[T, E], value : T) -> Unit {
  guard !self.stopped
  self.observers.each(observer => {
    guard observer.next is Some(next)
    next(value)
  })
}

///|
/// Errors the subject with the given `error`.
pub fn[T, E] Subject::error(self : Subject[T, E], error : E) -> Unit {
  guard !self.stopped
  self.error = Some(error)
  self.stopped = true
  self.observers.each(observer => {
    guard observer.error is Some(err)
    err(error)
  })
  self.observers.clear()
}

///|
/// Completes the subject.
pub fn[T, E] Subject::complete(self : Subject[T, E]) -> Unit {
  guard !self.stopped
  self.stopped = true
  self.observers.each(observer => {
    guard observer.complete is Some(complete)
    complete()
  })
  self.observers.clear()
}
