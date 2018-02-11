#!/bin/bash
#
# Reformats JSON files that were modified sorting the keys.
#
# To enable this hook, move this file to ".git/hooks/pre-commit".

for JSONfile in $(git diff --name-only HEAD | fgrep '.json')
do
    tempfile=$(mktemp)
    if [ -f $JSONfile ]; then
      jq -SM '.' < $JSONfile > $tempfile
      if [ $? = 0 ]; then
          mv ${tempfile} $JSONfile
      else
          echo it didn\'t work. Leaving file as it was: $JSONfile
          exit 1
      fi
    fi
done
