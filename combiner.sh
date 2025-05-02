#!/bin/bash

echo "starting combining" 1>&2

# first combine
head -n 1 CSECICIDS2018_improved/Friday-02-03-2018.csv > combined.csv
for f in CSECICIDS2018_improved/*.csv; do echo "combining $f" 1>&2; tail -n +2 -q "$f" >> combined.csv; done

