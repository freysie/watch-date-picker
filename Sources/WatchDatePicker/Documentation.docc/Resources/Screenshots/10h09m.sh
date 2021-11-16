#!/bin/sh

targets=(
  "DateAndTimeMode-1"
  "DateMode-1"
  "TimeMode-1"
)

for target in ${targets[@]}; do
  file="$target.png"
  convert -composite -gravity NorthEast $file "10h09m@45mm.png" $file
  echo "$file set to 10:09."
done
