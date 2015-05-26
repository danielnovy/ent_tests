#!/bin/bash

rm -f results*.txt
rm -f throughput.txt
echo "Entropy,pChi,Mean,Monte-Pi,Correlation"

for blocks in 64 128 256 512 1024 2048
  do
  for i in {1..10} 
  do
    dd if=/dev/urandom of=random-$blocks-$i.dat count=$blocks 2>&1 | grep MB|cut -d' ' -f8 >> throughput.txt
    ./ent -t random-$blocks-$i.dat >> results-$blocks.txt
    rm random-$blocks-$i.dat
    sleep 1
  done
  awk -F',' '{ total1 += $3; total2 += $4; total3 += $5; total4 += $6; total5 += $7; count++; } END { printf "%f,%f,%f,%f,%f\n",total1/count,total2/count,total3/count,total4/count,total5/count }' results-$blocks.txt
done
awk '{ total1 += $1; count++; } END { printf "Avg Throughput: %f MB/s\n",total1/count }' throughput.txt

