#!/bin/sh

BRANCH=$(git rev-parse --abbrev-ref HEAD)

rm -rf docs
for i in "src"/*
do
  nim doc --index:on -o:docs/ --git.url:https://github.com/binhonglee/stones --git.commit:"$BRANCH" --git.devel:"$BRANCH" "$i"
done
nim buildIndex -o:docs/theindex.html docs
mv docs/theindex.html docs/index.html
