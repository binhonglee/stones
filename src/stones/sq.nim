import lists
import collections

type
  Stack*[T] = ref object
    sll: SinglyLinkedList[T]
    size: int

  Queue*[T] = ref object
    sll: SinglyLinkedList[T]
    size: int

  SomeList[T] = Stack[T] | Queue[T]

proc fillSomeList[T](sq: var SomeList[T], collection: Collection[T]): void =
  for e in collection:
    sq.add(e)

proc initStack*[T](): Stack[T] =
  result = Stack[T]()
  result.sll = initSinglyLinkedList[T]()
  result.size = 0

proc initStack*[T](collection: Collection[T]): Stack[T] =
  result = initStack[T]()
  fillSomeList(result, collection)

proc add*[T](stack: var Stack[T], node: SinglyLinkedNode[T]): void =
  stack.sll.prepend(node)
  inc(stack.size)

proc add*[T](stack: var Stack[T], value: T): void =
  stack.add(newSinglyLinkedNode(value))

proc initQueue*[T](): Queue[T] =
  result = Queue[T]()
  result.sll = initSinglyLinkedList[T]()
  result.size = 0

proc initQueue*[T](collection: Collection[T]): Queue[T] =
  result = initQueue[T]()
  fillSomeList(result, collection)

proc add*[T](queue: var Queue[T], node: SinglyLinkedNode[T]): void =
  queue.sll.append(node)
  inc(queue.size)

proc add*[T](queue: var Queue[T], value: T): void =
  queue.add(newSinglyLinkedNode(value))

proc peek*[T](list: var SomeList[T]): <//>(SinglyLinkedNode[T]) =
  result = list.sll.head

proc pop*[T](list: var SomeList[T]): <//>(SinglyLinkedNode[T]) =
  result = peek(list)
  list.sll.head = list.sll.head.next
  dec(list.size)

proc len*[T](list: var SomeList[T]): int =
  result = list.size
