# Requirements
- cpp (Install: ``apt install build-essentials``)
- preprocessing (java -jar preprocessor.jar %inputfile %outputfile)

# Generation
## Linux
```bash
./scripts/cpa.sh -config config/pcc_gen_sign.properties -setprop limits.time.cpu=900s -setprop pcc.proofFile="arg.proof" -setprop "analysis.entryFunction=run_service_grey_cpu" "examples/service_grey/service_grey_cpu.c"
```
## Windows
```bash
 cpa.bat -config config/pcc_gen_sign.properties -setprop limits.time.cpu=900s -setprop pcc.proofFile="arg.proof" -setprop "analysis.entryFunction=run_service_grey_cpu" "examples/service_grey/service_grey_cpu.c"
```

### Parameters
1. CPAchecker
2. Configuration (pcc_gen_*)
3. Time-Limit
4. Certificate-File
5. Starting-Point of Analysis (Function)
6. C-File to verifiy

## PCC-Generatoren
- pcc_gen_interval.properties
- pcc_gen_predicate.properties
- pcc_gen_reachingDefinition.properties
- pcc_gen_sign.properties
- pcc_gen_signAnalysis.properties
- pcc_gen_signInterval.properties
- pcc_gen_value.properties

# Checking
## Linux
```bash
./scripts/cpa.sh -config config/pcc_check.properties -setprop limits.time.cpu=900s -setprop pcc.proof="output/arg.proof" -setprop "analysis.entryFunction=run_service_grey_cpu" "examples/service_grey/service_grey_cpu.c"
```

## Windows
```bash
cpa.bat -config config/pcc_check.properties -setprop limits.time.cpu=900s -setprop pcc.proof="output/arg.proof" -setprop "analysis.entryFunction=run_service_grey_cpu" "examples/service_grey/service_grey_cpu.c"
```

### Parameters
1. CPAchecker
2. Configuration (immer pcc_check.properties)
3. Time-Limit
4. Certificate-File
5. Starting-Point of Analysis (Function)
6. C-File to verifiy

## PCC-Validatoren
- pcc_check.properties