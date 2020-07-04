from strutils
import isDigit, isSpaceAscii, replace, split
from sequtils import delete, insert, toSeq
import sets
import tables

type
  InvalidIndexError* = object of IOError

type
  NotADigitError* = object of ValueError

proc count*(word: string, chars: HashSet[char]): Table[char, int] =
  ## Similar to `count` in `strutil`
  ## `here <https://nim-lang.org/docs/strutils.html#count%2Cstring%2Cset%5Bchar%5D>`_
  ## but it returns the count of each `char` in `chars` individually in a table.
  result = initTable[char, int]()

  for c in word:
    if c in chars:
      if not result.hasKey(c):
        result.add(c, 1)
      else:
        inc(result[c])

proc parseInt*(num: char): int {.raises: [NotADigitError].} =
  ## Parse `num` into an `int`.
  ## Will raise `NotADigitError` if `num` is not a digit.
  if not isDigit(num):
    raise newException(NotADigitError, $num & " is not a digit.")
  result = int(num) - int('0')

proc parseInt*(num: string): int =
  ## Parse `num` into an `int`.
  ## Will raise `NotADigitError` if `num` is not a digit.
  result = 0
  var first: bool = true
  for c in num:
    if not first:
      result *= 10
    else:
      first = false
    result += parseInt(c)

proc substr*(s: var string, first, last: int): void =
  ## Similar to `substr` in `system`
  ## `here <https://nim-lang.org/docs/system.html#substr%2Cstring%2Cint%2Cint>`_
  ## but this is done in place.
  if first > last or first > (s.len() - 1) or last < 0:
    raise newException(InvalidIndexError, "`first` or `last` value given is invalid")

  let start = max(first, 0)
  let stop = max(min(last, high(s)) - start, 0)
  for i in 0..(stop):
    s[i] = s[start + i]
  s.setLen(stop + 1)

proc trim*(s: var string): void =
  ## Trim whitespaces of the given string.
  ## Similar to `strip` in `strutils`
  ## `here <https://nim-lang.org/docs/strutils.html#strip%2Cstring%2Cset%5Bchar%5D>`_
  ## but this is done in place.
  var beginLoc: int
  var stopLoc: int

  var start = false
  var i: int = 0

  for c in s:
    if not c.isSpaceAscii():
      if not start:
        start = true
        beginLoc = i
      else:
        stopLoc = i
    inc(i)

  s.substr(beginLoc, stopLoc)

proc replace*(input: var seq[char], replacements: Table[string, string]): void =
  ## Similar to `multiReplace` in `strutils`
  ## `here <https://nim-lang.org/docs/strutils.html#multiReplace%2Cstring%2Cvarargs%5B%5D>`_
  ## but it takes in `Table[string, string]` instead of `varargs[tuple(string, string)]`.
  var i: int = 0
  var firstChars: Table[char, HashSet[string]] = initTable[char, HashSet[string]]()
  for word in replacements.keys:
    if not firstChars.hasKey(word[0]):
      firstChars.add(word[0], initHashSet[string]())
    firstChars[word[0]].incl(word)
  while i < input.len:
    if firstChars.hasKey(input[i]):
      for word in firstChars[input[i]]:
        var j: int = 0
        var same: bool = true
        while word.len() - j > 0 and input.len() > i + j and same:
          if word[j] == input[i + j]:
            inc(j)
          else:
            same = false

        if word.len() - j == 0 and same:
          dec(j)
          input.delete(i, i + j)
          input.insert(toSeq(replacements[word].items), i)
    inc(i)

proc replace*(s: string, replacements: Table[string, string]): string =
  ## Similar to `multiReplace` in `strutils`
  ## `here <https://nim-lang.org/docs/strutils.html#multiReplace%2Cstring%2Cvarargs%5B%5D>`_
  ## but it takes in `Table[string, string]` instead of `varargs[tuple(string, string)]`.
  var i: int = 0
  var prev: int = 0
  var firstChars: Table[char, HashSet[string]] = initTable[char, HashSet[string]]()
  result = ""

  for word in replacements.keys:
    if not firstChars.hasKey(word[0]):
      firstChars.add(word[0], initHashSet[string]())
    firstChars[word[0]].incl(word)

  while i < s.len():
    if firstChars.hasKey(s[i]):
      for word in firstChars[s[i]]:
        var j: int = 0
        var same: bool = true
        while word.len() - j > 0 and s.len() > i + j and same:
          if word[j] == s[i + j]:
            inc(j)
          else:
            same = false

        if word.len() - j == 0 and same:
          result &= system.substr(s, prev, i - 1) & replacements[word]
          prev = i + j
          i = prev - 1
    inc(i)
  result &= system.substr(s, prev, i - 1)

proc `$`*(input: seq[char]): string =
  ## Converts a `seq[char]` to `string`
  result = newString(len(input))
  var i = 0
  for c in input:
    result[i] = c
    inc(i)

proc seqCharToString*(input: seq[char]): string {.deprecated:
  "Use `$` instead.".}=
  ## Use `$ proc <#$,seq[char]>`_ instead
  $input

proc width*(strs: seq[string]): seq[int] =
  ## A `seq` of `str.len()`.
  result = newSeq[int](0)

  for i in 0..(strs.len() - 1):
    result.add(strs[i].len())

proc find*(str: string, open: char, close: char, toFind: string): seq[int] =
  ## Find location of `toFind` in `str` when the `open` and `close` character count is the same
  runnableExamples:
    doAssert find("<A,B>,B", '<', '>', ",") == @[5]
    doAssert find("A,<B,C>", '<', '>', ",") == @[1]
  var oCount: int = 0
  var cCount: int = 0
  result = newSeq[int](0)

  var i: int = 0
  for c in str.items:
    if c == open:
      inc(oCount)
    elif c == close:
      inc(cCount)
    elif oCount == cCount:
      var j: int = 0
      while i + j < str.len() and j < toFind.len() and str[i + j] == toFind[j]:
        inc(j)
      if toFind.len() == j:
        result.add(i)
    inc(i)

proc split*(str: string, open: char, close: char, separator: string): seq[string] =
  ## Split string into a sequence of string based on the given info from `find <#find,string,string,char,char,string>`_ .
  runnableExamples:
    doAssert split("<A,B>,B", '<', '>', ",") == @["<A,B>", "B"]
    doAssert split("<A, <B, C>>, <A, <B, C>>, <X, Y>", '<', '>', ", ") == @["<A, <B, C>>", "<A, <B, C>>", "<X, Y>"]
  result = newSeq[string](0)
  var pos: seq[int] = find(str, open, close, separator)
  pos.add(str.len())
  var prev: int = 0
  for p in pos:
    var i: int = 0
    var s: string = newString(p - prev)

    while prev + i < p:
      s[i] = str[prev + i]
      inc(i)
    result.add(s)
    prev = p + separator.len()
