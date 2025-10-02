///|
pub struct Counter {
  priv mut val : Int
}

///|
pub fn Counter::new() -> Counter {
  { val: 0 }
}

///|
pub fn Counter::since(val : Int) -> Counter {
  { val, }
}

///|
pub fn Counter::reset(self : Counter) -> Counter {
  self.val = 0
  self
}

///|
pub fn Counter::set(self : Counter, val : Int) -> Counter {
  self.val = val
  self
}

///|
fn Counter::get(self : Counter) -> Int {
  let { val } = self
  self.val += 1
  val
}
