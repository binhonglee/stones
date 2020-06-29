#!/usr/bin/env nim
from os import lastPathPart

mode = ScriptMode.Verbose

const gitURL: string = "https://github.com/binhonglee/stones"
const folder: string = "docs"
const mainDir: string = "src"
const devel: string = "devel"

proc genRun(): void =
  if lastPathPart(getCurrentDir()) != "stones":
    echo "This script should be run on the top level folder instead."
    echo "Exiting..."
    return

  if dirExists(folder):
    rmdir(folder)

  for file in listFiles(mainDir):
    exec(
      "nim doc --project --index:on -o:" & folder &
      "/ --git.url:" & gitURL &
      " --git.commit:" & devel &
      " --git.devel:" & devel & " " & file
    )

  exec("nim buildIndex -o:" & folder & "/theindex.html " & folder)
  mvFile(folder & "/theindex.html", folder & "/index.html")

genRun()
