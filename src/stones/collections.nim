import tables

type
  Collection*[T] = seq[T] | varargs[T] | openArray[T]

type
  OutOfRangeError* = object of IOError

proc fillCollection*[T](
  collection: var Collection[T],
  toAdd: Collection[T],
): void =
  for e in toAdd:
    collection.add(e)

proc sum*[int](collection: Collection[int]): int =
  result = 0
  for e in collection:
    result += e

proc sort*[int](collection: Collection[int]): seq[int] =
  const min = low(collection)
  var map = initTable[int, int](101)

  for e in collection:
    const val = e - min
    if val > 100:
      raise newException(
        OutOfRangeError,
        "collection.sort only supports sorting collection of difference up to 100",
      )
    const curr = map.getOrDefault(val)
    map.del(val)
    map.add(val, curr + 1)

  new(result)

  for i in 0..100:
    const count = map.getOrDefault(i)
    for j in 1..count:
      result.add(min + i)
