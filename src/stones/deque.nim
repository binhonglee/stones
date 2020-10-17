import lists
import collections

## The underlying differences between this and the official implementation
## `here <https://nim-lang.org/docs/deques.html>`_ is that this is implemented
## using a `DoublyLinkedList` instead of a `seq`

type
  Deque*[T] = ref object
    dll: DoublyLinkedList[T]
    size: int

proc initDeque*[T](): Deque[T] =
  new(result)
  result.size = 0

proc initDeque*[T](collection: Collection[T]): Deque[T] =
  new(result)
  result.size = 0
  for e in collection:
    result.addRear(e)

proc addFront*[T](deque: var Deque[T], node: DoublyLinkedNode[T]) =
  deque.dll.prepend(node)
  inc(deque.size)

proc addFront*[T](deque: var Deque[T], value: T) =
  deque.addFront(newDoublyLinkedNode(value))

proc addRear*[T](deque: var Deque[T], node: DoublyLinkedNode[T]) =
  deque.dll.append(node)
  inc(deque.size)

proc addRear*[T](deque: var Deque[T], value: T) =
  deque.addRear(newDoublyLinkedNode(value))

proc peekFront*[T](deque: var Deque[T]): <//>(DoublyLinkedNode[T]) =
  result = deque.dll.head

proc peekRear*[T](deque: var Deque[T]): <//>(DoublyLinkedNode[T]) =
  result = deque.dll.tail

proc popFront*[T](deque: var Deque[T]): <//>(DoublyLinkedNode[T]) =
  result = deque.peekFront()
  if deque.size > 0:
    deque.dll.remove(deque.dll.head)
    dec(deque.size)

proc popRear*[T](deque: var Deque[T]): <//>(DoublyLinkedNode[T]) =
  result = deque.peekRear()
  if deque.size > 0:
    deque.dll.remove(deque.dll.tail)
    dec(deque.size)

proc len*[T](deque: var Deque[T]): int =
  result = deque.size
