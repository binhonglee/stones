# Package

version       = "0.0.1"
author        = "BinHong Lee"
description   = "A library of useful functions and tools for nim."
license       = "MIT"
srcDir        = "src"
skipDirs      = @["test"]

requires "nim >= 1.0.0"

task docs, "Build docs":
  exec "./scripts/docs.nims"

task test, "Runs the test suite":
  exec "./scripts/tests.nims"
