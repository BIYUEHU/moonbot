///|
priv enum SignalEvents {
  Trace
  Change
} derive(Eq, Hash)

///|
let signal_events : Events[SignalEvents, Int] = Events::new()

///|
let signal_counter : Counter = Counter::new()

///|
pub struct State[T] {
  priv id : Int
  priv mut val : T
}

///|
pub fn[T] State::new(val : T) -> State[T] {
  { val, id: signal_counter.get() }
}

///|
pub fnalias State::new as state

///|
pub fn[T] State::get(self : State[T]) -> T {
  signal_events.emit(Trace, self.id)
  self.val
}

///|
pub fn[T : Eq] State::set(self : State[T], val : T) -> Unit {
  guard val != self.val
  self.val = val
  signal_events.emit(Change, self.id)
}

///|
pub fn[T] State::on(self : State[T], listener : (T) -> Unit) -> () -> Unit {
  effect(() => listener(self.get()))
}

///|
pub fn[T : Eq] State::update(self : State[T], f : (T) -> T) -> Unit {
  self.set(f(self.get()))
}

///|
pub struct Computed[T] {
  priv callback : () -> T
}

///|
pub fn[T] Computed::new(callback : () -> T) -> Computed[T] {
  { callback, }
}

///|
pub fnalias Computed::new as computed

///|
pub fn[T] Computed::get(self : Computed[T]) -> T {
  (self.callback)()
}

///|
pub fn[T] Computed::on(
  self : Computed[T],
  listener : (T) -> Unit,
) -> () -> Unit {
  effect(() => listener(self.get()))
}

///|
pub fn effect(callback : () -> Unit) -> () -> Unit {
  let dependencies = []
  let off1 = signal_events.on(Trace, id => if !dependencies.contains(id) {
    dependencies.push(id)
  })
  let off2 = signal_events.on(Change, id => if dependencies.contains(id) {
    dependencies.clear()
    callback()
  })
  callback()
  () => {
    off1()
    off2()
  }
}

///|
test "signal" {
  let condition = state(true)
  let a = state(1)
  let b = state(2)
  let result = computed(() => if condition.get() {
    println("used a branch")
    a.get() * 2
  } else {
    println("used b branch")
    b.get() * 3
  })
  effect(() => println("result changed: \{result.get()}")) |> ignore
  condition.set(false)
  a.set(10)
  b.set(20)
  condition.set(true)
}
