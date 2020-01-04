#!/usr/bin/env nim
from os import lastPathPart

mode = ScriptMode.Verbose

proc genRun(): void =
  if lastPathPart(getCurrentDir()) != "stones":
    echo "This script should be run on the top level folder instead."
    echo "Exiting..."
    return

genRun()
