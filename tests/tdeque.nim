import random, unittest
import rand, deque

const randLength: int = 10

suite "int deque":
  let firstVal: int = rand(randLength)
  let secondVal: int = rand(randLength)
  let thirdVal: int = rand(randLength)
  let forthVal: int = rand(randLength)

  var deque: Deque[int] = initDeque[int]()

  test "empty deque":
    check isNil(deque.peekFront())
    check isNil(deque.peekRear())
    check deque.len() == 0

  test "add element to front":
    deque.addFront(firstVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1

  test "add another element to front":
    deque.addFront(secondVal)
    check deque.peekFront().value == secondVal
    check deque.peekRear().value == firstVal
    check deque.len() == 2

  test "pop elements from front":
    check deque.len() == 2
    check deque.popFront().value == secondVal
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1
    check deque.popFront().value == firstVal
    check deque.len() == 0
    check isNil(deque.peekFront())
    check isNil(deque.peekRear())

  test "add element to back":
    deque.addRear(firstVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1

  test "add another element to back":
    deque.addRear(secondVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == secondVal
    check deque.len() == 2

  test "pop elements from back":
    check deque.len() == 2
    check deque.popRear().value == secondVal
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1
    check deque.popRear().value == firstVal
    check deque.len() == 0
    check isNil(deque.peekFront())
    check isNil(deque.peekRear())

  test "add and remove element to / from front and back":
    deque.addFront(firstVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1

    deque.addRear(secondVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == secondVal
    check deque.len() == 2

    deque.addFront(thirdVal)
    check deque.peekFront().value == thirdVal
    check deque.peekRear().value == secondVal
    check deque.len() == 3

    deque.addRear(forthVal)
    check deque.peekFront().value == thirdVal
    check deque.peekRear().value == forthVal
    check deque.len() == 4

    check deque.len() == 4
    check deque.popFront().value == thirdVal
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == forthVal
    check deque.len() == 3
    check deque.popRear().value == forthVal
    check deque.len() == 2
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == secondVal

    check deque.len() == 2
    check deque.popRear().value == secondVal
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1
    check deque.popRear().value == firstVal
    check deque.len() == 0
    check isNil(deque.peekFront())
    check isNil(deque.peekRear())

suite "string deque":
  let firstVal: string = randString(randLength)
  let secondVal: string = randString(randLength)
  let thirdVal: string = randString(randLength)
  let forthVal: string = randString(randLength)

  var deque: Deque[string] = initDeque[string]()

  test "empty deque":
    check isNil(deque.peekFront())
    check isNil(deque.peekRear())
    check deque.len() == 0

  test "add element to front":
    deque.addFront(firstVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1

  test "add another element to front":
    deque.addFront(secondVal)
    check deque.peekFront().value == secondVal
    check deque.peekRear().value == firstVal
    check deque.len() == 2

  test "pop elements from front":
    check deque.len() == 2
    check deque.popFront().value == secondVal
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1
    check deque.popFront().value == firstVal
    check deque.len() == 0
    check isNil(deque.peekFront())
    check isNil(deque.peekRear())

  test "add element to back":
    deque.addRear(firstVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1

  test "add another element to back":
    deque.addRear(secondVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == secondVal
    check deque.len() == 2

  test "pop elements from back":
    check deque.len() == 2
    check deque.popRear().value == secondVal
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1
    check deque.popRear().value == firstVal
    check deque.len() == 0
    check isNil(deque.peekFront())
    check isNil(deque.peekRear())

  test "add and remove element to / from front and back":
    deque.addFront(firstVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1

    deque.addRear(secondVal)
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == secondVal
    check deque.len() == 2

    deque.addFront(thirdVal)
    check deque.peekFront().value == thirdVal
    check deque.peekRear().value == secondVal
    check deque.len() == 3

    deque.addRear(forthVal)
    check deque.peekFront().value == thirdVal
    check deque.peekRear().value == forthVal
    check deque.len() == 4

    check deque.len() == 4
    check deque.popFront().value == thirdVal
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == forthVal
    check deque.len() == 3
    check deque.popRear().value == forthVal
    check deque.len() == 2
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == secondVal

    check deque.len() == 2
    check deque.popRear().value == secondVal
    check deque.peekFront().value == firstVal
    check deque.peekRear().value == firstVal
    check deque.len() == 1
    check deque.popRear().value == firstVal
    check deque.len() == 0
    check isNil(deque.peekFront())
    check isNil(deque.peekRear())
