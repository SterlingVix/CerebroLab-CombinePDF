#!/bin/zsh

# Loop through each subdirectory in the current directory
for dir in */; do
  # Remove the trailing slash to get the directory name
  dirname="${dir%/}"

  ### IS THIS CORRECT?
  # Assign directory name to a variable
  current_dir="$dirname"


  # Change into the directory
  # Change to the directory
  cd "$current_dir" || continue
  # cd "$dirname" || continue

  # Store Cover Page and Output Filename in variables.
  COVER_PAGE="\"_ $current_dir.pdf\""
  echo "COVER_PAGE: $COVER_PAGE"

  OUTPUT_FILENAME=\"$current_dir.pdf\"
  echo "OUTPUT_FILENAME: $OUTPUT_FILENAME"

  # Echo the filenames in this directory
  echo "Files in $current_dir:"
  #echo "Contents of $dirname:"
  
  # List files but omit the one matching COVER_PAGE
  for file in *; do
    [[ "$file" == "$COVER_PAGE" ]] && continue  # Skip COVER_PAGE
    echo "$file"
  done

  # ls -p | grep -v /
  # echo *
  # echo "cpdf -merge \"_ $current_dir.pdf\" -o \"$current_dir.pdf\""
  # echo "cpdf -merge \"_ $current_dir.pdf\" $(printf '"%s" ' *.*(N)) -o \"$current_dir.pdf\""
  merge_command="cpdf -merge $COVER_PAGE $(printf '"%s" ' *.*(N)) -o $OUTPUT_FILENAME"
  echo ""
  echo ""
  echo "$merge_command"
  echo ""
  echo ""
  # echo "cpdf -merge \"_ $current_dir.pdf\" $(echo *) -o \"$current_dir.pdf\""
  

  # Return to the original directory
  cd ..
done
