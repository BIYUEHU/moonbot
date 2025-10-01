///|
priv enum SignalEvents {
  Trace
  Change
} derive(Eq, Hash)

///|
let signal_events : Events[SignalEvents, Int] = Events::new()

///|
let signal_id : Ref[Int] = { val: 0 }

///|
fn get_signal_id() -> Int {
  let { val } = signal_id
  signal_id.val += 1
  val
}

///|
pub struct State[T] {
  id : Int
  mut val : T
}

///|
pub fn[T] State::new(val : T) -> State[T] {
  { val, id: get_signal_id() }
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
  signal_events.emit(Change, self.id)
  self.val = val
}

///|
pub struct Computed[T] {
  comp : () -> T
}

///|
pub fn[T] Computed::new(comp : () -> T) -> Computed[T] {
  { comp, }
}

///|
pub fnalias Computed::new as computed

///|
pub fn[T] Computed::get(self : Computed[T]) -> T {
  (self.comp)()
}

///|
pub struct Effect {
  effect : () -> Unit
  dependencies : Array[Int]
}

///|
pub fn Effect::new(effect : () -> Unit) -> Effect {
  let dependencies = []
  let effect = { effect, dependencies }
  let off = signal_events.on(Trace, id => {
    guard dependencies.contains(id)
    dependencies.push(id)
  })
  effect.run()
  off()
  signal_events.on(Change, id => {
    guard dependencies.contains(id)
    effect.run()
  })
  |> ignore
  effect
}

///|
pub fnalias Effect::new as effect

///|
pub fn Effect::run(self : Effect) -> Unit {
  (self.effect)()
}
