#!/bin/bash


#./run_check.sh default.spc sign src/service_grey/service_grey_cpu.c
echo "start verification"
echo "Current Directory " $(pwd)

cd cpachecker
for SERVICE in "${SERVICES[@]}"
do
  count_sourcefile=`find ../src/$SERVICE/src/*/ -maxdepth 1 -name '*.c' | wc -l | xargs`
  echo "Trying to verify '$SERVICE', number of file: $count_sourcefile"
  if [ "$count_sourcefile" -gt "0" ]; then
    for sourcefile in ../src/$SERVICE/src/*/*_cpu.c
    do
      # prevent loop execution when no files found
      [ -e "$sourcefile" ] || continue

      isCertified=false
      isVerified=
      duration=0
      size=0

      proofs="${sourcefile/\_cpu.c/_cpu*.proof}"
      for proof in $proofs
      do
        # prevent loop execution when no files found
        [ -e "$proof" ] || continue

        echo "$sourcefile"
        echo "$proof"

        isCertified=true

        analysis="${proof/.proof/}"
        #analysis=../src/service_grey/service_grey_cpu_predicate

        prefix="${sourcefile/.c/}"
        #prefix=../src/service_grey/service_grey_cpu

        analysis="${analysis/$prefix\_/}"
        echo "running $analysis for $sourcefile"

        ./run_check.sh default.spc "$analysis" "$sourcefile"
        # isVerified is only true when every proof for one sourcefile has verified successfully
        if [ "$?" -eq "0" ]; then
          isVerified=${isVerified:-true}
        else
          isVerified=false
        fi

        # get CPU time for CPAchecker in ms
        duration=$(( $duration + $(grep "^Total CPU time for CPAchecker: " ./output/Statistics.txt | sed -r "s/.* ([0-9]*)\.([0-9]{3})s/\1\2/g") ))

        # get size of zertificates
        size=$(( $size + $(stat -c%s $proof) ))

      done

      # send log to elasticsearch
      curl -X POST "http://sfb-k8master-1.cs.uni-paderborn.de:30080/elastic/search/mm_cpa_checks/t" -H "Content-Type: application/json" -d"
{
	\"time\": $(date +%s),
	\"duration\": $duration,
	\"service.name\": \"${sourcefile##*/}\",
	\"cpaCheck.servId\": \"${sourcefile##*/}\",
	\"cpaCheck.isCertified\": $isCertified,
	\"cpaCheck.isVerified\": \"${isVerified:-unknown}\",
	\"cpaCheck.size\": \"$size\",
	\"cpaCheck.url\": \"URL_of_ARG\"
}
"

    done
  else
    echo "nothing happend to '$SERVICE'"
  fi
done
cd ..
echo "end verification"

return 0
