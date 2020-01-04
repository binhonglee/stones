import sets, tables, unittest
import genlib

suite "merge[A, B]()":
  const t1: Table[string, string] = {
    "a": "b",
    "b": "c",
    "c": "d",
  }.toTable()

  const t2: Table[string, string] = {
    "z": "y",
    "y": "x",
    "x": "w",
  }.toTable()

  test "Merge with no conflict":
    var temp = t1
    temp.merge(t2)

    for k in t1.keys:
      check temp.hasKey(k)
      check temp[k] == t1[k]

    for k in t2.keys:
      check temp.hasKey(k)
      check temp[k] == t2[k]

    var temp2 = t2
    temp2.merge(t1)

    for k in t1.keys:
      check temp2.hasKey(k)
      check temp2[k] == t1[k]

    for k in t2.keys:
      check temp2.hasKey(k)
      check temp2[k] == t2[k]

    check temp.len() == temp2.len()
    check temp == temp2

  test "Merge conflict without ignoreDup":
    var temp1 = t1
    temp1.add("z", "y")
    expect(DuplicateKeyError):
      temp1.merge(t2, false)

    var temp2 = t1
    temp2.add("y", "a")
    expect(ConflictingValueError):
      temp2.merge(t2, false)

  test "Merge conflict with ignoreDup":
    var temp1 = t1
    temp1.add("z", "y")
    temp1.merge(t2, true)

    var temp2 = t1
    temp2.add("y", "a")
    expect(ConflictingValueError):
      temp2.merge(t2, true)

suite "merge[T]()":
  const s1: HashSet[string] = toHashSet(["a", "b"])
  const s2: HashSet[string] = toHashSet(["c", "d"])

  test "Merge with no conflict":
    var temp1 = s1
    temp1.merge(s2)

    for it in s1.items:
      check temp1.contains(it)

    for it in s2.items:
      check temp1.contains(it)

  test "Merge with conflict":
    var temp1 = s1
    temp1.incl("c")
    temp1.merge(s2)

    for it in s1.items:
      check temp1.contains(it)

    for it in s2.items:
      check temp1.contains(it)
