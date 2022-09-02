#!/bin/sh

targets=(
  "DatePicker-1"
  "DatePicker-2"
  "DatePicker_date-1"
  "DatePicker_date-2"
  "DatePicker_hourAndMinute-1"
)

for target in ${targets[@]}; do
  file="$target.png"
  convert -composite -gravity NorthEast $file "10h09m@45mm.png" $file
  echo "$file set to 10:09."
done
