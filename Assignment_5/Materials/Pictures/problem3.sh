#!/bin/bash
# arguments are: what to rename as, extension of files to rename, directory to look though

count=1
for file in *.${2}
do
 mv "$file" "${1}${count}.${2}"
 (( count++ ))
done


