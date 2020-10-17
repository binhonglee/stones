import random, unittest
import rand, sq

const randLength: int = 10

suite "int stack":
  let firstVal: int = rand(randLength)
  let secondVal: int = rand(randLength)
  var stack: Stack[int] = initStack[int]()

  test "empty stack":
    check isNil(stack.peek())
    check stack.len() == 0

  test "add element":
    stack.add(firstVal)
    check stack.peek().value == firstVal
    check stack.len() == 1

  test "add another element":
    stack.add(secondVal)
    check stack.peek().value == secondVal
    check stack.len() == 2

  test "pop elements":
    check stack.len() == 2
    check stack.pop().value == secondVal
    check stack.len() == 1
    check stack.pop().value == firstVal
    check stack.len() == 0
    check isNil(stack.peek())

suite "string stack":
  let firstVal: string = randString(randLength)
  let secondVal: string = randString(randLength)
  var stack: Stack[string] = initStack[string]()

  test "empty stack":
    check isNil(stack.peek())
    check stack.len() == 0

  test "add element":
    stack.add(firstVal)
    check stack.peek().value == firstVal
    check stack.len() == 1

  test "add another element":
    stack.add(secondVal)
    check stack.peek().value == secondVal
    check stack.len() == 2

  test "pop elements":
    check stack.len() == 2
    check stack.pop().value == secondVal
    check stack.len() == 1
    check stack.pop().value == firstVal
    check stack.len() == 0
    check isNil(stack.peek())

suite "int queue":
  let firstVal: int = rand(randLength)
  let secondVal: int = rand(randLength)
  var queue: Queue[int] = initQueue[int]()

  test "empty queue":
    check isNil(queue.peek())
    check queue.len() == 0

  test "add element":
    queue.add(firstVal)
    check queue.peek().value == firstVal
    check queue.len() == 1

  test "add another element":
    queue.add(secondVal)
    check queue.peek().value == firstVal
    check queue.len() == 2

  test "pop elements":
    check queue.len() == 2
    check queue.pop().value == firstVal
    check queue.len() == 1
    check queue.pop().value == secondVal
    check queue.len() == 0
    check isNil(queue.peek())

suite "string queue":
  let firstVal: string = randString(randLength)
  let secondVal: string = randString(randLength)
  var queue: Queue[string] = initQueue[string]()

  test "empty queue":
    check isNil(queue.peek())
    check queue.len() == 0

  test "add element":
    queue.add(firstVal)
    check queue.peek().value == firstVal
    check queue.len() == 1

  test "add another element":
    queue.add(secondVal)
    check queue.peek().value == firstVal
    check queue.len() == 2

  test "pop elements":
    check queue.len() == 2
    check queue.pop().value == firstVal
    check queue.len() == 1
    check queue.pop().value == secondVal
    check queue.len() == 0
    check isNil(queue.peek())
