#!/bin/bash

# script from: https://github.com/aws-samples/aws-lambda-layer-create-script
# create the layer with:
# ./createlayer.sh 3.8

lib_name="helpertools"
lib_dir="../../../lib/helpertools"

if [ "$1" != "" ] || [$# -gt 1]; then
	echo "Creating layer compatible with python version $1"
	rm  -rf $lib_name
	# ln -s $lib_dir $lib_name  #cannot use sym link in docker
	cp -r $lib_dir .
	docker run -v "$PWD":/var/task "lambci/lambda:build-python$1" /bin/sh -c "pip install $lib_name/ -t python/lib/python$1/site-packages/ --upgrade; exit"
	zip -r $lib_name.zip python > /dev/null
	rm -rf $lib_name
	echo "Done creating layer!"
else
	echo "Enter python version as argument - ./createlayer.sh 3.6"
fi