#!/bin/bash
# NAME
#     to-json - converts the `dictionary.csv` file to a JSON array
#
# Should be run from the same directory as `dictionary.csv`

input_file="dictionary.csv"
output_file="dictionary.json"
indent="  "

# Read number of lines in CSV file, ultimately used to avoid printing
# comma after final JSON object
lines=`wc -l ${input_file} | cut -f1 -d' '`
i=1

# Outermost opening brace
echo "{" > "${output_file}"

# Open main array
echo "${indent}\"terms\": [" >> "${output_file}"

while read line
do
  english="${line%%,*}"
  slovene="${line#*,}"

  # Opening brace for this term object
  echo "${indent}${indent}{" >> "${output_file}"

  echo "${indent}${indent}${indent}\"english\": \"${english}\"," >> "${output_file}"
  echo "${indent}${indent}${indent}\"slovene\": \"${slovene}\"" >> "${output_file}"

  # Avoid printing comma for final JSON object
  if [ ${i} -lt ${lines} ]; then
    # Closing brace for current object with trailing comma
    echo "${indent}${indent}}," >> "${output_file}"
  else
    # Closing brace for final object without trailing comma
    echo "${indent}${indent}}" >> "${output_file}"
  fi
  i=$((i+1))
done < "${input_file}"

# Close main array
echo "  ]" >> "${output_file}"

# Outermost closing brace
echo "}" >> "${output_file}"
