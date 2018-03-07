#!/bin/bash
# argument is text file

tot=0
count=0
while read -r line; do
score=${line:(-2)}

if [ $score -eq 00 ]; then
score=${line:(-3)}
fi

tot=$(( $tot+$score ))
(( count++ ))
done < "$1"

echo "scale=2; $tot/$count" | bc

