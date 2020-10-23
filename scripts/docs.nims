#!/usr/bin/env nim
from os import lastPathPart
from strutils import indent, unindent, removeSuffix

mode = ScriptMode.Verbose

const gitURL: string = "https://github.com/binhonglee/stones"
const folder: string = "docs"
const mainDir: string = "src"
const outFile: string = "src/stones.nim"
const devel: string = "devel"
var mainFile: string = ""

proc genFiles(cur: string): void =
  for dir in listDirs(cur):
    genFiles(dir)
  
  for file in listFiles(cur):
    if len(mainFile) > 0:
      mainFile &= "\n"
    var line = file
    removeSuffix(line, ".nim")
    mainFile &= line

proc genRun(): void =
  if lastPathPart(getCurrentDir()) != "stones":
    echo "This script should be run on the top level folder instead."
    echo "Exiting..."
    return

  if dirExists(folder):
    rmdir(folder)

  if fileExists(outFile):
    rmFile(outFile)

  genFiles(mainDir)
  mainFile = indent(unindent(mainFile, 1, "src/"), 1, "import ")
  exec("echo \"" & mainFile & "\" > " & outFile)
  exec(
    "nim doc --project --index:on -o:" & folder &
    "/ --git.url:" & gitURL &
    " --git.commit:" & devel &
    " --git.devel:" & devel & " " & outFile
  )

  exec("nim buildIndex -o:" & folder & "/theindex.html " & folder)
  mvFile(folder & "/theindex.html", folder & "/index.html")
  rmFile(outFile)

genRun()
