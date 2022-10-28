#!/bin/bash

java -jar preprocessor.jar ${1} "preprocessed.c"

./scripts/cpa.sh ${*:2}
