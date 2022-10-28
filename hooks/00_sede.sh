#!/bin/bash

## Making sure the sede folder exists
rm -rf sede
mkdir -p sede
cd sede

echo "Current Directory " $(pwd)
echo "Clonning SEDE git Repo"
## Cloning SEDE project
git clone https://github.com/fmohr/SEDE.git --branch executor-spawner

## Checking out tag 0.0.7
## git checkout v0.0.7
## Compiling SEDE
cd SEDE
./gradlew --no-daemon jarjar

## Copy all sede executor to proper place
cp -R ./deploy/SEDE/. ../../sede

## Remove extra files
cd ..
rm -rf SEDE

cd ..
echo "Current Directory " $(pwd)
