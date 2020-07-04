from strutils
import capitalizeAscii, delete, isLowerAscii, isUpperAscii,
  replace, split, toLowerAscii, toUpperAscii
import sets
import tables

type
  UnsupportedCharacterError* = object of ValueError

var acronyms: HashSet[string] = initHashSet[string]()

const keywords: Table[string, char] = {
  "KEBAB": '-',
  "SNAKE": '_',
}.toTable()

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
  ## Setter for acronyms to always apply `ALLCAPS`.
  acronyms = configAcronyms

proc fromCamelCase*(s: string, acronyms: HashSet[string] = acronyms): string =
  ## Converts `camelCase` string to `snake_case`.
  result = ""
  var temp: string = ""

  for c in s:
    if isUpperAscii(c):
      if acronyms.contains(temp):
        result &= "_" & toLowerAscii(temp)
        temp = ""
      temp &= c
    else:
      if temp.len() > 0:
        for x in temp:
          result &= "_" & toLowerAscii(x)
        temp = ""
      result &= c

proc toCamelCase*(s: string, acronyms: HashSet[string] = acronyms): string =
  ## Converts `snake_case` string to `camelCase`.
  let words: seq[string] = s.split("_")
  result = ""

  for word in words:
    if acronyms.contains(word):
      result &= toUpperAscii(word)
    elif result == "":
      result &= word
    else:
      result &= capitalizeAscii(word)

proc fromKebabCase*(s: string): string =
  ## Converts `kebab-case` string to `snake_case`.
  result = s.replace("-", "_")

proc toKebabCase*(s: string): string =
  ## Converts `snake_case` string to `kebab-case`.
  result = s.replace("_", "-")

proc toLowerCase*(s: string): string =
  ## Converts `snake_case` string to `lowercase`.
  result = s.replace("_", "")

proc fromPascalCase*(s: string, acronyms: HashSet[string] = acronyms): string =
  ## Converts `PascalCase` string to `snake_case`.
  result = fromCamelCase(s, acronyms)

  var i = -1

  while result[i + 1] == '_':
    inc(i)

  if i >= 0:
    result.delete(0, i)

proc toPascalCase*(s: string, acronyms: HashSet[string] = acronyms): string =
  ## Converts `snake_case` string to `PascalCase`.
  result = capitalizeAscii(toCamelCase(s, acronyms))

proc fromUpperCase*(s: string): string =
  ## Converts `UPPER_CASE` string to `snake_case`.
  result = toLowerAscii(s)

proc toUpperCase*(s: string): string =
  ## Converts `snake_case` string to `UPPER_CASE`.
  result = toUpperAscii(s)

proc camelCase*(
  s: string,
  acronyms: HashSet[string] = acronyms
): string {.deprecated:
  "Use `toCamelCase()` instead.".} =
  ## `toCamelCase() <#toCamelCase,string,HashSet[string]>`_
  result = toCamelCase(s, acronyms)

proc kebabCase*(s: string): string {.deprecated:
  "Use `toKebabCase()` instead.".} =
  ## `toKebabCase() <#toKebabCase,string>`_
  result = toKebabCase(s)

proc lowerCase*(s: string): string {.deprecated:
  "Use `toLowerCase()` instead.".} =
  ## `toLowerCase() <#toLowerCase,string>`_
  result = toLowerCase(s)

proc pascalCase*(
  s: string,
  acronyms: HashSet[string] = acronyms
): string {.deprecated:
  "Use `toPascalCase()` instead.".} =
  ## `toPascalCase() <#toPascalCase,string,HashSet[string]>`_
  result = capitalizeAscii(toCamelCase(s, acronyms))

proc upperCase*(s: string): string {.deprecated:
  "Use `toUpperCase()` instead.".} =
  ## `toUpperCase() <#toUpperCase,string>`_
  result = toUpperAscii(s)

proc currentCase*(s: string): Case =
  ## Guess the current case format of the string (not tested for edge cases).
  ## Returns `Default` if its not able to properly determine its case.
  var cases: HashSet[Case] = initHashSet[Case]()
  var firstChar: Case = Default

  for c in s:
    var this: Case = Default
    case c
    of keywords[$Kebab]:
      this = Kebab
    of keywords[$Snake]:
      this = Snake
    elif isLowerAscii(c):
      this = Lower
    elif isUpperAscii(c):
      this = Upper
    # Not sure if we should support digits in here as well
    else:
      raise newException(UnsupportedCharacterError, "Unsupported character '" & c & "' found.")

    if firstChar == Default:
      firstChar = this
    cases.incl(this)

  if (
    cases.contains(Kebab) and cases.contains(Snake)
  ) or (
    cases.contains(Kebab) and cases.contains(Upper)
  ) or (
    cases.contains(Lower) and cases.contains(Upper) and cases.contains(Snake)
  ):
    result = Default
  elif cases.contains(Kebab):
    result = Kebab
  elif not cases.contains(Lower):
    result = Upper
  elif cases.contains(Snake):
    result = Snake
  elif (
    cases.contains(Upper) and cases.contains(Lower)
  ):
    if firstChar == Upper:
      result = Pascal
    else:
      result = Camel
  elif not cases.contains(Upper):
    result = Lower
  else:
    result = Default

proc format*(
  c: Case, s: string,
  acronyms: HashSet[string] = acronyms
): string =
  ## Convert `s` into the specified Case `c` based on the best guess of the current Case
  if c == Default:
    return s

  case currentCase(s)
  of Camel:
    result = fromCamelCase(s, acronyms)
  of Kebab:
    result = fromKebabCase(s)
  of Pascal:
    result = fromPascalCase(s, acronyms)
  of Upper:
    result = fromUpperCase(s)
  of Default, Lower, Snake:
    result = s

  case c
  of Camel:
    result = toCamelCase(result, acronyms)
  of Kebab:
    result = toKebabCase(result)
  of Lower:
    result = toLowerCase(result)
  of Pascal:
    result = toPascalCase(result, acronyms)
  of Snake:
    result = result
  of Upper:
    result = toUpperCase(result)
  of Default:
    result = s

proc allCases*(
  s: string,
  c: Case = Default,
  acronyms: HashSet[string] = acronyms,
): Table[Case, string] =
  ## Get a `Table[Case, string]` of all the difference cases from `s`.
  var t: string
  case c
  of Default:
    t = format(Snake, s, acronyms)
  of Camel:
    t = fromCamelCase(s, acronyms)
  of Kebab:
    t = fromKebabCase(s)
  of Lower:
    raise newException(Exception, "Unsupported origin case for conversion.")
  of Pascal:
    t = fromPascalCase(s, acronyms)
  of Snake:
    t = s
  of Upper:
    t = fromUpperCase(s)

  result = initTable[Case, string]()
  result.add(Default, s)
  result.add(Camel, toCamelCase(t, acronyms))
  result.add(Kebab, toKebabCase(t))
  result.add(Lower, toLowerCase(t))
  result.add(Pascal, toPascalCase(t, acronyms))
  result.add(Snake, t)
  result.add(Upper, toUpperCase(t))

