#!/bin/sh

targets=(
  "DatePicker-1"
  "DatePicker_date-1"
  "DatePicker_hourAndMinute-1"
)

for target in ${targets[@]}; do
  file="$target.png"
  convert -composite -gravity NorthEast $file "9h41m@45mm.png" $file
  echo "$file set to 9:41."
done
