This repository contains shell scripts that are supposed to be executed within a Docker container when basic services are deployed in the Testbed.
The shell script downloads the source code, runs the verification, runs the compilation and finally launches the SEDE executor.
The Docker container that is created for basic services has the following file system structure:

.

├─ cpachecker
├─ hooks  
├─ sede  
├─ src

-> Folder src contains the C, Java or Python code of basic services. This container must contain a compile.sh for the compilation. The compile script may call another build tool like gradle or make.

-> Source code is downloaded from a ServiceCodeProvider repository.

-> Cerificates (*.proof) for C implementations must be in the same directory as the .*c file and must have a specific file name pattern: <c-filename>_<analysis>.proof. For example, the name of the proof for the analysis sign for the C implementation service_grey_cpu.c must be service_grey_cpu_sign.proof.

-> The configuration files that are necessary for the SEDE executor must be in the folder src/main/resources/config.

-> Folder hooks contains shell scripts for downloading the source code, running the verification, and running the compilation.

-> Folder sede contains the SEDE executor logic.

-> The script run.sh executes all scripts in the hooks folder in alphanumerical order and starts the SEDE server in the end.


Installation
The following software needs to be installed inside the Docker container:

curl | 
git | 
javac / gcc |
gradle / make
