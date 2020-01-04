import sets
import tables

type
  ConflictingValueError* = object of Exception

type
  DuplicateKeyError* = object of Exception

proc merge*[A, B](
  first: var Table[A, B],
  second: Table[A, B],
  ignoreDup: bool = true
): void =
  ## Merge `first` and `second` into a single `Table[A, B]`.
  ## Exception will be thrown if there are different values with the same key between the two tables.
  ## If `ignoreDup` is set to `false`, duplicated keys from the two tables will also throw an exception.
  for key in second.keys:
    if first.contains(key):
      if first[key] != second[key]:
        raise newException(
          ConflictingValueError,
          "Value of the same key from one table is different from the other."
        )

      if not ignoreDup:
        raise newException(
          DuplicateKeyError,
          "Unable to join tables with duplicate key."
        )
    else:
      first.add(key, second[key])

proc merge*[T](first: var HashSet[T], second: HashSet[T]): void {.deprecated:
  "`sets` already comes with a function that does the exact same thing.".} =
  ## Use `incl <https://nim-lang.org/docs/sets.html#incl%2CHashSet%5BA%5D%2CHashSet%5BA%5D>`_ instead
  for item in second.items:
    first.incl(item)

proc getResult*[T](input: T, p: proc (x: var T)): T =
  ## Wrapper around in place substituted `input` when its immutable.
  result = input
  p(result)

proc getResult*[T](input: T, arg: T, p: proc (x: var T, y: T)): T =
  ## Wrapper around in place substituted `input` when its immutable.
  result = input
  p(result, arg)

proc getResult*[A, B](input: A, arg: B, p: proc (x: var A, y: B)): A =
  ## Wrapper around in place substituted `input` when its immutable.
  result = input
  p(result, arg)

proc getResult*[T](input: T, p: proc (x: var T, y: varargs[T]), args: varargs[T]): T =
  ## Wrapper around in place substituted `input` when its immutable.
  result = input
  p(result, args)

proc getResult*[A, B](input: A, p: proc (x: var A, y: varargs[B]), args: varargs[B]): A =
  ## Wrapper around in place substituted `input` when its immutable.
  result = input
  p(result, args)
