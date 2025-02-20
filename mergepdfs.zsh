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

  # Store Cover Page and Output Filename in variables.
  COVER_PAGE="_ $CURRENT_DIR.pdf"
  FILES_TO_MERGE=""
  OUTPUT_FILENAME=\"$OUTPUT_DIR/$CURRENT_DIR.pdf\"

  # Change into the directory and populate the temporary folders.
  cd "$CURRENT_DIR" || continue

  # Remove any existing padded & cover page temp dirs.
  PADDED_FOLDER_NAME="_padded"
  if [[ -d "$PADDED_FOLDER_NAME" ]]; then
    echo "Removing \"$PADDED_FOLDER_NAME\" dir."
    rm -r $PADDED_FOLDER_NAME
  fi
  mkdir "$PADDED_FOLDER_NAME"

  COVER_PAGE_FOLDER_NAME="_cover"
  if [[ -d "$COVER_PAGE_FOLDER_NAME" ]]; then
    echo "Removing \"$COVER_PAGE_FOLDER_NAME\" dir."
    rm -r $COVER_PAGE_FOLDER_NAME
  fi
  mkdir "$COVER_PAGE_FOLDER_NAME"

  # Transform pdf docs to add titled cover page with
  #  delimiters and build concatenated final filenames.
  for file in *.pdf; do
    [[ "$file" == "$COVER_PAGE" ]] && continue  # Skip COVER_PAGE
    [[ "$file" == "$PADDED_FOLDER_NAME" ]] && continue  # Skip temp padded folder
    [[ "$file" == "$COVER_PAGE_FOLDER_NAME" ]] && continue  # Skip temp cover page folder

    echo ""
    echo "Transforming file \"$file\":"
    echo "...adding cover page..."
    PADDED_FILE=\"$PADDED_FOLDER_NAME/$file\"
    PAD_COMMAND="cpdf -pad-before \"$file\" 1, -o $PADDED_FILE"
    eval "$PAD_COMMAND"

    echo "...adding text to cover page..."
    COVER_PAGE_FILE=\"$COVER_PAGE_FOLDER_NAME/$file\"
    COVER_PAGE_COMMAND="cpdf -add-text \"\n\n******\n\n$file\n\n******\n\n\" -font \"Courier\" $PADDED_FILE 1, -o $COVER_PAGE_FILE"
    eval "$COVER_PAGE_COMMAND"

    FILES_TO_MERGE="$FILES_TO_MERGE $COVER_PAGE_FILE"
  done
  
  # Create the merged file.
  echo ""
  echo "  --> Creating file $OUTPUT_FILENAME."
  merge_command="cpdf -merge $FILES_TO_MERGE -o $OUTPUT_FILENAME"
  eval "$merge_command"

  # Return to the previous directory
  sleep 1
  cd ..
done

echo "Returning to root dir \"$ROOT_DIR\"."
cd $ROOT_DIR