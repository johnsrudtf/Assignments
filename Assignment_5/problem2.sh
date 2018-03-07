#!/bin/bash

if [ -d $1 ] ; then 
echo "$1 is a directory";
elif [ -f $1 ] ; then
echo "$1 is a file";
else
echo "$1 not file or directory"
fi

permissions=""
if [[ -r $1 ]] ; then
permissions="read"
fi
if [[ -x $1 ]] ; then
permissions="${permissions}, execute"
fi
if [[ -w $1 ]] ; then
permissions="${permissions}, write"
fi

if [[ $permissions ]] ; then
echo "permissions are $permissions"
else
echo "no permissions"
fi

