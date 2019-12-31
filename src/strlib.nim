from strutils import capitalizeAscii, continuesWith, replace, split, toUpperAscii
from sequtils import delete, insert, toSeq
import sets
import tables

var acronyms: HashSet[string] = initHashSet[string]()

type
  Case* = enum
    ## Supported case types.
    Default = "DEFAULT",
    Camel = "CAMEL",
    Kebab = "KEBAB",
    Lower = "LOWER",
    Pascal = "PASCAL",
    Snake = "SNAKE",
    Upper = "UPPER",

proc setAcronyms*(configAcronyms: HashSet[string]): void =
  ## Setter for acronyms to always apply ALLCAPS.
  acronyms = configAcronyms

proc camelCase*(variable: string, acronyms: HashSet[string] = acronyms): string =
  ## Converts `snake_case` string to `camelCase`.
  let words: seq[string] = variable.split("_")
  result = ""

  for word in words:
    if acronyms.contains(word):
      result &= toUpperAscii(word)
    elif result == "":
      result &= word
    else:
      result &= capitalizeAscii(word)

proc kebabCase*(variable: string): string =
  ## Converts `snake_case` string to `kebab-case`.
  result = variable.replace("_", "-")

proc lowerCase*(variable: string): string =
  ## Converts `snake_case` string to `lowercase`.
  result = variable.replace("_", "")

proc pascalCase*(variable: string, acronyms: HashSet[string] = acronyms): string =
  ## Converts `snake_case` string to `PascalCase`.
  result = capitalizeAscii(camelCase(variable, acronyms))

proc upperCase*(variable: string): string =
  ## Converts `snake_case` string to `UPPER_CASE`.
  result = toUpperAscii(variable)

proc format*(c: Case, variable: string, acronyms: HashSet[string] = acronyms): string =
  case c
  of Camel:
    result = camelCase(variable, acronyms)
  of Kebab:
    result = kebabCase(variable)
  of Lower:
    result = lowerCase(variable)
  of Pascal:
    result = pascalCase(variable, acronyms)
  of Upper:
    result = upperCase(variable)
  else:
    result = variable

proc allCases*(variable: string, acronyms: HashSet[string] = acronyms): Table[Case, string] =
  ## Get a `Table[Case, string]` of all the difference cases from `variable`.
  result = initTable[Case, string]()
  result.add(Case.Default, variable)
  result.add(Case.Camel, camelCase(variable, acronyms))
  result.add(Case.Kebab, kebabCase(variable))
  result.add(Case.Lower, lowerCase(variable))
  result.add(Case.Pascal, pascalCase(variable, acronyms))
  result.add(Case.Snake, variable)
  result.add(Case.Upper, upperCase(variable))

proc count*(word: string, chars: HashSet[char]): Table[char, int] =
  ## Similar to `count` in `strutil`
  ## `here <https://nim-lang.org/docs/strutils.html#count%2Cstring%2Cset%5Bchar%5D>`_
  ## but it returns the count of each `char` in `chars` individually in a table.
  result = initTable[char, int]()

  for cz in word:
    if cz in chars:
      if not result.hasKey(cz):
        result.add(cz, 1)
      else:
        inc(result[cz])

proc parseInt*(number: char): int =
  if int(number) < int('0') or int(number) > int('9'):
    raise newException(Exception, $number & " is not a number.")
  result = int(number) - int('0')

proc replace*(input: var seq[char], replacements: Table[string, string]): seq[char] =
  ## Similar to `multiReplace` in `strutil`
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
  result = input

proc seqCharToString*(input: seq[char]): string =
  ## Converts a `seq[char]` to `string`
  result = newStringOfCap(len(input))
  for cz in input:
      add(result, cz)

proc width*(strs: seq[string]): seq[int] =
  result = newSeq[int](0)

  for i in 0..(strs.len() - 1):
    result.add(strs[i].len())

proc maxWidth*(fields: seq[string]): seq[int] =
  ## Get longest width string for each column of the field (separated by space).
  result = newSeq[int](0)

  for fieldStr in fields:
    let field = fieldStr.split(' ')
    for i in 0..(field.len() - 1):
          if i >= result.len():
            result.add(field[i].len())
          elif field[i].len() > result[i]:
            result[i] = field[i].len()

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
