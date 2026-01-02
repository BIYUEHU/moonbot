///|
pub struct Events[N, T] {
  priv mut count : Int
  priv listeners : Map[N, Map[Int, (T) -> Unit]]
  priv middlewares : Map[Int, (N, T, () -> Unit) -> Unit]
}

///|
/// Executes the middlewares and the listeners for the given event and data.
fn[N, T] Events::exec(
  self : Events[N, T],
  event : N,
  data : T,
  executor : () -> Unit,
) -> Unit {
  let mut next = executor
  self.middlewares
  .values()
  .each(middleware => next = () => middleware(event, data, next))
  next()
}

///|
/// Creates a new instance of `Events`.
pub fn[N : Eq + Hash, T] Events::new() -> Events[N, T] {
  { count: 0, listeners: {}, middlewares: {} }
}

///|
/// Registers a listener for the given event.
pub fn[N : Eq + Hash, T] Events::on(
  self : Events[N, T],
  event : N,
  listener : (T) -> Unit,
  once? : Bool,
) -> () -> Unit {
  let map = self.listeners
    .get(event)
    .unwrap_or_else(() => {
      let map = {}
      self.listeners[event] = map
      map
    })
  let { count, .. } = self
  self.count += 1
  let off = () => map.remove(count)
  map[count] = if once == Some(true) {
    data => {
      data |> listener
      off()
    }
  } else {
    listener
  }
  off
}

///|
/// Registers a listener for the given event that will be executed only once.
pub fn[N : Eq + Hash, T] Events::once(
  self : Events[N, T],
  event : N,
  listener : (T) -> Unit,
) -> () -> Unit {
  self.on(event, listener, once=true)
}

///|
/// Emits the given event with the given data.
pub fn[N : Eq + Hash, T] Events::emit(
  self : Events[N, T],
  event : N,
  data : T,
) -> Unit {
  let listeners = self.listeners.get(event)
  guard listeners is Some(listeners)
  self.exec(event, data, () => listeners
    .values()
    .each(listener => data |> listener))
  // self.exec(event, data, () => listeners
  //   .values()
  //   .each(listener => data |> listener))
}

///|
/// Emits the given event with the given data to all listeners.
pub fn[N, T] Events::emitAll(self : Events[N, T], data : T) -> Unit {
  self.listeners.each((event, listeners) => self.exec(event, data, () => listeners
    .values()
    .each(listener => data |> listener)))
}

///|
/// Registers a middleware for the given event.
pub fn[N, T] Events::middleware(
  self : Events[N, T],
  middleware : (N, T, () -> Unit) -> Unit,
) -> () -> Unit {
  let { count, .. } = self
  self.count += 1
  self.middlewares[count] = middleware
  () => self.middlewares.remove(count)
}

///|
/// Checks if the given event has any listeners.
pub fn[N, T] Events::check(self : Events[N, T], event : N, data : T) -> Bool {
  let mut pass = false
  self.exec(event, data, () => pass = true)
  pass
}
