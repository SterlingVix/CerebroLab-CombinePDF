#!/bin/zsh

# Define the path to the root and "Research References" directory
ROOT_DIR=$(pwd)
RESEARCH_DIR="pdf-in/Research References"
OUTPUT_DIR="$(pwd)/pdf-out"

# Ensure the directory exists before proceeding
if [[ ! -d "$RESEARCH_DIR" ]]; then
  echo "Error: Directory '$RESEARCH_DIR' does not exist."
  exit 1
fi

# Loop through each subdirectory in "Research References"
cd $RESEARCH_DIR
for dir in */; do
  # Remove the trailing slash to get the directory name
  CURRENT_DIR="${dir%/}"

  # Change into the directory and populate the temporary folder.
  cd "$CURRENT_DIR" || continue

  TEMP_FOLDER_NAME="temp"

  # Remove any existing temp dir.
  if [[ -d "$TEMP_FOLDER_NAME" ]]; then
    echo "Removing \"$TEMP_FOLDER_NAME\" dir."
    rm -r $TEMP_FOLDER_NAME
  fi
  mkdir "$TEMP_FOLDER_NAME"
  sleep 1

  # Store Cover Page and Output Filename in variables.
  COVER_PAGE="_ $CURRENT_DIR.pdf"
  # FILES_TO_MERGE="\"$COVER_PAGE\"" # Populate first filename to merge from the Cover Page info.
  FILES_TO_MERGE=""
  OUTPUT_FILENAME=\"$OUTPUT_DIR/$CURRENT_DIR.pdf\"
  

  # Collect filenames but omit the one matching COVER_PAGE
  for file in *; do
    [[ "$file" == "$COVER_PAGE" ]] && continue  # Skip COVER_PAGE
    [[ "$file" == "$TEMP_FOLDER_NAME" ]] && continue  # Skip temp folder
    # FILES_TO_MERGE="$FILES_TO_MERGE \"$file\""
    TEMP_FILE=\"$TEMP_FOLDER_NAME/$file\"

    echo "Creating padded temp file $TEMP_FILE"

    PAD_COMMAND="cpdf -pad-before \"$file\" 1, -o $TEMP_FILE"
    eval "$PAD_COMMAND"
    sleep 1

    FILES_TO_MERGE="$FILES_TO_MERGE $TEMP_FILE"    
  done

  echo "--> Creating file $OUTPUT_FILENAME."
  echo ""

  merge_command="cpdf -merge $FILES_TO_MERGE -o $OUTPUT_FILENAME"
  eval "$merge_command"
  # echo "$merge_command"

  # Return to the previous directory
  sleep 1
  cd ..
done

echo "Returning to root dir \"$ROOT_DIR\"."
cd $ROOT_DIR