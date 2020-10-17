#!/usr/bin/env nim
from os import FilePermission, lastPathPart, setFilePermissions
from strutils import endsWith, startsWith

mode = ScriptMode.Verbose
const prefix = 't'
const suffix = ".nim"
const outDir = "bin/"
const testDir = "tests"

proc genRun(): void =
  if lastPathPart(getCurrentDir()) != "stones":
    echo "This script should be run on the top level folder instead."
    echo "Exiting..."
    return

  let testFiles: seq[string] = listFiles(testDir)
  var testBinaries: seq[string] = newSeq[string](testFiles.len())
  var i: int = 0
  for file in testFiles:
    var s: string = lastPathPart(file)
    if s.len() > 0 and s.startsWith(prefix) and s.endsWith(suffix):
      s.setLen(s.len() - suffix.len())
      exec "nim c --verbosity:0 --outDir:" & outDir & " " & testDir & "/" & s
      testBinaries[i] = s
      inc(i)

  for bin in testBinaries:
    if bin.len() > 0:
      echo ""
      exec(outDir & bin)

genRun()
