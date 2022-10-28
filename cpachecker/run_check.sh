#!/bin/bash

file=$(echo ${3} | sed -r "s/.+\/(.+)\..+/\1/")
folder=$(echo ${3} | sed -r "s/(.+)\/.+/\1/")

#echo ${temp2}"/"${temp}"_"${2}".proof"

java -jar preprocessor.jar ${3} "preprocessed.c"

echo -n "Starting analysis... "
string=$(./scripts/cpa.sh -config config/pcc_check.properties -spec config/specification/${1} -setprop limits.time.cpu=900s -setprop pcc.proof=${folder}"/"${file}"_"${2}".proof" -setprop "analysis.entryFunction=run_"${file} -setprop "log.consoleLevel=OFF" "preprocessed.c")
echo "done!"

echo -n "Result: "
if [[ $string = *"TRUE"* ]]; then
echo "Service successfully verified!"
exit 0
else
echo "Verification failed!"
exit 1
fi