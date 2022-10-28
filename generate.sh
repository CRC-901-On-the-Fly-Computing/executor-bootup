#!/bin/bash

## Directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Current Directory " $(pwd)

## Mustache template engine
mo=./helpers/mo

## Make all helpers executable
chmod -R +x ./helpers

## Set default values for environmental variables
if [ -z ${INT_EXECUTOR_IP+x} ]; then
  echo "Environment variable INT_EXECUTOR_IP is unset; thus, use default 127.0.0.1";
  export IP=${ip:=127.0.0.1}
else
  echo "Environment variable INT_EXECUTOR_IP is set to ${INT_EXECUTOR_IP} and it is used as IP for SEDE Executor";
  export IP=${ip:=${INT_EXECUTOR_IP}}
fi

## check for the SEDE server PORT
if [ -z ${INT_EXECUTOR_PORT+x} ]; then
  echo "Environment variable INT_EXECUTOR_PORT is unset; thus use default port 8000"
  export PORT=${port:=8000}
else
  echo "Environment variable INT_EXECUTOR_PORT is set to ${INT_EXECUTOR_PORT} and it is used as PORT for SEDE Executor";
  export PORT=${port:=${INT_EXECUTOR_PORT}}
fi


export SEDE_DIRECTORY=${DIR}

## Generate template files
$mo --source=./default.vars ./templates/check.sh.tmpl > check.sh
$mo --source=./default.vars ./templates/run.sh.tmpl > run.sh

find "$DIR"/. -type f -name '*.sh' -exec chmod +x '{}' \;

source ./check.sh

