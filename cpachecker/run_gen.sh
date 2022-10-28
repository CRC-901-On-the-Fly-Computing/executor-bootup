#!/bin/bash

temp=$(echo ${3} | sed -r "s/.+\/(.+)\..+/\1/")

java -jar preprocessor.jar ${3} "preprocessed.c"
./scripts/cpa.sh -config config/pcc_gen_${2}.properties -spec config/specification/${1} -setprop limits.time.cpu=900s -setprop pcc.proofFile="arg.proof" -setprop "analysis.entryFunction=run_${temp}" "preprocessed.c"
