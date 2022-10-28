# Parameters
- %analysis%:			Refers to the CPAchecker config file *(Defining analysis)*
- %specification%:		CPAchecker specification file *(Defining correctness)*
- %program%:			.c source code file to verify
- .../...proof*:		Certificate
- preprocessed.c*:		Preprocessed version of %program%
* static parameter which is hidden in the runscript

## Checking (for the TestBed)
cmd:
./run_check.sh %specification% %analysis% %program%

example:
./run_check.sh default.spc sign basicServices/service_grey/service_grey_cpu.c

### Output
```bash
Preprocessing... done!
Running CPAchecker with default heap size (1200M). Specify a larger value with -heap if you have more RAM.
Running CPAchecker with default stack size (1024k). Specify a larger value with -stack if needed.
Verification result: TRUE. No property violation found by chosen configuration.
More details about the verification run can be found in the directory "./output".
Graphical representation included in the file "./output/Report.html".
```
We are interested in the fact that the verification result is ``TRUE``.

## Generation (for us)
cmd:
./run_gen.sh %specification% %analysis% %program%

example:
./run_gen.sh default.spc sign basicServices/service_grey/service_grey_cpu.c