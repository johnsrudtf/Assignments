#!/bin/bash

mkdir extract
cp $1 extract/${1}
cd extract
tar -xzf $1
rm $1
for file in  $( ls ); do
ext="${file##*.}"
if ! [ $file == $ext ]; then
	if ! [[ -z "${ext// }" ]]; then
		if ! [ -d $ext ]; then
		mkdir $ext
		fi
	mv $file ${ext}/${file}
	fi
fi
done
cd ..
files=$1
filebase="${files%.*}"
filename="${filebase%.*}"
tar -czvf ${filename}_clean.tar.gz extract
rm -r extract

