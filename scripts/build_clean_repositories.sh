#!/bin/bash -e

if [ $# -eq 0 ]; then
  echo "Usage: $0 <build dir>"
  exit 1
fi

cd ${1}

for d in *; do
  if [[ -d "${d}" && "${d}" != "_repos" ]]; then
    echo "process $d ..."
    ( cd $d; rm -rf opencv* 2.4* 3.4* 4.x* 5.x* next ci build* install* samples_build .container )
  fi
done

cd -

