import sets, tables, unittest
import strlib
from sequtils import toSeq

suite "count()":
  test "multi-char":
    const st: HashSet[char] = toHashSet(['a', 'b'])
    const s: string = "abfsagahbajbkadbab"
    const tb: Table[char, int] = {
      'a': 6,
      'b': 5,
    }.toTable()

    check count(s, st) == tb

  test "no char":
    const st: HashSet[char] = toHashSet(['a', 'b'])
    const s: string = "vndijefweldgjwpoedkd"
    const tb: Table[char, int] = initTable[char, int]()

    check count(s, st) == tb

  test "some char":
    const st: HashSet[char] = toHashSet(['a', 'b'])
    const s: string = "ahjhjaajkak"
    const tb: Table[char, int] = {
      'a': 4,
    }.toTable()

    check count(s, st) == tb

suite "parseInt(char)":
  test "actual int":
    for i in 0..9:
      check parseInt(($i)[0]) == i

  test "not int":
    for c in 'a'..'z':
      expect(NotADigitError):
        discard parseInt(c)

suite "parseInt(string)":
  test "actual int":
    check parseInt("12390121") == 12390121

  test "not int":
    expect(NotADigitError):
      discard parseInt("djnfalskd")

suite "substr()":
  test "normal substring":
    var s = "qwertyuiop"
    substr(s, 3, 5)
    check s == "rty"
    s = "asdfghjkl"
    substr(s, 6, 8)
    check s == "jkl"

  test "out of bound substring":
    var s = "qwertyuiop"
    substr(s, -1, 100)
    check s == "qwertyuiop"
    substr(s, 3, 100)
    check s == "rtyuiop"
    substr(s, -5, 4)

  test "invalid substring index":
    var s = "qwertyuiop"

    expect(InvalidIndexError):
      substr(s, 100, 0)
    expect(InvalidIndexError):
      substr(s, 5, -5)
    expect(InvalidIndexError):
      substr(s, 20, 3)
    expect(InvalidIndexError):
      substr(s, 5, 3)
    expect(InvalidIndexError):
      substr(s, 100, 120)
    expect(InvalidIndexError):
      substr(s, -30, -10)

suite "trim()":
  const s: string = "vkmdkfmdadgwed"

  test "no space":
    var x = s
    trim(x)
    check x == s

  test "front space":
    var x = "   " & s
    trim(x)
    check x == s

  test "back space":
    var x = s & "   "
    trim(x)
    check x == s

  test "both spaces":
    var x = "   " & s & "   "
    trim(x)
    check x == s

  test "between spaces":
    var x = "   " & s & " " & s & "   "
    trim(x)
    check x == s & " " & s

suite "replace(seq[char])":
  const cs1: seq[char] = toSeq("a magical sentence of words")

  test "words":
    const t: Table[string, string] = {
      "magic": "music",
      "sentence": "sequence",
      "word": "play",
      "f": "n",
    }.toTable()
    const cs2: seq[char] = toSeq("a musical sequence on plays")

    var x = cs1
    replace(x, t)
    check x == cs2

  test "characters":
    const t: Table[string, string] = {
      "a": "x",
      "e": "z",
      "o": "y",
      "s": "r",
    }.toTable()
    const cs2: seq[char] = toSeq("x mxgicxl rzntzncz yf wyrdr")

    var x = cs1
    replace(x, t)
    check x == cs2

  test "full replace":
    const t: Table[string, string] = {
      "a magical sentence of words": "a whole new sentence",
    }.toTable()
    const cs2: seq[char] = toSeq("a whole new sentence")

    var x = cs1
    replace(x, t)
    check x == cs2

  test "longer than given":
    const t: Table[string, string] = {
      "a magical sentence of words and more": "a whole new sentence",
    }.toTable()

    var x = cs1
    replace(x, t)
    check x == cs1

  test "no changes":
    const t: Table[string, string] = {
      "some words": "does not exist",
      "more words": "also nil",
    }.toTable()

    var x = cs1
    replace(x, t)
    check x == cs1


suite "replace(string)":
  const s1: string = "a magical sentence of words"

  test "words":
    const t: Table[string, string] = {
      "magic": "music",
      "sentence": "sequence",
      "word": "play",
      "f": "n",
    }.toTable()
    const s2: string = "a musical sequence on plays"

    check replace(s1, t) == s2

  test "characters":
    const t: Table[string, string] = {
      "a": "x",
      "e": "z",
      "o": "y",
      "s": "r",
    }.toTable()
    const s2: string = "x mxgicxl rzntzncz yf wyrdr"

    check replace(s1, t) == s2

  test "full replace":
    const t: Table[string, string] = {
      "a magical sentence of words": "a whole new sentence",
    }.toTable()
    const s2: string = "a whole new sentence"

    check replace(s1, t) == s2

  test "longer than given":
    const t: Table[string, string] = {
      "a magical sentence of words and more": "a whole new sentence",
    }.toTable()

    check replace(s1, t) == s1

  test "no changes":
    const t: Table[string, string] = {
      "some words": "does not exist",
      "more words": "also nil",
    }.toTable()

    check replace(s1, t) == s1

suite "`$`seq[char]":
  test "simple usecase":
    const sc: seq[char] = @['a', 'b', 'c', 'd']
    const s: string = "abcd"
    check $sc == s

  test "empty seq":
    const sc: seq[char] = @[]
    const s: string = ""
    check $sc == s

suite "width()":
  test "simple usecase":
    const ss: seq[string] = @["string1", "string2", "s3"]
    const si: seq[int] = @[7, 7, 2]
    check width(ss) == si

  test "empty string":
    const ss: seq[string] = @["string1", "", "s3"]
    const si: seq[int] = @[7, 0, 2]
    check width(ss) == si

suite "find()":
  test "examples":
    check find("<A,B>,B", '<', '>', ",") == @[5]
    check find("A,<B,C>", '<', '>', ",") == @[1]

suite "split()":
  test "examples":
    check split("<A,B>,B", '<', '>', ",") == @["<A,B>", "B"]
    check split(
      "<A, <B, C>>, <A, <B, C>>, <X, Y>",
      '<', '>', ", "
    ) == @[
      "<A, <B, C>>",
      "<A, <B, C>>",
      "<X, Y>"
    ]
