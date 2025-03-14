#!/bin/bash

#
# Helper script to build a basic change log for pull requests
# has to be a better way to do this - sairuk
# 

MAIN=$(git log origin/main --oneline -n1 --pretty="format:%h")
COMMIT=$(git log --oneline --pretty="format:%h" | grep -B1 $MAIN | head -n1)
TESTING=$(git log origin/testing --oneline -n1 --pretty="format:%h")

git log --oneline --pretty="format:%s [%an]" --ancestry-path ${COMMIT}..${TESTING}