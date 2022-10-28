#!/bin/bash


echo "start compilation"
cd src

for SERVICE_PATH in `find $DIR/src/. ! -path $DIR/src/. -type d -maxdepth 1`
do
  ## Making sure there is no problem with relative paths
  SERVICE=`basename $SERVICE_PATH`

  echo "Trying to compile '$SERVICE'"
  cd $SERVICE
  ./compile.sh
  cp -R ./build/libs/. ..
  cd ..

  ## Remove srouce of serivce
  # rm -rf $SERVICE
done
cd ..
echo "end compilation"

return 0
