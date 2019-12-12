# Package

version       = "0.0.1"
author        = "BinHong Lee"
description   = "A library of useful functions and tools for nim."
license       = "MIT"
bin           = @["genlib", "log", "strlib"]
binDir        = "bin"
srcDir        = "src"
installDirs   = @["src"]

requires "nim >= 1.0.0"
