#!/bin/bash

DIRECTORY="ServiceCodeProvider"

echo "start downloading"
# -p, --parents     no error if existing, make parent directories as needed
mkdir -p codebase
cd codebase

CODE_PROVIDER_API_URL="http://postgrest.postgres:3000/code_provider_registry?code_provider_id=eq."
SERVICE_REGISTRY_API_URL="http://postgrest.postgres:3000/service_registry?service_id=eq."

## Making sure the ServiceCodeProvider directory is exist
rm -rf "$DIRECTORY"
mkdir -p "$DIRECTORY"
cd "$DIRECTORY"

CLONE_TIME=0
## Copy service source to main src folder
for SERVICE in "${SERVICES[@]}"
do

  SERVICE_RESULT="$SERVICE-result.json"
  
  CODE_PROVIDER="$SERVICE-code-provider.json"
  
  ## Get the code provider for this service
  curl -s -X GET $SERVICE_REGISTRY_API_URL$SERVICE -o $SERVICE_RESULT  
  COUNT=`$jq '.|length' < $SERVICE_RESULT`

  echo "'$SERVICE' status: $COUNT"
  ## Download the service-information
  if [ $COUNT -gt 0 ]; then 
    CODE_PROVIDER_ID=`$jq --raw-output '.[0].code_provider_id' < $SERVICE_RESULT`
 
    curl -s -X GET $CODE_PROVIDER_API_URL$CODE_PROVIDER_ID -o $CODE_PROVIDER 
    COUNT=`$jq '.|length' < $CODE_PROVIDER`
    
    if [ $COUNT -gt 0 ]; then 
      REPO_URL=`$jq --raw-output '.[0].repository_url' < $CODE_PROVIDER`
      REPO_SUB_FOLDER=`$jq --raw-output '.[0].subfolder' < $CODE_PROVIDER`
      REPO_TAG=`$jq --raw-output '.[0].tag' < $CODE_PROVIDER`

      if [ ! -d "$CODE_PROVIDER_ID" ]; then
        mkdir -p "$CODE_PROVIDER_ID"
        
        ## Clone the URL from API
        cd "$CODE_PROVIDER_ID"
        git clone $REPO_URL . --branch $REPO_TAG

        CLONE_TIME=$((CLONE_TIME + 1))
      else
        cd "$CODE_PROVIDER_ID"
      fi

      ## Making sure all bash scripts will run properly
      find . -type f -name '*.sh' -exec chmod +x '{}' \;
      cp -R $REPO_SUB_FOLDER $DIR/src/

      cd ..
    fi
  fi
done
cd $DIR

echo "Current Directory " $(pwd)
echo "clone time: $CLONE_TIME"
echo "end downloading"

return 0
