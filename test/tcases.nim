import tables, unittest
import cases

suite "camelCase":
  const camelCase: string = "camelCase"
  const snakeCase: string = "camel_case"

  test "camelCase => camel_case":
    check fromCamelCase(camelCase) == snakeCase

  test "camel_case => camelCase":
    check toCamelCase(snakeCase) == camelCase

  test "currentCase()":
    check currentCase(camelCase) == Case.Camel

suite "kebab-case":
  const kebabCase: string = "kebab-case"
  const snakeCase: string = "kebab_case"

  test "kebab-case => kebab_case":
    check fromKebabCase(kebabCase) == snakeCase

  test "kebab_case => kebab-case":
    check toKebabCase(snakeCase) == kebabCase

  test "currentCase()":
    check currentCase(kebabCase) == Case.Kebab

suite "lowercase":
  const lowerCase: string = "lowercase"
  const snakeCase: string = "lower_case"

  test "lower_case => lowercase":
    check toLowerCase(snakeCase) == lowerCase

  test "currentCase()":
    check currentCase(lowerCase) == Case.Lower

suite "PascalCase":
  const pascalCase: string = "PascalCase"
  const snakeCase: string = "pascal_case"

  test "PascalCase => pascal_case":
    check fromPascalCase(pascalCase) == snakeCase

  test "pascal_case => PascalCase":
    check toPascalCase(snakeCase) == pascalCase

  test "currentCase()":
    check currentCase(pascalCase) == Case.Pascal

suite "UPPER_CASE":
  const upperCase: string = "UPPER_CASE"
  const snakeCase: string = "upper_case"

  test "UPPER_CASE => upper_case":
    check fromUpperCase(upperCase) == snakeCase

  test "upper_case => UPPER_CASE":
    check toUpperCase(snakeCase) == upperCase

  test "currentCase()":
    check currentCase(upperCase) == Case.Upper

const camelCase: string = "justABunchOfWords"
const kebabCase: string = "just-a-bunch-of-words"
const lowerCase: string = "justabunchofwords"
const pascalCase: string = "JustABunchOfWords"
const snakeCase: string = "just_a_bunch_of_words"
const upperCase: string = "JUST_A_BUNCH_OF_WORDS"

suite "format()":
  test "justABunchOfWords":
    check format(Default, camelCase) == camelCase
    check format(Camel, camelCase) == camelCase
    check format(Kebab, camelCase) == kebabCase
    check format(Lower, camelCase) == lowerCase
    check format(Pascal, camelCase) == pascalCase
    check format(Snake, camelCase) == snakeCase
    check format(Upper, camelCase) == upperCase

  test "just-a-bunch-of-words":
    check format(Default, kebabCase) == kebabCase
    check format(Camel, kebabCase) == camelCase
    check format(Kebab, kebabCase) == kebabCase
    check format(Lower, kebabCase) == lowerCase
    check format(Pascal, kebabCase) == pascalCase
    check format(Snake, kebabCase) == snakeCase
    check format(Upper, kebabCase) == upperCase

  test "JustABunchOfWords":
    check format(Default, pascalCase) == pascalCase
    check format(Camel, pascalCase) == camelCase
    check format(Kebab, pascalCase) == kebabCase
    check format(Lower, pascalCase) == lowerCase
    check format(Pascal, pascalCase) == pascalCase
    check format(Snake, pascalCase) == snakeCase
    check format(Upper, pascalCase) == upperCase

  test "just_a_bunch_of_words":
    check format(Default, snakeCase) == snakeCase
    check format(Camel, snakeCase) == camelCase
    check format(Kebab, snakeCase) == kebabCase
    check format(Lower, snakeCase) == lowerCase
    check format(Pascal, snakeCase) == pascalCase
    check format(Snake, snakeCase) == snakeCase
    check format(Upper, snakeCase) == upperCase

  test "JUST_A_BUNCH_OF_WORDS":
    check format(Default, upperCase) == upperCase
    check format(Camel, upperCase) == camelCase
    check format(Kebab, upperCase) == kebabCase
    check format(Lower, upperCase) == lowerCase
    check format(Pascal, upperCase) == pascalCase
    check format(Snake, upperCase) == snakeCase
    check format(Upper, upperCase) == upperCase

suite "allCases()":
  test "justABunchOfWords":
    let temp = allCases(camelCase)
    check temp[Default] == camelCase
    check temp[Camel] == camelCase
    check temp[Kebab] == kebabCase
    check temp[Lower] == lowerCase
    check temp[Pascal] == pascalCase
    check temp[Snake] == snakeCase
    check temp[Upper] == upperCase

  test "just-a-bunch-of-words":
    let temp = allCases(kebabCase)
    check temp[Default] == kebabCase
    check temp[Camel] == camelCase
    check temp[Kebab] == kebabCase
    check temp[Lower] == lowerCase
    check temp[Pascal] == pascalCase
    check temp[Snake] == snakeCase
    check temp[Upper] == upperCase

  test "JustABunchOfWords":
    let temp = allCases(pascalCase)
    check temp[Default] == pascalCase
    check temp[Camel] == camelCase
    check temp[Kebab] == kebabCase
    check temp[Lower] == lowerCase
    check temp[Pascal] == pascalCase
    check temp[Snake] == snakeCase
    check temp[Upper] == upperCase

  test "just_a_bunch_of_words":
    let temp = allCases(snakeCase)
    check temp[Default] == snakeCase
    check temp[Camel] == camelCase
    check temp[Kebab] == kebabCase
    check temp[Lower] == lowerCase
    check temp[Pascal] == pascalCase
    check temp[Snake] == snakeCase
    check temp[Upper] == upperCase

  test "JUST_A_BUNCH_OF_WORDS":
    let temp = allCases(upperCase)
    check temp[Default] == upperCase
    check temp[Camel] == camelCase
    check temp[Kebab] == kebabCase
    check temp[Lower] == lowerCase
    check temp[Pascal] == pascalCase
    check temp[Snake] == snakeCase
    check temp[Upper] == upperCase
