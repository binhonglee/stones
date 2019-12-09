#!/bin/sh

for i in "src/stones"/*
do
  nim doc --project --index:on -o:docs/ --git.url:https://github.com/binhonglee/stones --git.commit:master "$i"
done
nim buildIndex -o:docs/theindex.html docs
mv docs/theindex.html docs/index.html