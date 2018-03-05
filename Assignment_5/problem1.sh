#!/bin/bash
count=$1
while [ $count -le $2 ];
	do
	echo $count
	((count++))
done

