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

#####
# Functions
#####

# Define the function to process each subdirectory
process_directory() {
  local CURRENT_DIR="$1"

  # Store Cover Page and Output Filename in variables
  local COVER_PAGE="_ $CURRENT_DIR.pdf"
  local FILES_TO_MERGE=""
  local OUTPUT_FILENAME=\"$OUTPUT_DIR/$CURRENT_DIR.pdf\"

  # Change into the directory and populate the temporary folders
  #    SELECTED_FOLDER="$RESEARCH_DIR/$choice"
#  cd "$CURRENT_DIR" || return
  cd "$RESEARCH_DIR/$CURRENT_DIR" || return

  # Remove any existing padded & cover page temp dirs
  local PADDED_FOLDER_NAME="_padded"
  if [[ -d "$PADDED_FOLDER_NAME" ]]; then
    echo "Removing \"$PADDED_FOLDER_NAME\" dir."
    rm -r "$PADDED_FOLDER_NAME"
  fi
  mkdir "$PADDED_FOLDER_NAME"

  local COVER_PAGE_FOLDER_NAME="_cover"
  if [[ -d "$COVER_PAGE_FOLDER_NAME" ]]; then
    echo "Removing \"$COVER_PAGE_FOLDER_NAME\" dir."
    rm -r "$COVER_PAGE_FOLDER_NAME"
  fi
  mkdir "$COVER_PAGE_FOLDER_NAME"

  # Transform pdf docs to add titled cover page with delimiters and build concatenated final filenames
  for file in *.pdf; do
    [[ "$file" == "$COVER_PAGE" ]] && continue  # Skip COVER_PAGE
    [[ "$file" == "$PADDED_FOLDER_NAME" ]] && continue  # Skip temp padded folder
    [[ "$file" == "$COVER_PAGE_FOLDER_NAME" ]] && continue  # Skip temp cover page folder

    echo ""
    echo "Transforming file \"$file\":"
    echo "...adding cover page..."
    local PADDED_FILE=\"$PADDED_FOLDER_NAME/$file\"
    local PAD_COMMAND="cpdf -pad-before \"$file\" 1, -o $PADDED_FILE"
    eval "$PAD_COMMAND"

    echo "...adding text to cover page..."
    local COVER_PAGE_FILE=\"$COVER_PAGE_FOLDER_NAME/$file\"
    local COVER_PAGE_COMMAND="cpdf -add-text \"\n\n******\n\n$file\n\n******\n\n\" -font \"Courier\" $PADDED_FILE 1, -o $COVER_PAGE_FILE"
    eval "$COVER_PAGE_COMMAND"

    FILES_TO_MERGE="$FILES_TO_MERGE $COVER_PAGE_FILE"
  done

  # Create the merged file
  echo ""
  echo "  --> Creating file $OUTPUT_FILENAME."
  local merge_command="cpdf -merge $FILES_TO_MERGE -o $OUTPUT_FILENAME"
  eval "$merge_command"

  # Return to the previous directory
  sleep 1
  cd ..
}


#####
# User prompt and processing
#####

# Get the list of subdirectories (folders) in "Research References"
folders=("$RESEARCH_DIR"/*/)
folders=("${folders[@]%/}")  # Remove trailing slashes

# Ensure there are folders to choose from
if [[ ${#folders[@]} -eq 0 ]]; then
  echo "No folders found in '$RESEARCH_DIR'."
  exit 1
fi

# Display the selection prompt
echo "Select which Research References collection you would like to combine PDFs for:"

# Present options to the user in a numbered list
select choice in "${folders[@]##*/}"; do
  if [[ -n "$choice" ]]; then
#    SELECTED_FOLDER="$RESEARCH_DIR/$choice"
    SELECTED_FOLDER="$choice"
    break
  else
    echo "Invalid selection. Please try again."
  fi
done

# The chosen directory is now stored in SELECTED_FOLDER
echo "You selected: $SELECTED_FOLDER"

# Now you can use $SELECTED_FOLDER for further processing in your script.



process_directory "$SELECTED_FOLDER"


####
## ALL directories
####
## Loop through each subdirectory in "Research References"
#cd $RESEARCH_DIR
## Iterate through each subdirectory and process it
#for dir in */; do
#  # Remove the trailing slash to get the directory name
#  dir="${dir%/}"
#  process_directory "$dir"
#done

echo "Returning to root dir \"$ROOT_DIR\"."
cd $ROOT_DIR
