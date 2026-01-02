# himeno/reactive

## Overview

`himeno/reactive` is a reactive programming library that provides tools for handling signals, event emitters, and streams with observers. It facilitates the creation of applications that react to changes in data or events.

---

## Usage

### Signals

Signals are used to track changes in a value. When the value changes, all dependent components are automatically updated.

**Creating Signals:**

```mbt
let condition = state(true)
let count = state(1)
```

**Accessing Signal Values:**

```mbt
let value = condition.get()
```

**Setting Signal Values:**

```mbt
count.set(10)
```

**Listening to Signal Changes:**

```mbt
let off_condition = effect(() => println("Condition changed: \{condition.get()}"))
condition.set(false)
off_condition()
```

### Computed Values

Computed values are derived from other signals or state. They automatically update when their dependencies change.

**Creating Computed Values:**

```mbt
let result = computed(() => {
  if condition.get() {
    a.get() * 2
  } else {
    b.get() * 3
  }
})
```

**Accessing Computed Values:**

```mbt
let value = result.get()
```

**Listening to Computed Value Changes:**

```mbt
let off_result = result.on(value => println("Result changed: \{value}"))
off_result()
```

### Effects

Effects are used to perform side effects in response to changes in signals or computed values.

**Creating Effects:**

```mbt
effect(() => println("Condition changed: \{condition.get()}"))
```

### Streams

Streams are used to handle sequences of data that arrive over time. The `Observable` and `Observer` components are central to managing streams.

**Creating Observables:**

```mbt
let my_observable = Observable::new(observer => {
  observer.next(10)
  ()
})
```

**Subscribing to Observables:**

```mbt
let my_subscription = my_observable.on_from_next(value => println("Received value: \{value}"))
my_subscription.off()
```

**Creating Subjects:**

Subjects allow you to manually control the emission of data to subscribers.

```mbt
let my_subject = Subject::new(observer => {
  observer.next(5)
  ()
})
```

**Emitting Data to Subjects:**

```mbt
my_subject.next(10)
my_subject.complete()
```

---

### Event Emitters

Event emitters allow components to listen for specific events and react to them. The `Events` struct manages event listeners and middlewares.

**Creating Event Emitters:**

```mbt
let my_events = Events::new()
```

**Emitting Events:**

```mbt
my_events.emit("user.login", { username: "john_doe" })
```

**Listening to Events:**

```mbt
let off_login = my_events.on("user.login", data => println("User logged in: \{data.username}"))
off_login()
```

**One-Time Event Listeners:**

```mbt
my_events.once("user.login", data => println("User logged in once: \{data.username}"))
```
