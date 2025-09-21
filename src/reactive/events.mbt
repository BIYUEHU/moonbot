///|
pub struct Events[N, T] {
  mut count : Int
  listeners : Map[N, Map[Int, (T) -> Unit]]
  middlewares : Map[Int, (N, T, () -> Unit) -> Unit]
}

///|
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
pub fn[N : Eq + Hash, T] Events::new() -> Events[N, T] {
  { count: 0, listeners: {}, middlewares: {} }
}

///|
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
pub fn[N : Eq + Hash, T] Events::once(
  self : Events[N, T],
  event : N,
  listener : (T) -> Unit,
) -> () -> Unit {
  self.on(event, listener, once=true)
}

///|
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
}

///|
pub fn[N, T] Events::emitAll(self : Events[N, T], data : T) -> Unit {
  self.listeners.each((event, listeners) => self.exec(event, data, () => listeners
    .values()
    .each(listener => data |> listener)))
}

///|
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
pub fn[N, T] Events::check(self : Events[N, T], event : N, data : T) -> Bool {
  let mut pass = false
  self.exec(event, data, () => pass = true)
  pass
}
