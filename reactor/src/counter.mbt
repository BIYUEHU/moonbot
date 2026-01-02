///|
pub struct Counter {
  priv mut val : Int
}

///|
/// Create a new counter with a value of 0.
pub fn Counter::new() -> Counter {
  { val: 0 }
}

///|
/// Create a new counter with a specific value.
pub fn Counter::since(val : Int) -> Counter {
  { val, }
}

///|
/// Reset the counter to 0.
pub fn Counter::reset(self : Counter) -> Counter {
  self.val = 0
  self
}

///|
/// Set the counter to a specific value.
pub fn Counter::set(self : Counter, val : Int) -> Counter {
  self.val = val
  self
}

///|
/// Get the current value of the counter and increment it by 1.
fn Counter::get(self : Counter) -> Int {
  let { val } = self
  self.val += 1
  val
}
